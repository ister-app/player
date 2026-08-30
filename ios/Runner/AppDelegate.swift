import AVFAudio
import Flutter
import MediaPlayer
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
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
