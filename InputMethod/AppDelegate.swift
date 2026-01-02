import Foundation
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

        func applicationWillFinishLaunching(_ notification: Notification) {
                NSWindow.allowsAutomaticWindowTabbing = false
        }

        private lazy var imkServer: IMKServer? = nil

        func applicationDidFinishLaunching(_ notification: Notification) {
                let name: String = (Bundle.main.infoDictionary?["InputMethodConnectionName"] as? String) ?? "org.jyutping.inputmethod.Jyutping_Connection"
                let identifier: String = Bundle.main.bundleIdentifier ?? "org.jyutping.inputmethod.Jyutping"
                imkServer = IMKServer(name: name, bundleIdentifier: identifier)
                NSApplication.shared.setActivationPolicy(.accessory)
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
                let url = Bundle.main.bundleURL
                TISRegisterInputSource(url as CFURL)
        }
        private static func activate() {
                let bundleID: String = Bundle.main.bundleIdentifier ?? "org.jyutping.inputmethod.Jyutping"
                let inputSourceID: String = bundleID
                let properties = NSMutableDictionary()
                properties.setValue(bundleID, forKey: kTISPropertyBundleID as String)
                properties.setValue(inputSourceID, forKey: kTISPropertyInputSourceID as String)
                guard let inputSourceList = TISCreateInputSourceList(properties, true)?.takeRetainedValue() as? [TISInputSource] else { return }
                for inputSource in inputSourceList {
                        TISEnableInputSource(inputSource)
                }
        }
}

extension Logger {
        static let shared: Logger = Logger(subsystem: "org.jyutping.inputmethod.Jyutping", category: "inputmethod")
}

extension Notification.Name {
        static let contentSize = Notification.Name("org.jyutping.inputmethod.Jyutping.Notification.contentSize")
        static let highlightIndex = Notification.Name("org.jyutping.inputmethod.Jyutping.Notification.highlightIndex")
        static let selectIndex = Notification.Name("org.jyutping.inputmethod.Jyutping.Notification.selectIndex")
}
struct NotificationKey {
        static let contentSize: String = "NotificationKey.contentSize"
        static let highlightIndex: String = "NotificationKey.highlightIndex"
        static let selectIndex: String = "NotificationKey.selectIndex"
}
