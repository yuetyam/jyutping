import SwiftUI
import CommonExtensions

struct Speaker: View {

        @Environment(\.colorScheme) private var colorScheme

        init(_ text: String? = nil, action: (() -> Void)? = nil) {
                self.text = text
                self.action = action
        }
        private let text: String?
        private let action: (() -> Void)?

        private let length: CGFloat = 32
        private let speakerLength: CGFloat = 20
        private let speakingLeadingPadding: CGFloat = 6
        private let speakingTrailingPadding: CGFloat = 2

        @State private var isSpeaking: Bool = false

        var body: some View {
                Button(action: handleTap) {
                        ZStack {
                                if #available(iOSApplicationExtension 17.0, *) {
                                        Circle().fill(colorScheme.isDark ? Color.black : Color.white)
                                        Image.speaking
                                                .resizable()
                                                .scaledToFit()
                                                .symbolEffect(.variableColor.iterative, isActive: isSpeaking)
                                                .foregroundStyle(Color.accentColor)
                                                .padding(.leading, speakingLeadingPadding)
                                                .padding(.trailing, speakingTrailingPadding)
                                                .opacity(isSpeaking ? 1 : 0)
                                } else {
                                        Circle().fill(colorScheme.isDark ? Color.black : Color.white)
                                                .opacity(isSpeaking ? 0 : 1)
                                        Image.speaking
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundStyle(Color.accentColor)
                                                .padding(.leading, speakingLeadingPadding)
                                                .opacity(isSpeaking ? 1 : 0)
                                }
                                Image.speaker
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(Color.accentColor)
                                        .frame(width: speakerLength, height: speakerLength)
                                        .opacity(isSpeaking ? 0 : 1)
                        }
                        .frame(width: length, height: length)
                        .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .animation(.default, value: isSpeaking)
                .task(id: isSpeaking) {
                        guard isSpeaking else { return }
                        while Task.isCancelled.negative {
                                try? await Task.sleep(for: .milliseconds(100)) // 0.1s
                                if Speech.isSpeaking.negative {
                                        isSpeaking = false
                                        break
                                }
                        }
                }
        }

        private func handleTap() {
                if isSpeaking {
                        Speech.stop()
                        isSpeaking = false
                } else {
                        isSpeaking = true
                        if let text {
                                Speech.speak(text)
                        }
                        if let action {
                                action()
                        }
                }
        }
}
