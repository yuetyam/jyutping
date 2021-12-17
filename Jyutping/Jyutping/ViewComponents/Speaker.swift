import SwiftUI

@available(iOS 15.0, *)
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
                        return Color(uiColor: UIColor.systemBackground)
                default:
                        return Color(uiColor: UIColor.secondarySystemBackground)
                }
        }

        @State private var isSpeaking: Bool = false
        private let length: CGFloat = 30

        var body: some View {
                if isSpeaking {
                        Image(systemName: "speaker.wave.3.fill")
                                .resizable()
                                .scaledToFit()
                                .padding(.leading, 6)
                                .frame(width: length, height: length)
                                .foregroundColor(.blue)
                } else {
                        ZStack {
                                Circle().foregroundColor(background)
                                Image(systemName: "speaker.wave.2")
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


@available(iOS 15.0, *)
struct Speaker_Previews: PreviewProvider {
        static var previews: some View {
                Speaker()
        }
}
