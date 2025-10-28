import SwiftUI
import CommonExtensions
import CoreIME

/// Digits 1, 2, 3 ..., 8, 9, 0
struct CantoneseNumberRow: View {
        var body: some View {
                HStack(spacing: 0) {
                        EnhancedInputKey(
                                keyLocale: .leading,
                                event: .number1,
                                keyModel: KeyModel(
                                        primary: KeyElement("1"),
                                        members: [
                                                KeyElement("1"),
                                                KeyElement("１", header: PresetConstant.fullWidth),
                                                KeyElement("壹"),
                                                KeyElement("¹", header: "上標"),
                                                KeyElement("₁", header: "下標"),
                                                KeyElement("①")
                                        ]
                                )
                        )
                        EnhancedInputKey(
                                keyLocale: .leading,
                                event: .number2,
                                keyModel: KeyModel(
                                        primary: KeyElement("2"),
                                        members: [
                                                KeyElement("2"),
                                                KeyElement("２", header: PresetConstant.fullWidth),
                                                KeyElement("貳"),
                                                KeyElement("²", header: "上標"),
                                                KeyElement("₂", header: "下標"),
                                                KeyElement("②")
                                        ]
                                )
                        )
                        EnhancedInputKey(
                                keyLocale: .leading,
                                event: .number3,
                                keyModel: KeyModel(
                                        primary: KeyElement("3"),
                                        members: [
                                                KeyElement("3"),
                                                KeyElement("３", header: PresetConstant.fullWidth),
                                                KeyElement("叁"),
                                                KeyElement("³", header: "上標"),
                                                KeyElement("₃", header: "下標"),
                                                KeyElement("③")
                                        ]
                                )
                        )
                        EnhancedInputKey(
                                keyLocale: .leading,
                                event: .number4,
                                keyModel: KeyModel(
                                        primary: KeyElement("4"),
                                        members: [
                                                KeyElement("4"),
                                                KeyElement("４", header: PresetConstant.fullWidth),
                                                KeyElement("肆"),
                                                KeyElement("⁴", header: "上標"),
                                                KeyElement("₄", header: "下標"),
                                                KeyElement("④")
                                        ]
                                )
                        )
                        EnhancedInputKey(
                                keyLocale: .leading,
                                event: .number5,
                                keyModel: KeyModel(
                                        primary: KeyElement("5"),
                                        members: [
                                                KeyElement("5"),
                                                KeyElement("５", header: PresetConstant.fullWidth),
                                                KeyElement("伍"),
                                                KeyElement("⁵", header: "上標"),
                                                KeyElement("₅", header: "下標"),
                                                KeyElement("⑤")
                                        ]
                                )
                        )
                        EnhancedInputKey(
                                keyLocale: .trailing,
                                event: .number6,
                                keyModel: KeyModel(
                                        primary: KeyElement("6"),
                                        members: [
                                                KeyElement("6"),
                                                KeyElement("６", header: PresetConstant.fullWidth),
                                                KeyElement("陸"),
                                                KeyElement("⁶", header: "上標"),
                                                KeyElement("₆", header: "下標"),
                                                KeyElement("⑥")
                                        ]
                                )
                        )
                        EnhancedInputKey(
                                keyLocale: .trailing,
                                event: .number7,
                                keyModel: KeyModel(
                                        primary: KeyElement("7"),
                                        members: [
                                                KeyElement("7"),
                                                KeyElement("７", header: PresetConstant.fullWidth),
                                                KeyElement("柒"),
                                                KeyElement("⁷", header: "上標"),
                                                KeyElement("₇", header: "下標"),
                                                KeyElement("⑦")
                                        ]
                                )
                        )
                        EnhancedInputKey(
                                keyLocale: .trailing,
                                event: .number8,
                                keyModel: KeyModel(
                                        primary: KeyElement("8"),
                                        members: [
                                                KeyElement("8"),
                                                KeyElement("８", header: PresetConstant.fullWidth),
                                                KeyElement("捌"),
                                                KeyElement("⁸", header: "上標"),
                                                KeyElement("₈", header: "下標"),
                                                KeyElement("⑧")
                                        ]
                                )
                        )
                        EnhancedInputKey(
                                keyLocale: .trailing,
                                event: .number9,
                                keyModel: KeyModel(
                                        primary: KeyElement("9"),
                                        members: [
                                                KeyElement("9"),
                                                KeyElement("９", header: PresetConstant.fullWidth),
                                                KeyElement("玖"),
                                                KeyElement("⁹", header: "上標"),
                                                KeyElement("₉", header: "下標"),
                                                KeyElement("⑨")
                                        ]
                                )
                        )
                        EnhancedInputKey(
                                keyLocale: .trailing,
                                event: .number0,
                                keyModel: KeyModel(
                                        primary: KeyElement("0"),
                                        members: [
                                                KeyElement("0"),
                                                KeyElement("０", header: PresetConstant.fullWidth),
                                                KeyElement("零"),
                                                KeyElement("⁰", header: "上標"),
                                                KeyElement("₀", header: "下標"),
                                                KeyElement("⓪"),
                                                KeyElement("拾"),
                                                KeyElement("°", header: "度")
                                        ]
                                )
                        )
                }
        }
}
