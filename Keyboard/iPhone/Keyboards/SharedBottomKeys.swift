import SwiftUI
import CommonExtensions

@MainActor
struct SharedBottomKeys {
        static let comma = EnhancedInputKey(
                keyLocale: .leading,
                keyModel: KeyModel(
                        primary: KeyElement(String.comma),
                        members: [
                                KeyElement(String.comma),
                                KeyElement("?"),
                                KeyElement("!"),
                                KeyElement(";")
                        ]
                )
        )
        static let period = EnhancedInputKey(
                keyLocale: .trailing,
                keyModel: KeyModel(
                        primary: KeyElement(String.period),
                        members: [
                                KeyElement(String.period),
                                KeyElement("!"),
                                KeyElement("?"),
                                KeyElement("…")
                        ]
                )
        )
        static let altPeriod = EnhancedInputKey(
                keyLocale: .trailing,
                keyModel: KeyModel(
                        primary: KeyElement(String.period),
                        members: [
                                KeyElement(String.period),
                                KeyElement(String.comma),
                                KeyElement("?"),
                                KeyElement("!")
                        ]
                )
        )

        static let cantoneseComma = EnhancedInputKey(
                keyLocale: .leading,
                keyModel: KeyModel(
                        primary: KeyElement(String.cantoneseComma),
                        members: [
                                KeyElement(String.cantoneseComma),
                                KeyElement("？"),
                                KeyElement("！"),
                                KeyElement("、")
                        ]
                )
        )
        static let cantonesePeriod = EnhancedInputKey(
                keyLocale: .trailing,
                keyModel: KeyModel(
                        primary: KeyElement(String.cantonesePeriod),
                        members: [
                                KeyElement(String.cantonesePeriod),
                                KeyElement("！"),
                                KeyElement("？"),
                                KeyElement(String.period)
                        ]
                )
        )
        static let altCantoneseComma = EnhancedInputKey(
                keyLocale: .trailing,
                keyModel: KeyModel(
                        primary: KeyElement(String.cantoneseComma),
                        members: [
                                KeyElement(String.cantoneseComma),
                                KeyElement(String.cantonesePeriod),
                                KeyElement("？"),
                                KeyElement("！")
                        ]
                )
        )
}
