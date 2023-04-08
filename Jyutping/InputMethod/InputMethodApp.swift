import AppKit
import InputMethodKit
import CoreIME

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

        private(set) var server: IMKServer?

        func applicationDidFinishLaunching(_ notification: Notification) {
                handleCommandLineArguments()
                let name: String = (Bundle.main.infoDictionary?["InputMethodConnectionName"] as? String) ?? "org_jyutping_inputmethod_Jyutping_Connection"
                let identifier = Bundle.main.bundleIdentifier
                server = IMKServer(name: name, bundleIdentifier: identifier)
        }

        private func handleCommandLineArguments() {
                let shouldInstall: Bool = CommandLine.arguments.contains("install")
                guard shouldInstall else { return }
                deactivate()
                register()
                activate()
                NSRunningApplication.current.terminate()
                NSApp.terminate(self)
                exit(0)
        }

        private func register() {
                let url = Bundle.main.bundleURL
                let cfUrl = url as CFURL
                TISRegisterInputSource(cfUrl)
        }
        private func activate() {
                let inputSourceID: String = "org.jyutping.inputmethod.Jyutping"
                let inputModeID: String = "org.jyutping.inputmethod.Jyutping.JyutpingIM"
                guard let inputSourceList = TISCreateInputSourceList(nil, true).takeRetainedValue() as? [TISInputSource] else { return }
                for item in inputSourceList {
                        guard let pointer = TISGetInputSourceProperty(item, kTISPropertyInputSourceID) else { return }
                        let sourceID = Unmanaged<CFString>.fromOpaque(pointer).takeUnretainedValue() as String
                        guard sourceID == inputSourceID || sourceID == inputModeID else { return }
                        TISEnableInputSource(item)
                }
        }
        private func deactivate() {
                let inputSourceID: String = "org.jyutping.inputmethod.Jyutping"
                let inputModeID: String = "org.jyutping.inputmethod.Jyutping.JyutpingIM"
                guard let inputSourceList = TISCreateInputSourceList(nil, true).takeRetainedValue() as? [TISInputSource] else { return }
                for item in inputSourceList {
                        guard let pointer = TISGetInputSourceProperty(item, kTISPropertyInputSourceID) else { return }
                        let sourceID = Unmanaged<CFString>.fromOpaque(pointer).takeUnretainedValue() as String
                        guard sourceID == inputSourceID || sourceID == inputModeID else { return }
                        guard let pointer2IsEnabled = TISGetInputSourceProperty(item, kTISPropertyInputSourceIsEnabled) else { return }
                        let isEnabled = Unmanaged<CFBoolean>.fromOpaque(pointer2IsEnabled).takeRetainedValue()
                        guard CFBooleanGetValue(isEnabled) else { return }
                        TISDisableInputSource(item)
                }
        }
}
