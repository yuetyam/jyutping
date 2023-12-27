import SwiftUI

struct Speaker: View {

        private let text: String?
        private let action: (() -> Void)?

        init(_ text: String? = nil, action: (() -> Void)? = nil) {
                self.text = text
                self.action = action
        }

        @Environment(\.colorScheme) private var colorScheme
        private var background: Color {
                return Color.backgroundColor(colorScheme: colorScheme)
        }
        private let length: CGFloat = {
                #if os(iOS)
                return 32
                #else
                return 24
                #endif
        }()
        private let speakerLength: CGFloat = {
                #if os(iOS)
                return 20
                #else
                return 16
                #endif
        }()
        private let speakingLeading: CGFloat = {
                #if os(iOS)
                return 6
                #else
                return 4
                #endif
        }()

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
                                        if !(Speech.isSpeaking) {
                                                isSpeaking = false
                                        }
                                }
                } else {
                        ZStack {
                                Circle().foregroundStyle(background)
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
                                if let text = text {
                                        Speech.speak(text)
                                }
                                action?()
                        }
                }
        }
}
