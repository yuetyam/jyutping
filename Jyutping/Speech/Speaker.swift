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
        #else
        private let length: CGFloat = 24
        private let speakerLength: CGFloat = 16
        private let speakingLeadingPadding: CGFloat = 4
        #endif

        @State private var isSpeaking: Bool = false

        var body: some View {
                Button(action: handleTap) {
                        ZStack {
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
                                        .padding(.leading, speakingLeadingPadding)
                                        .foregroundStyle(Color.accentColor)
                                        .opacity(isSpeaking ? 1 : 0)
                                Image.speaker
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: speakerLength, height: speakerLength)
                                        .foregroundStyle(Color.accentColor)
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
