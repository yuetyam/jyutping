import SwiftUI
import CommonExtensions
import CoreIME

/// Digits 1, 2, 3 ..., 8, 9, 0
struct ABCNumberRow: View {
    var body: some View {
            HStack(spacing: 0) {
                    NumberInputKey(.number1)
                    NumberInputKey(.number2)
                    NumberInputKey(.number3)
                    NumberInputKey(.number4)
                    NumberInputKey(.number5)
                    NumberInputKey(.number6)
                    NumberInputKey(.number7)
                    NumberInputKey(.number8)
                    NumberInputKey(.number9)
                    EnhancedInputKey(keyLocale: .trailing, event: .number0, keyModel: KeyModel(primary: KeyElement("0"), members: [KeyElement("0"), KeyElement("°")]))
            }
    }
}
