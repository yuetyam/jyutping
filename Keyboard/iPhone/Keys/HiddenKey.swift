import SwiftUI
import CoreIME
import CommonExtensions

struct HiddenKey: View {

        @EnvironmentObject private var context: KeyboardViewController

        let key: HiddenEvent

        var body: some View {
                Button {
                        if key == .backspace {
                                AudioFeedback.deleted()
                                context.triggerHapticFeedback()
                                context.operate(.backspace)
                        } else if let event = key.inputEvent {
                                AudioFeedback.inputed()
                                context.triggerHapticFeedback()
                                context.handle(event)
                        }
                } label: {
                        Color.interactiveClear
                                .frame(height: context.heightUnit)
                                .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
        }
}

enum HiddenEvent: Int {

        case letterA
        case letterL
        case letterZ
        case letterM
        case backspace

        var inputEvent: VirtualInputKey? {
                switch self {
                case .letterA: .letterA
                case .letterL: .letterL
                case .letterZ: .letterZ
                case .letterM: .letterM
                case .backspace: nil
                }
        }
}
