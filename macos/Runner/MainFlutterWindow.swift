import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    var windowFrame = self.frame
    // Match the Linux runner's default size (linux/my_application.cc); the
    // storyboard's 800x600 is cramped for the browse grids.
    windowFrame.size = NSSize(width: 1280, height: 720)
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}
