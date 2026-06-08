import SwiftUI
import CommonExtensions

struct Speaker: View {

        private let text: String?
        private let action: (() -> Void)?

        init(_ text: String? = nil, action: (() -> Void)? = nil) {
                self.text = text
                self.action = action
        }

        #if os(iOS)
        private let length: CGFloat = 32
        private let speakerLength: CGFloat = 20
        private let speakingLeadingPadding: CGFloat = 6
        private let speakingTrailingPadding: CGFloat = 2
        #else
        private let length: CGFloat = 24
        private let speakerLength: CGFloat = 16
        private let speakingLeadingPadding: CGFloat = 4
        private let speakingTrailingPadding: CGFloat = 1
        #endif

        @State private var isSpeaking: Bool = false

        var body: some View {
                Button(action: handleTap) {
                        ZStack {
                                if #available(iOS 17.0, macOS 14.0, *) {
                                        Circle()
                                                #if os(macOS)
                                                .fill(Color.textBackgroundColor.opacity(0.66))
                                                #else
                                                .fill(Material.regular)
                                                #endif
                                        Image.speaking
                                                .resizable()
                                                .scaledToFit()
                                                .symbolEffect(.variableColor.iterative, isActive: isSpeaking)
                                                .foregroundStyle(Color.accentColor)
                                                .padding(.leading, speakingLeadingPadding)
                                                .padding(.trailing, speakingTrailingPadding)
                                                .opacity(isSpeaking ? 1 : 0)
                                } else {
                                        Circle()
                                                #if os(macOS)
                                                .fill(Color.textBackgroundColor.opacity(0.66))
                                                #else
                                                .fill(Material.regular)
                                                #endif
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
