import SwiftUI
import CoreIME

struct StrokeKeyboard: View {

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
                        HStack(spacing: 0 ) {
                                StrokeInputKey(.letterQ)
                                StrokeInputKey(.letterW)
                                StrokeInputKey(.letterE)
                                StrokeInputKey(.letterR)
                                StrokeInputKey(.letterT)
                                StrokeInputKey(.letterY)
                                StrokeInputKey(.letterU)
                                StrokeInputKey(.letterI)
                                StrokeInputKey(.letterO)
                                StrokeInputKey(.letterP)
                        }
                        HStack(spacing: 0) {
                                HiddenKey(key: .letterA)
                                Group {
                                        StrokeInputKey(.letterA)
                                        StrokeInputKey(.letterS)
                                        StrokeInputKey(.letterD)
                                        StrokeInputKey(.letterF)
                                        StrokeInputKey(.letterG)
                                        StrokeInputKey(.letterH)
                                        StrokeInputKey(.letterJ)
                                        StrokeInputKey(.letterK)
                                        StrokeInputKey(.letterL)
                                }
                                HiddenKey(key: .letterL)
                        }
                        HStack(spacing: 0) {
                                ShiftKey()
                                HiddenKey(key: .letterZ)
                                Group {
                                        StrokeInputKey(.letterZ)
                                        StrokeInputKey(.letterX)
                                        StrokeInputKey(.letterC)
                                        StrokeInputKey(.letterV)
                                        StrokeInputKey(.letterB)
                                        StrokeInputKey(.letterN)
                                        StrokeInputKey(.letterM)
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
