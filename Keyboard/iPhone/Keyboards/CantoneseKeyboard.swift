import SwiftUI
import CoreIME

struct CantoneseKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateBar()
                        } else {
                                ToolBar()
                        }
                        if Options.needsNumberRow {
                                CantoneseNumberRow()
                        }
                        switch Options.inputKeyStyle {
                        case .clear:
                                FirstLetterKeyRow()
                        case .numbers, .symbols:
                                FirstEnhancedLetterKeyRow()
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        SecondLetterKeyRow()
                                case .symbols:
                                        SecondEnhancedLetterKeyRow()
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                ShiftKey()
                                HiddenKey(key: .letterZ)
                                switch Options.inputKeyStyle {
                                case .clear, .numbers:
                                        ThirdLetterKeyRow()
                                case .symbols:
                                        ThirdEnhancedLetterKeyRow()
                                }
                                HiddenKey(key: .backspace)
                                BackspaceKey()
                        }
                        CantoneseBottomKeyRow()
                }
        }
}
