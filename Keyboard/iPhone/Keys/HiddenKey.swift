import SwiftUI

struct HiddenKey: View {

        @EnvironmentObject private var context: KeyboardViewController

        let key: HiddenEvent

        var body: some View {
                Color.interactiveClear
                        .frame(height: context.heightUnit)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                                if key == .backspace {
                                        AudioFeedback.deleted()
                                        context.triggerHapticFeedback()
                                        context.operate(.backspace)
                                } else if let letter = key.letter {
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                        let text: String = context.keyboardCase.isLowercased ? letter : letter.uppercased()
                                        context.operate(.process(text))
                                }
                        }
        }
}

enum HiddenEvent: Int {

        case letterA
        case letterL
        case letterZ
        case backspace

        var letter: String? {
                switch self {
                case .letterA:
                        return "a"
                case .letterL:
                        return "l"
                case .letterZ:
                        return "z"
                case .backspace:
                        return nil
                }
        }
}

struct PlaceholderKey: View {
        var body: some View {
                Color.clear.frame(maxWidth: .infinity)
        }
}
