import AppKit
import InputMethodKit
import Sparkle

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {

        static let shared = AppDelegate()
        var server: IMKServer? = nil

        private override init() {
                super.init()
        }

        func applicationDidFinishLaunching(_ notification: Notification) {
                Self.shared.prepareUpdaterController()
        }

        private lazy var updaterController: SPUStandardUpdaterController? = nil
        private func prepareUpdaterController() {
                if Self.shared.updaterController == nil {
                        Self.shared.updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
                }
        }
        func checkForUpdates() {
                Self.shared.prepareUpdaterController()
                let canCheckForUpdates: Bool = Self.shared.updaterController?.updater.canCheckForUpdates ?? false
                guard canCheckForUpdates else { return }
                Self.shared.updaterController?.updater.checkForUpdates()
        }
}

extension CommandLine {
        static func handleArguments() {
                let shouldInstall: Bool = CommandLine.arguments.contains("install")
                guard shouldInstall else { return }
                register()
                activate()
                NSRunningApplication.current.terminate()
                exit(0)
        }
        private static func register() {
                let url = Bundle.main.bundleURL
                let cfUrl = url as CFURL
                TISRegisterInputSource(cfUrl)
        }
        private static func activate() {
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
}
