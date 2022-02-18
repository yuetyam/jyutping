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
                switch colorScheme {
                case .dark:
                        if #available(iOS 15.0, *) {
                                return Color(uiColor: UIColor.systemBackground)
                        } else {
                                return Color(UIColor.systemBackground)
                        }
                default:
                        if #available(iOS 15.0, *) {
                                return Color(uiColor: UIColor.secondarySystemBackground)
                        } else {
                                return Color(UIColor.secondarySystemBackground)
                        }
                }
        }
        private let length: CGFloat = 32

        @State private var isSpeaking: Bool = false
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                if isSpeaking {
                        Image.speaking
                                .resizable()
                                .scaledToFit()
                                .padding(.leading, 6)
                                .frame(width: length, height: length)
                                .foregroundColor(.blue)
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
                                Circle().foregroundColor(background)
                                Image.speaker
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.blue)
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


struct Speaker_Previews: PreviewProvider {
        static var previews: some View {
                Speaker()
        }
}
