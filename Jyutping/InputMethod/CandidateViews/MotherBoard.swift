import SwiftUI

struct MotherBoard: View {

        @EnvironmentObject private var context: AppContext

        var body: some View {
                switch context.windowPattern {
                case .regular:
                        VStack {
                                HStack {
                                        if context.inputForm.isOptions {
                                                OptionsView().environmentObject(context)
                                        } else {
                                                CandidateBoard().environmentObject(context)
                                        }
                                        Spacer()
                                }
                                Spacer()
                        }
                case .horizontalReversed:
                        VStack {
                                HStack {
                                        Spacer()
                                        if context.inputForm.isOptions {
                                                OptionsView().environmentObject(context)
                                        } else {
                                                CandidateBoard().environmentObject(context)
                                        }
                                }
                                Spacer()
                        }
                case .verticalReversed:
                        VStack {
                                Spacer()
                                HStack {
                                        if context.inputForm.isOptions {
                                                OptionsView().environmentObject(context)
                                        } else {
                                                CandidateBoard().environmentObject(context)
                                        }
                                        Spacer()
                                }
                        }
                case .reversed:
                        VStack {
                                Spacer()
                                HStack {
                                        Spacer()
                                        if context.inputForm.isOptions {
                                                OptionsView().environmentObject(context)
                                        } else {
                                                CandidateBoard().environmentObject(context)
                                        }
                                }
                        }
                }
        }
}
