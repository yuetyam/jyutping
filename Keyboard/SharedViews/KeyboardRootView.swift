import SwiftUI

struct KeyboardRootView: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                if #available(iOSApplicationExtension 26.0, *) {
                        switch context.appearanceStyle {
                        case .clean:
                                CleanMotherBoard()
                        case .glass:
                                GlassMotherBoard()
                        case .classic:
                                ClassicMotherBoard()
                        default:
                                CleanMotherBoard()
                        }
                } else {
                        ClassicMotherBoard()
                }
        }
}


// TODO: - Implement two different boards

private typealias CleanMotherBoard = LegacyMotherBoard

private typealias ClassicMotherBoard = LegacyMotherBoard
