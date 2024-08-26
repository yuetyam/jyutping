import AppKit

@MainActor
@objc(PrincipalApplication)
final class PrincipalApplication: NSApplication {

        private static let appDelegate = AppDelegate()

        override init() {
                super.init()
                delegate = Self.appDelegate
        }

        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
}
