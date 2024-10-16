import SwiftUI
import CommonExtensions

struct MotherBoard: View {

        @EnvironmentObject private var context: AppContext

        var body: some View {
                ZStack(alignment: context.quadrant.alignment) {
                        Color.clear
                        if context.inputForm.isOptions {
                                OptionsView()
                        } else if context.isClean {
                                EmptyView()
                        } else {
                                CandidateBoard()
                        }
                }
        }
}
