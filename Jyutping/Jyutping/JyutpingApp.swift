import Cocoa
import InputMethodKit

final class PrincipalApplication: NSApplication {

        private let appDelegate = AppDelegate()

        override init() {
                super.init()
                self.delegate = appDelegate
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) { fatalError() }
}

@main
final class AppDelegate: NSObject, NSApplicationDelegate {

        var server: IMKServer?

        func applicationDidFinishLaunching(_ notification: Notification) {
                let name: String = (Bundle.main.infoDictionary?["InputMethodConnectionName"] as? String) ?? "org.jyutping.inputmethod.Jyutping_Connection"
                server = IMKServer(name: name, bundleIdentifier: Bundle.main.bundleIdentifier)
        }
}
