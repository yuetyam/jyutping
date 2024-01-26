import AppKit
import InputMethodKit
import CoreIME

final class PrincipalApplication: NSApplication {

        private let appDelegate = AppDelegate()

        override init() {
                super.init()
                self.delegate = appDelegate
        }

        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
}

@main
final class AppDelegate: NSObject, NSApplicationDelegate {

        static var server: IMKServer? = nil

        func applicationDidFinishLaunching(_ notification: Notification) {
                handleCommandLineArguments()
                let name: String = (Bundle.main.infoDictionary?["InputMethodConnectionName"] as? String) ?? "org_jyutping_inputmethod_Jyutping_Connection"
                let identifier = Bundle.main.bundleIdentifier
                Self.server = IMKServer(name: name, bundleIdentifier: identifier)
        }

        private func handleCommandLineArguments() {
                let shouldInstall: Bool = CommandLine.arguments.contains("install")
                guard shouldInstall else { return }
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
                let kInputSourceID: String = "org.jyutping.inputmethod.Jyutping"
                let kInputModeID: String = "org.jyutping.inputmethod.Jyutping.JyutpingIM"
                guard let inputSourceList = TISCreateInputSourceList(nil, true).takeRetainedValue() as? [TISInputSource] else { return }
                for inputSource in inputSourceList {
                        guard let pointer = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID) else { return }
                        let inputSourceID = Unmanaged<CFString>.fromOpaque(pointer).takeUnretainedValue() as String
                        guard inputSourceID == kInputSourceID || inputSourceID == kInputModeID else { return }
                        TISEnableInputSource(inputSource)
                        TISSelectInputSource(inputSource)
                }
        }

        /*
        private func fetchState(of inputSource: TISInputSource) -> (isEnabled: Bool, isSelected: Bool) {
                guard let pointer2IsEnabled = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceIsEnabled) else { return (false, false) }
                let isEnabled = Unmanaged<CFBoolean>.fromOpaque(pointer2IsEnabled).takeRetainedValue()
                guard let pointer2IsSelected = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceIsSelected) else { return (CFBooleanGetValue(isEnabled), false) }
                let isSelected = Unmanaged<CFBoolean>.fromOpaque(pointer2IsSelected).takeRetainedValue()
                return (CFBooleanGetValue(isEnabled), CFBooleanGetValue(isSelected))
        }
        */
}
