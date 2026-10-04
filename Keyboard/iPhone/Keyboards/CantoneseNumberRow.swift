import SwiftUI
import CommonExtensions
import CoreIME

/// Digits 1, 2, 3 ..., 8, 9, 0
struct CantoneseNumberRow: View {
        var body: some View {
                HStack(spacing: 0) {
                        EnhancedInputKey(
                                side: .leading,
                                virtual: .number1,
                                unit: KeyUnit(
                                        primary: KeyElement("1"),
                                        members: [
                                                KeyElement("1"),
                                                KeyElement("１", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                KeyElement("壹"),
                                                KeyElement("¹", extras: [.init("上標", alignment: .topTrailing)]),
                                                KeyElement("₁", extras: [.init("下標", alignment: .topTrailing)]),
                                                KeyElement("①")
                                        ]
                                )
                        )
                        EnhancedInputKey(
                                side: .leading,
                                virtual: .number2,
                                unit: KeyUnit(
                                        primary: KeyElement("2"),
                                        members: [
                                                KeyElement("2"),
                                                KeyElement("２", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                KeyElement("貳"),
                                                KeyElement("²", extras: [.init("上標", alignment: .topTrailing)]),
                                                KeyElement("₂", extras: [.init("下標", alignment: .topTrailing)]),
                                                KeyElement("②")
                                        ]
                                )
                        )
                        EnhancedInputKey(
                                side: .leading,
                                virtual: .number3,
                                unit: KeyUnit(
                                        primary: KeyElement("3"),
                                        members: [
                                                KeyElement("3"),
                                                KeyElement("３", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                KeyElement("叁"),
                                                KeyElement("³", extras: [.init("上標", alignment: .topTrailing)]),
                                                KeyElement("₃", extras: [.init("下標", alignment: .topTrailing)]),
                                                KeyElement("③")
                                        ]
                                )
                        )
                        EnhancedInputKey(
                                side: .leading,
                                virtual: .number4,
                                unit: KeyUnit(
                                        primary: KeyElement("4"),
                                        members: [
                                                KeyElement("4"),
                                                KeyElement("４", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                KeyElement("肆"),
                                                KeyElement("⁴", extras: [.init("上標", alignment: .topTrailing)]),
                                                KeyElement("₄", extras: [.init("下標", alignment: .topTrailing)]),
                                                KeyElement("④")
                                        ]
                                )
                        )
                        EnhancedInputKey(
                                side: .leading,
                                virtual: .number5,
                                unit: KeyUnit(
                                        primary: KeyElement("5"),
                                        members: [
                                                KeyElement("5"),
                                                KeyElement("５", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                KeyElement("伍"),
                                                KeyElement("⁵", extras: [.init("上標", alignment: .topTrailing)]),
                                                KeyElement("₅", extras: [.init("下標", alignment: .topTrailing)]),
                                                KeyElement("⑤")
                                        ]
                                )
                        )
                        EnhancedInputKey(
                                side: .trailing,
                                virtual: .number6,
                                unit: KeyUnit(
                                        primary: KeyElement("6"),
                                        members: [
                                                KeyElement("6"),
                                                KeyElement("６", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                KeyElement("陸"),
                                                KeyElement("⁶", extras: [.init("上標", alignment: .topTrailing)]),
                                                KeyElement("₆", extras: [.init("下標", alignment: .topTrailing)]),
                                                KeyElement("⑥")
                                        ]
                                )
                        )
                        EnhancedInputKey(
                                side: .trailing,
                                virtual: .number7,
                                unit: KeyUnit(
                                        primary: KeyElement("7"),
                                        members: [
                                                KeyElement("7"),
                                                KeyElement("７", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                KeyElement("柒"),
                                                KeyElement("⁷", extras: [.init("上標", alignment: .topTrailing)]),
                                                KeyElement("₇", extras: [.init("下標", alignment: .topTrailing)]),
                                                KeyElement("⑦")
                                        ]
                                )
                        )
                        EnhancedInputKey(
                                side: .trailing,
                                virtual: .number8,
                                unit: KeyUnit(
                                        primary: KeyElement("8"),
                                        members: [
                                                KeyElement("8"),
                                                KeyElement("８", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                KeyElement("捌"),
                                                KeyElement("⁸", extras: [.init("上標", alignment: .topTrailing)]),
                                                KeyElement("₈", extras: [.init("下標", alignment: .topTrailing)]),
                                                KeyElement("⑧")
                                        ]
                                )
                        )
                        EnhancedInputKey(
                                side: .trailing,
                                virtual: .number9,
                                unit: KeyUnit(
                                        primary: KeyElement("9"),
                                        members: [
                                                KeyElement("9"),
                                                KeyElement("９", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                KeyElement("玖"),
                                                KeyElement("⁹", extras: [.init("上標", alignment: .topTrailing)]),
                                                KeyElement("₉", extras: [.init("下標", alignment: .topTrailing)]),
                                                KeyElement("⑨")
                                        ]
                                )
                        )
                        EnhancedInputKey(
                                side: .trailing,
                                virtual: .number0,
                                unit: KeyUnit(
                                        primary: KeyElement("0"),
                                        members: [
                                                KeyElement("0"),
                                                KeyElement("０", extras: [.init(PresetConstant.fullWidth, alignment: .topTrailing)]),
                                                KeyElement("零"),
                                                KeyElement("⁰", extras: [.init("上標", alignment: .topTrailing)]),
                                                KeyElement("₀", extras: [.init("下標", alignment: .topTrailing)]),
                                                KeyElement("⓪"),
                                                KeyElement("拾"),
                                                KeyElement("°", extras: [.init("度", alignment: .topTrailing)])
                                        ]
                                )
                        )
                }
        }
}
