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
                // let name: String = (Bundle.main.infoDictionary?["InputMethodConnectionName"] as? String) ?? "org_jyutping_inputmethod_Jyutping_Connection"
                let name: String = "org_jyutping_inputmethod_Jyutping_Connection"
                server = IMKServer(name: name, bundleIdentifier: Bundle.main.bundleIdentifier)
        }

        private func handleCommandLineArguments() {
                let shouldInstall: Bool = CommandLine.arguments.contains("install")
                guard shouldInstall else { return }
                register()
                deactivate()
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
        private func deactivate() {
                guard let inputSourceList = TISCreateInputSourceList(nil, true).takeRetainedValue() as? [TISInputSource] else { return }
                let inputSourceID: String = "org.jyutping.inputmethod.Jyutping"
                let inputModeID: String = "org.jyutping.inputmethod.Jyutping.JyutpingIM"
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
        private func activate() {
                guard let inputSourceList = TISCreateInputSourceList(nil, true).takeRetainedValue() as? [TISInputSource] else { return }
                let inputSourceID: String = "org.jyutping.inputmethod.Jyutping"
                let inputModeID: String = "org.jyutping.inputmethod.Jyutping.JyutpingIM"
                for item in inputSourceList {
                        guard let pointer = TISGetInputSourceProperty(item, kTISPropertyInputSourceID) else { return }
                        let sourceID = Unmanaged<CFString>.fromOpaque(pointer).takeUnretainedValue() as String
                        guard sourceID == inputSourceID || sourceID == inputModeID else { return }
                        TISEnableInputSource(item)
                        guard let pointer2Selectable = TISGetInputSourceProperty(item, kTISPropertyInputSourceIsSelectCapable) else { return }
                        let isSelectable = Unmanaged<CFBoolean>.fromOpaque(pointer2Selectable).takeRetainedValue()
                        guard CFBooleanGetValue(isSelectable) else { return }
                        TISSelectInputSource(item)
                }
        }
}
