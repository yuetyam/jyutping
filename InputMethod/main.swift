import AppKit
import InputMethodKit

CommandLine.handleArguments()

autoreleasepool {
        let name: String = (Bundle.main.infoDictionary?["InputMethodConnectionName"] as? String) ?? "org.jyutping.inputmethod.Jyutping_Connection"
        let identifier: String = Bundle.main.bundleIdentifier ?? "org.jyutping.inputmethod.Jyutping"
        AppDelegate.shared.server = IMKServer(name: name, bundleIdentifier: identifier)
        NSApplication.shared.delegate = AppDelegate.shared
        NSApplication.shared.run()
}
