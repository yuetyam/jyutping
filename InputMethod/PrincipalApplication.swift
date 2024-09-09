import AppKit

@MainActor
@objc(PrincipalApplication)
final class PrincipalApplication: NSApplication {

        override init() {
                super.init()
                delegate = AppDelegate.shared
        }

        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
}
