import SwiftUI
import CommonExtensions

struct NavigationTrailingBackButton: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                HStack(spacing: 0) {
                        TransparentButton(width: 12, height: PresetConstant.buttonLength, action: action)
                        if #available(iOSApplicationExtension 26.0, *) {
                                Button(action: action) {
                                        ZStack{
                                                Color.interactiveClear
                                                Image.chevronUp
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding(12)
                                        }
                                        .frame(width: PresetConstant.buttonLength, height: PresetConstant.buttonLength)
                                }
                                .buttonStyle(.plain)
                                .glassEffect(.clear, in: .circle)
                        } else {
                                Button(action: action) {
                                        ZStack{
                                                Color.interactiveClear
                                                Image.chevronUp
                                                        .resizable()
                                                        .scaledToFit()
                                                        .padding(12)
                                        }
                                        .frame(width: PresetConstant.buttonLength, height: PresetConstant.buttonLength)
                                }
                                .buttonStyle(.plain)
                        }
                        TransparentButton(width: 4, height: PresetConstant.buttonLength, action: action)
                }
        }
        private func action() {
                AudioFeedback.modified()
                context.triggerHapticFeedback()
                context.updateKeyboardForm(to: context.previousKeyboardForm)
        }
}
