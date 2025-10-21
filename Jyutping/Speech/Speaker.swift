import SwiftUI
import Combine
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
        private let speakingLeading: CGFloat = 6
        #else
        private let length: CGFloat = 24
        private let speakerLength: CGFloat = 16
        private let speakingLeading: CGFloat = 4
        #endif

        @State private var isSpeaking: Bool = false
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                if isSpeaking {
                        Image.speaking
                                .resizable()
                                .scaledToFit()
                                .padding(.leading, speakingLeading)
                                .frame(width: length, height: length)
                                .foregroundStyle(Color.accentColor)
                                .onTapGesture {
                                        Speech.stop()
                                        isSpeaking = false
                                }
                                .onReceive(timer) { _ in
                                        if Speech.isSpeaking.negative {
                                                isSpeaking = false
                                        }
                                }
                } else {
                        ZStack {
                                Circle()
                                        #if os(macOS)
                                        .fill(Color.textBackgroundColor.opacity(0.66))
                                        #else
                                        .fill(Material.regular)
                                        #endif
                                Image.speaker
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: speakerLength, height: speakerLength)
                                        .foregroundStyle(Color.accentColor)
                        }
                        .frame(width: length, height: length)
                        .contentShape(Rectangle())
                        .onTapGesture {
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
}
