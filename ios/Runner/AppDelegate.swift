import AVFAudio
import Flutter
import MediaPlayer
import UIKit
import UniformTypeIdentifiers

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  /// Kept alive here: the channel handler and the picker delegate live in it.
  private var uploadSource: UploadSourceChannel?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    uploadSource = UploadSourceChannel(
      messenger: engineBridge.pluginRegistry.registrar(forPlugin: "IsterUploadSource")!.messenger())
    // Read-only diagnostics for the About page: without a Mac the only way to
    // see why lock screen / CarPlay controls are missing is inside the app, so
    // this reports the effective audio-session and now-playing state at tap
    // time (the categories mpv/media_kit may have overridden included).
    let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "IsterAudioDebug")!
    let channel = FlutterMethodChannel(
      name: "app.ister.player/audio_debug", binaryMessenger: registrar.messenger())
    channel.setMethodCallHandler { call, result in
      guard call.method == "audioSessionInfo" else {
        result(FlutterMethodNotImplemented)
        return
      }
      let session = AVAudioSession.sharedInstance()
      let center = MPNowPlayingInfoCenter.default()
      let commandCenter = MPRemoteCommandCenter.shared()
      var info: [String: Any] = [
        "category": session.category.rawValue,
        "mode": session.mode.rawValue,
        "categoryOptions": session.categoryOptions.rawValue,
        "mixWithOthers": session.categoryOptions.contains(.mixWithOthers),
        "isOtherAudioPlaying": session.isOtherAudioPlaying,
        "outputs": session.currentRoute.outputs.map { "\($0.portType.rawValue)" }
          .joined(separator: ", "),
        "nowPlayingKeys": (center.nowPlayingInfo ?? [:]).keys.sorted().joined(separator: ", "),
        "nowPlayingTitle": center.nowPlayingInfo?[MPMediaItemPropertyTitle] as? String ?? "",
        "playCommandEnabled": commandCenter.playCommand.isEnabled,
        "pauseCommandEnabled": commandCenter.pauseCommand.isEnabled,
      ]
      if #available(iOS 13.0, *) {
        info["playbackState"] = "\(center.playbackState.rawValue)"
      }
      result(info)
    }
  }
}

/// The folder source of the admin upload (lib/utils/upload/upload_source_native.dart).
///
/// Access to a folder the user picked is security-scoped: it has to be opened
/// natively and stays open only as long as we say so. So the folder is listed
/// and read here, and Dart only ever sees paths relative to it and byte ranges.
/// Lives in this file on purpose: a separate Swift file would have to be added
/// to the Xcode project by hand.
final class UploadSourceChannel: NSObject, UIDocumentPickerDelegate {
  private let channel: FlutterMethodChannel
  private var pendingPick: FlutterResult?
  /// The folder we currently hold security-scoped access to.
  private var scopedRoot: URL?
  // Listing a big folder and reading from iCloud Drive both block.
  private let queue = DispatchQueue(label: "app.ister.player.upload-source", qos: .userInitiated)

  init(messenger: FlutterBinaryMessenger) {
    channel = FlutterMethodChannel(name: "app.ister.player/upload_source", binaryMessenger: messenger)
    super.init()
    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "pickFolder": self?.pickFolder(result)
      case "read": self?.read(call, result)
      default: result(FlutterMethodNotImplemented)
      }
    }
  }

  deinit {
    scopedRoot?.stopAccessingSecurityScopedResource()
  }

  private func pickFolder(_ result: @escaping FlutterResult) {
    guard pendingPick == nil else {
      result(FlutterError(code: "busy", message: "A folder picker is already open", details: nil))
      return
    }
    let window = UIApplication.shared.connectedScenes
      .compactMap { ($0 as? UIWindowScene)?.keyWindow }.first
    guard var presenter = window?.rootViewController else {
      result(FlutterError(code: "unavailable", message: "No window to present from", details: nil))
      return
    }
    while let presented = presenter.presentedViewController { presenter = presented }
    let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.folder])
    picker.delegate = self
    picker.allowsMultipleSelection = false
    pendingPick = result
    presenter.present(picker, animated: true)
  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    pendingPick?(nil)
    pendingPick = nil
  }

  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    guard let result = pendingPick else { return }
    pendingPick = nil
    guard let root = urls.first else {
      result(nil)
      return
    }
    // One folder at a time: the previous one is no longer needed once a new one is picked.
    scopedRoot?.stopAccessingSecurityScopedResource()
    scopedRoot = nil
    guard root.startAccessingSecurityScopedResource() else {
      result(FlutterError(code: "denied", message: "No access to the chosen folder", details: nil))
      return
    }
    scopedRoot = root
    queue.async {
      let rootPath = root.standardizedFileURL.path
      let prefix = rootPath.hasSuffix("/") ? rootPath : rootPath + "/"
      var files: [[String: Any]] = []
      let keys: [URLResourceKey] = [.isRegularFileKey, .fileSizeKey]
      if let walker = FileManager.default.enumerator(at: root, includingPropertiesForKeys: keys) {
        for case let file as URL in walker {
          guard let values = try? file.resourceValues(forKeys: Set(keys)),
            values.isRegularFile == true
          else { continue }
          let path = file.standardizedFileURL.path
          guard path.hasPrefix(prefix) else { continue }
          let relative = String(path.dropFirst(prefix.count))
          files.append(["id": relative, "relativePath": relative, "size": values.fileSize ?? 0])
        }
      }
      DispatchQueue.main.async {
        result(["name": root.lastPathComponent, "files": files])
      }
    }
  }

  private func read(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
      let id = args["id"] as? String,
      let offset = (args["offset"] as? NSNumber)?.uint64Value,
      let length = (args["length"] as? NSNumber)?.intValue, length > 0,
      let root = scopedRoot
    else {
      result(FlutterError(code: "bad_args", message: "id, offset and length are required", details: nil))
      return
    }
    queue.async {
      do {
        let file = root.appendingPathComponent(id).standardizedFileURL
        let rootPath = root.standardizedFileURL.path
        guard file.path.hasPrefix(rootPath.hasSuffix("/") ? rootPath : rootPath + "/") else {
          throw CocoaError(.fileReadNoPermission)
        }
        let handle = try FileHandle(forReadingFrom: file)
        defer { try? handle.close() }
        try handle.seek(toOffset: offset)
        let data = try handle.read(upToCount: length) ?? Data()
        DispatchQueue.main.async { result(FlutterStandardTypedData(bytes: data)) }
      } catch {
        DispatchQueue.main.async {
          result(FlutterError(code: "read_failed", message: error.localizedDescription, details: nil))
        }
      }
    }
  }
}
