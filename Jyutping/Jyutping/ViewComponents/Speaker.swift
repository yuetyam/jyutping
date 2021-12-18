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
                                return Color.black
                        }
                default:
                        if #available(iOS 15.0, *) {
                                return Color(uiColor: UIColor.secondarySystemBackground)
                        } else {
                                return Color(.displayP3, red: 242.0 / 255.0, green: 242.0 / 255.0, blue: 247.0 / 255.0)
                        }
                }
        }

        @State private var isSpeaking: Bool = false
        private let length: CGFloat = 30
        private let speakingImageName: String = {
                if #available(iOS 14.0, *) {
                        return "speaker.wave.3.fill"
                } else {
                        return "speaker.3.fill"
                }
        }()

        var body: some View {
                if isSpeaking {
                        Image(systemName: speakingImageName)
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
