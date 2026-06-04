import SwiftUI
import CommonExtensions
import CoreIME

/// Digits 1, 2, 3 ..., 8, 9, 0
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct CantoneseGlassNumberRow: View {
        private let fullWidth: String = PresetConstant.fullWidth
        private let superscripted: String = "上標"
        private let subscripted: String = "下標"
        var body: some View {
                HStack(spacing: 0) {
                        GlassEnhancedInputKey(
                                side: .leading,
                                virtual: .number1,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .number1),
                                        members: [
                                                KeyElement(virtual: .number1),
                                                KeyElement("１", extras: [.init(fullWidth, alignment: .top)]),
                                                KeyElement("壹"),
                                                KeyElement("¹", extras: [.init(superscripted, alignment: .top)]),
                                                KeyElement("₁", extras: [.init(subscripted, alignment: .top)]),
                                                KeyElement("①")
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                virtual: .number2,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .number2),
                                        members: [
                                                KeyElement(virtual: .number2),
                                                KeyElement("２", extras: [.init(fullWidth, alignment: .top)]),
                                                KeyElement("貳"),
                                                KeyElement("²", extras: [.init(superscripted, alignment: .top)]),
                                                KeyElement("₂", extras: [.init(subscripted, alignment: .top)]),
                                                KeyElement("②")
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                virtual: .number3,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .number3),
                                        members: [
                                                KeyElement(virtual: .number3),
                                                KeyElement("３", extras: [.init(fullWidth, alignment: .top)]),
                                                KeyElement("叁"),
                                                KeyElement("³", extras: [.init(superscripted, alignment: .top)]),
                                                KeyElement("₃", extras: [.init(subscripted, alignment: .top)]),
                                                KeyElement("③")
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                virtual: .number4,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .number4),
                                        members: [
                                                KeyElement(virtual: .number4),
                                                KeyElement("４", extras: [.init(fullWidth, alignment: .top)]),
                                                KeyElement("肆"),
                                                KeyElement("⁴", extras: [.init(superscripted, alignment: .top)]),
                                                KeyElement("₄", extras: [.init(subscripted, alignment: .top)]),
                                                KeyElement("④")
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .leading,
                                virtual: .number5,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .number5),
                                        members: [
                                                KeyElement(virtual: .number5),
                                                KeyElement("５", extras: [.init(fullWidth, alignment: .top)]),
                                                KeyElement("伍"),
                                                KeyElement("⁵", extras: [.init(superscripted, alignment: .top)]),
                                                KeyElement("₅", extras: [.init(subscripted, alignment: .top)]),
                                                KeyElement("⑤")
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                virtual: .number6,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .number6),
                                        members: [
                                                KeyElement(virtual: .number6),
                                                KeyElement("６", extras: [.init(fullWidth, alignment: .top)]),
                                                KeyElement("陸"),
                                                KeyElement("⁶", extras: [.init(superscripted, alignment: .top)]),
                                                KeyElement("₆", extras: [.init(subscripted, alignment: .top)]),
                                                KeyElement("⑥")
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                virtual: .number7,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .number7),
                                        members: [
                                                KeyElement(virtual: .number7),
                                                KeyElement("７", extras: [.init(fullWidth, alignment: .top)]),
                                                KeyElement("柒"),
                                                KeyElement("⁷", extras: [.init(superscripted, alignment: .top)]),
                                                KeyElement("₇", extras: [.init(subscripted, alignment: .top)]),
                                                KeyElement("⑦")
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                virtual: .number8,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .number8),
                                        members: [
                                                KeyElement(virtual: .number8),
                                                KeyElement("８", extras: [.init(fullWidth, alignment: .top)]),
                                                KeyElement("捌"),
                                                KeyElement("⁸", extras: [.init(superscripted, alignment: .top)]),
                                                KeyElement("₈", extras: [.init(subscripted, alignment: .top)]),
                                                KeyElement("⑧")
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                virtual: .number9,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .number9),
                                        members: [
                                                KeyElement(virtual: .number9),
                                                KeyElement("９", extras: [.init(fullWidth, alignment: .top)]),
                                                KeyElement("玖"),
                                                KeyElement("⁹", extras: [.init(superscripted, alignment: .top)]),
                                                KeyElement("₉", extras: [.init(subscripted, alignment: .top)]),
                                                KeyElement("⑨")
                                        ]
                                )
                        )
                        GlassEnhancedInputKey(
                                side: .trailing,
                                virtual: .number0,
                                unit: KeyUnit(
                                        primary: KeyElement(virtual: .number0),
                                        members: [
                                                KeyElement(virtual: .number0),
                                                KeyElement("０", extras: [.init(fullWidth, alignment: .top)]),
                                                KeyElement("零"),
                                                KeyElement("⁰", extras: [.init(superscripted, alignment: .top)]),
                                                KeyElement("₀", extras: [.init(subscripted, alignment: .top)]),
                                                KeyElement("⓪"),
                                                KeyElement("拾"),
                                                KeyElement("°", extras: [.init("度", alignment: .top)])
                                        ]
                                )
                        )
                }
        }
}
