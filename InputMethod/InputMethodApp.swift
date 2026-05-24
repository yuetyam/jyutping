import AppKit

@main
struct InputMethodApp {
        static func main() {
                CommandLine.handleArguments()
                NSApplication.shared.delegate = AppDelegate.shared
                NSApplication.shared.run()
        }
}
