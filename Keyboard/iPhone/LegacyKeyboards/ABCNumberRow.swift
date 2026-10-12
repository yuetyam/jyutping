import SwiftUI
import CommonExtensions
import CoreIME

/// Digits 1, 2, 3 ..., 8, 9, 0
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct ABCGlassNumberRow: View {
        var body: some View {
                HStack(spacing: 0) {
                        GlassNumberInputKey(.number1)
                        GlassNumberInputKey(.number2)
                        GlassNumberInputKey(.number3)
                        GlassNumberInputKey(.number4)
                        GlassNumberInputKey(.number5)
                        GlassNumberInputKey(.number6)
                        GlassNumberInputKey(.number7)
                        GlassNumberInputKey(.number8)
                        GlassNumberInputKey(.number9)
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
                    EnhancedInputKey(
                        side: .trailing,
                        virtual: .number0,
                        unit: KeyUnit(
                                primary: KeyElement(virtual: .number0),
                                members: [
                                        KeyElement(virtual: .number0),
                                        KeyElement("°")
                                ]
                        )
                    )
            }
    }
}
