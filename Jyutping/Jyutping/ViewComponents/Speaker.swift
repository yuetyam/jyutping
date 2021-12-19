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

        @State private var isSpeaking: Bool = false
        private let length: CGFloat = 30

        var body: some View {
                if isSpeaking {
                        Image.speaking
                                .resizable()
                                .scaledToFit()
                                .padding(.leading, 6)
                                .frame(width: length, height: length)
                                .foregroundColor(.blue)
                } else {
                        ZStack {
                                Circle().foregroundColor(background)
                                Image.speaker
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 18, height: 18)
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        isSpeaking = false
                                }
                        }
                }
        }
}


struct Speaker_Previews: PreviewProvider {
        static var previews: some View {
                Speaker()
        }
}
