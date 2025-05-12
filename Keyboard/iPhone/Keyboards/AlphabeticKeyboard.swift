import SwiftUI
import CoreIME

// TODO: Rename to CantoneseKeyboard
struct AlphabeticKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateBar()
                        } else {
                                ToolBar()
                        }
                        HStack(spacing: 0 ) {
                                LetterInputKey(.letterQ)
                                LetterInputKey(.letterW)
                                LetterInputKey(.letterE)
                                LetterInputKey(.letterR)
                                LetterInputKey(.letterT)
                                LetterInputKey(.letterY)
                                LetterInputKey(.letterU)
                                LetterInputKey(.letterI)
                                LetterInputKey(.letterO)
                                LetterInputKey(.letterP)
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                Group {
                                        LetterInputKey(.letterA)
                                        LetterInputKey(.letterS)
                                        LetterInputKey(.letterD)
                                        LetterInputKey(.letterF)
                                        LetterInputKey(.letterG)
                                        LetterInputKey(.letterH)
                                        LetterInputKey(.letterJ)
                                        LetterInputKey(.letterK)
                                        LetterInputKey(.letterL)
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                ShiftKey()
                                HiddenKey(key: .letterZ)
                                Group {
                                        LetterInputKey(.letterZ)
                                        LetterInputKey(.letterX)
                                        LetterInputKey(.letterC)
                                        LetterInputKey(.letterV)
                                        LetterInputKey(.letterB)
                                        LetterInputKey(.letterN)
                                        LetterInputKey(.letterM)
                                }
                                HiddenKey(key: .backspace)
                                BackspaceKey()
                        }
                        switch (context.keyboardInterface.isPadFloating, context.needsInputModeSwitchKey) {
                        case (true, true):
                                HStack(spacing: 0) {
                                        GlobeKey()
                                        TransformKey(destination: .numeric, widthUnitTimes: 2)
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        case (true, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .numeric, widthUnitTimes: 2)
                                        LeftKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        case (false, true):
                                HStack(spacing: 0) {
                                        TransformKey(destination: context.preferredNumericForm, widthUnitTimes: 2)
                                        GlobeKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        case (false, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: context.preferredNumericForm, widthUnitTimes: 2)
                                        LeftKey()
                                        SpaceKey()
                                        RightKey()
                                        ReturnKey()
                                }
                        }
                }
        }
}
