import SwiftUI

struct CandidateBar: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                HStack(spacing: 0) {
                        if #available(iOSApplicationExtension 18.0, *) {
                                CandidateBarScrollViewIOS18()
                        } else if #available(iOSApplicationExtension 17.0, *) {
                                CandidateBarScrollViewIOS17()
                        } else {
                                CandidateBarScrollView()
                        }
                        Button {
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.updateKeyboardForm(to: .candidateBoard)
                        } label: {
                                ZStack {
                                        ZStack(alignment: .leading) {
                                                Color.interactiveClear
                                                Rectangle()
                                                        .fill(Color.primary.opacity(0.3))
                                                        .frame(width: 1, height: 24)
                                        }
                                        Image.chevronDown
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                }
                        }
                        .buttonStyle(.plain)
                        .frame(width: PresetConstant.collapseWidth)
                        .frame(maxHeight: .infinity)
                }
                .frame(height: context.topBarHeight)
        }
}
