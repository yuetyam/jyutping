import SwiftUI
import CommonExtensions
import CoreIME

/// Digits 1, 2, 3 ..., 8, 9, 0
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct ABCGlassNumberRow: View {
        var body: some View {
                HStack(spacing: 0) {
                        NumberGlassInputKey(.number1)
                        NumberGlassInputKey(.number2)
                        NumberGlassInputKey(.number3)
                        NumberGlassInputKey(.number4)
                        NumberGlassInputKey(.number5)
                        NumberGlassInputKey(.number6)
                        NumberGlassInputKey(.number7)
                        NumberGlassInputKey(.number8)
                        NumberGlassInputKey(.number9)
                        GlassEnhancedInputKey(
                                side: .trailing,
                                virtual: .number0,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .number0),
                                        members: [
                                                KeyElement(virtual: .number0),
                                                KeyElement("°"),
                                        ]
                                )
                        )
                }
        }
}

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
