import SwiftUI

struct MotherBoard: View {

        @EnvironmentObject private var context: AppContext

        var body: some View {
                ZStack(alignment: context.windowPattern.windowAlignment) {
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
