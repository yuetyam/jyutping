import AppKit
import InputMethodKit
import os.log
import Sparkle

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {

        static let shared = AppDelegate()

        private override init() {
                super.init()
        }

        private lazy var imkServer: IMKServer? = nil

        func applicationDidFinishLaunching(_ notification: Notification) {
                let name: String = (Bundle.main.infoDictionary?["InputMethodConnectionName"] as? String) ?? "org.jyutping.inputmethod.Jyutping_Connection"
                let identifier: String = Bundle.main.bundleIdentifier ?? "org.jyutping.inputmethod.Jyutping"
                imkServer = IMKServer(name: name, bundleIdentifier: identifier)
                prepareUpdaterController()
        }

        private lazy var updaterController: SPUStandardUpdaterController? = nil
        private func prepareUpdaterController() {
                if updaterController == nil {
                        updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
                }
        }
        func checkForUpdates() {
                prepareUpdaterController()
                let canCheckForUpdates: Bool = updaterController?.updater.canCheckForUpdates ?? false
                guard canCheckForUpdates else { return }
                updaterController?.updater.checkForUpdates()
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
                let path = "/Library/Input Methods/Jyutping.app"
                let url = FileManager.default.fileExists(atPath: path) ? URL(fileURLWithPath: path) : Bundle.main.bundleURL
                TISRegisterInputSource(url as CFURL)
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

extension Logger {
        static let shared: Logger = Logger(subsystem: "org.jyutping.inputmethod.Jyutping", category: "inputmethod")
}
