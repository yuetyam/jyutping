import SwiftUI
import CoreIME

struct CangjieKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        if context.inputStage.isBuffering {
                                CandidateBar()
                        } else {
                                ToolBar()
                        }
                        if Options.needsNumberRow {
                                NumberRow()
                        }
                        HStack(spacing: 0 ) {
                                CangjieInputKey(.letterQ)
                                CangjieInputKey(.letterW)
                                CangjieInputKey(.letterE)
                                CangjieInputKey(.letterR)
                                CangjieInputKey(.letterT)
                                CangjieInputKey(.letterY)
                                CangjieInputKey(.letterU)
                                CangjieInputKey(.letterI)
                                CangjieInputKey(.letterO)
                                CangjieInputKey(.letterP)
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                Group {
                                        CangjieInputKey(.letterA)
                                        CangjieInputKey(.letterS)
                                        CangjieInputKey(.letterD)
                                        CangjieInputKey(.letterF)
                                        CangjieInputKey(.letterG)
                                        CangjieInputKey(.letterH)
                                        CangjieInputKey(.letterJ)
                                        CangjieInputKey(.letterK)
                                        CangjieInputKey(.letterL)
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                ShiftKey()
                                HiddenKey(key: .letterZ)
                                Group {
                                        CangjieInputKey(.letterZ)
                                        CangjieInputKey(.letterX)
                                        CangjieInputKey(.letterC)
                                        CangjieInputKey(.letterV)
                                        CangjieInputKey(.letterB)
                                        CangjieInputKey(.letterN)
                                        CangjieInputKey(.letterM)
                                }
                                HiddenKey(key: .backspace)
                                BackspaceKey()
                        }
                        switch (context.keyboardInterface.isPadFloating, context.needsInputModeSwitchKey) {
                        case (true, true):
                                if #available(iOSApplicationExtension 26.0, *) {
                                        HStack(spacing: 0) {
                                                TransformKey(destination: .numeric, widthUnitTimes: 2)
                                                SpaceKey()
                                                ReturnKey()
                                        }
                                } else {
                                        HStack(spacing: 0) {
                                                GlobeKey()
                                                TransformKey(destination: .numeric, widthUnitTimes: 2)
                                                SpaceKey()
                                                ReturnKey()
                                        }
                                }
                        case (true, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .numeric, widthUnitTimes: 2)
                                        SpaceKey()
                                        ReturnKey()
                                }
                        case (false, true):
                                HStack(spacing: 0) {
                                        TransformKey(destination: context.preferredNumericForm, widthUnitTimes: 2)
                                        GlobeKey()
                                        SpaceKey()
                                        ReturnKey()
                                }
                        case (false, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: context.preferredNumericForm, widthUnitTimes: 2)
                                        SpaceKey()
                                        ReturnKey()
                                }
                        }
                }
        }
}
