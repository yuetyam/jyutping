import SwiftUI
import CommonExtensions

struct MotherBoard: View {

        @EnvironmentObject private var context: AppContext

        var body: some View {
                let windowPattern = context.windowPattern
                ZStack(alignment: windowPattern.windowAlignment) {
                        Color.clear
                        if context.inputForm.isOptions {
                                OptionsView()
                        } else if context.isClean {
                                EmptyView()
                        } else {
                                CandidateBoard()
                        }
                }
                .fixedSize(horizontal: windowPattern.isReversingHorizontal.negative, vertical: windowPattern.isReversingVertical.negative)
        }
}
