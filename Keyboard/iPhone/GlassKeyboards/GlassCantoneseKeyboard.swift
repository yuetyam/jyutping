import SwiftUI
import CoreIME

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassCantoneseKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateBar()
                        } else {
                                ToolBar()
                        }
                        if Options.needsNumberRow {
                                CantoneseGlassNumberRow()
                        }
                        switch Options.inputKeyStyle {
                        case .clear:
                                GlassFirstLetterKeyRow()
                        case .numbers, .symbols:
                                GlassFirstEnhancedLetterKeyRow()
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        GlassSecondLetterKeyRow()
                                case .symbols:
                                        GlassSecondEnhancedLetterKeyRow()
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                ShiftKey()
                                HiddenKey(key: .letterZ)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        GlassThirdLetterKeyRow()
                                case .symbols:
                                        GlassThirdEnhancedLetterKeyRow()
                                }
                                HiddenKey(key: .backspace)
                                BackspaceKey()
                        }
                        CantoneseBottomKeyRow()
                }
        }
}
