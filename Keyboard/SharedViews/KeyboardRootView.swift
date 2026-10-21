import SwiftUI

struct KeyboardRootView: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                if #available(iOSApplicationExtension 26.0, *) {
                        switch context.appearanceStyle {
                        case .glass:
                                GlassMotherBoard()
                        default:
                                LegacyMotherBoard()
                        }
                } else {
                        LegacyMotherBoard()
                }
        }
}
