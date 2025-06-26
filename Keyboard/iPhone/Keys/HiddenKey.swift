import SwiftUI
import CoreIME
import CommonExtensions

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
                                } else if let inputEvent = key.inputEvent {
                                        AudioFeedback.inputed()
                                        context.triggerHapticFeedback()
                                        context.process(inputEvent, isCapitalized: context.keyboardCase.isCapitalized)
                                }
                        }
        }
}

enum HiddenEvent: Int {

        case letterA
        case letterL
        case letterZ
        case backspace

        var inputEvent: InputEvent? {
                switch self {
                case .letterA: .letterA
                case .letterL: .letterL
                case .letterZ: .letterZ
                case .backspace: nil
                }
        }
}
