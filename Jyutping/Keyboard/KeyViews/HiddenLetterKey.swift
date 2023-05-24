import SwiftUI

struct HiddenLetterKey: View {

        @EnvironmentObject private var context: KeyboardViewController

        let letter: HiddenLetter

        var body: some View {
                Color.interactiveClear
                        .frame(height: context.heightUnit)
                        .frame(maxWidth: .infinity)
                        .onTapGesture {
                                AudioFeedback.inputed()
                                context.triggerHapticFeedback()
                                let text: String = {
                                        switch letter {
                                        case .letterA:
                                                return "a"
                                        case .letterL:
                                                return "l"
                                        case .letterZ:
                                                return "z"
                                        case .letterM:
                                                return "m"
                                        }
                                }()
                                context.operate(.input(text))
                        }
        }
}

enum HiddenLetter: Int {
        case letterA
        case letterL
        case letterZ
        case letterM
}

struct PlaceHolderKey: View {
        var body: some View {
                Color.clear.frame(maxWidth: .infinity)
        }
}
