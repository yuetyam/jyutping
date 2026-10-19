import SwiftUI

struct CandidateBar: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                HStack(spacing: 0) {
                        if #available(iOSApplicationExtension 26.0, *) {
                                CandidateBarScrollView().scrollEdgeEffectHidden()
                        } else if #available(iOSApplicationExtension 18.0, *) {
                                CandidateBarScrollView()
                        } else {
                                CandidateBarScrollViewIOS17()
                        }
                        Button {
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.updateKeyboardForm(to: .candidateBoard)
                        } label: {
                                ZStack {
                                        Color.interactiveClear
                                        ZStack(alignment: .leading) {
                                                Color.clear
                                                Rectangle()
                                                        .fill(Color.primary.opacity(0.3))
                                                        .frame(width: 1, height: 24)
                                        }
                                        Image.chevronDown
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 20, height: 20)
                                }
                                .frame(width: PresetConstant.collapseWidth)
                                .frame(maxHeight: .infinity)
                        }
                        .buttonStyle(.plain)
                }
                .frame(height: context.topBarHeight)
        }
}
