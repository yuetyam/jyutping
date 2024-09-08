import AppKit
import InputMethodKit
import CoreIME
import Sparkle

@main
@objc(AppDelegate)
final class AppDelegate: NSObject, NSApplicationDelegate {

        static let shared: AppDelegate = AppDelegate()

        private lazy var updaterController: SPUStandardUpdaterController? = nil
        func checkForUpdates() {
                let canCheckForUpdates: Bool = updaterController?.updater.canCheckForUpdates ?? false
                guard canCheckForUpdates else { return }
                updaterController?.updater.checkForUpdates()
        }

        func applicationDidFinishLaunching(_ notification: Notification) {
                handleCommandLineArguments()
                let name: String = (Bundle.main.infoDictionary?["InputMethodConnectionName"] as? String) ?? "org.jyutping.inputmethod.Jyutping_Connection"
                let identifier: String = Bundle.main.bundleIdentifier ?? "org.jyutping.inputmethod.Jyutping"
                _ = IMKServer(name: name, bundleIdentifier: identifier)
                if updaterController == nil {
                        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
                }
        }

        private func handleCommandLineArguments() {
                let shouldInstall: Bool = CommandLine.arguments.contains("install")
                guard shouldInstall else { return }
                register()
                activate()
                switchToSystemInputSource()
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
                        guard let pointer = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID) else { continue }
                        let inputSourceID = Unmanaged<CFString>.fromOpaque(pointer).takeUnretainedValue() as String
                        guard inputSourceID == kInputSourceID || inputSourceID == kInputModeID else { continue }
                        TISEnableInputSource(inputSource)
                        TISSelectInputSource(inputSource)
                }
        }

        private func switchToSystemInputSource() {
                guard let inputSourceList = TISCreateInputSourceList(nil, true).takeRetainedValue() as? [TISInputSource] else { return }
                for inputSource in inputSourceList {
                        if shouldSelect(inputSource) {
                                TISSelectInputSource(inputSource)
                                break
                        }
                }
        }
        private func shouldSelect(_ inputSource: TISInputSource) -> Bool {
                guard let pointer2ID = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceID) else { return false }
                let inputSourceID = Unmanaged<CFString>.fromOpaque(pointer2ID).takeUnretainedValue() as String
                guard inputSourceID.hasPrefix("com.apple.keylayout") else { return false }
                guard let pointer2IsSelectable = TISGetInputSourceProperty(inputSource, kTISPropertyInputSourceIsSelectCapable) else { return false }
                let isSelectable = Unmanaged<CFBoolean>.fromOpaque(pointer2IsSelectable).takeRetainedValue()
                return CFBooleanGetValue(isSelectable)
        }
}

/*
extension TISInputSource {
        var isEnabled: Bool {
                guard let pointer = TISGetInputSourceProperty(self, kTISPropertyInputSourceIsEnabled) else { return false }
                let state = Unmanaged<CFBoolean>.fromOpaque(pointer).takeRetainedValue()
                return CFBooleanGetValue(state)
        }
        var isSelected: Bool {
                guard let pointer = TISGetInputSourceProperty(self, kTISPropertyInputSourceIsSelected) else { return false }
                let state = Unmanaged<CFBoolean>.fromOpaque(pointer).takeRetainedValue()
                return CFBooleanGetValue(state)
        }
}
*/
