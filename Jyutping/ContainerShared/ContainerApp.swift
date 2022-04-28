import SwiftUI

@main
struct ContainerApp: App {
        var body: some Scene {
                WindowGroup {
                        #if os(iOS)
                        IOSContentView()
                        #else
                        MacContentView()
                        #endif
                }
        }
}
