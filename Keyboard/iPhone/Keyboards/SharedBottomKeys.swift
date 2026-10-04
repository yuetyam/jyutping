import SwiftUI
import CommonExtensions

@MainActor
struct SharedBottomKeys {
        static let comma = EnhancedInputKey(
                side: .leading,
                unit: KeyUnit(
                        primary: KeyElement(String.comma),
                        members: [
                                KeyElement(String.comma),
                                KeyElement("!"),
                                KeyElement("?"),
                                KeyElement(";")
                        ]
                )
        )
        static let period = EnhancedInputKey(
                side: .trailing,
                unit: KeyUnit(
                        primary: KeyElement(String.period),
                        members: [
                                KeyElement(String.period),
                                KeyElement("?"),
                                KeyElement("!"),
                                KeyElement("…")
                        ]
                )
        )
        static let altPeriod = EnhancedInputKey(
                side: .trailing,
                unit: KeyUnit(
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
                side: .leading,
                unit: KeyUnit(
                        primary: KeyElement(String.cantoneseComma),
                        members: [
                                KeyElement(String.cantoneseComma),
                                KeyElement("！"),
                                KeyElement("？"),
                                KeyElement("、")
                        ]
                )
        )
        static let cantonesePeriod = EnhancedInputKey(
                side: .trailing,
                unit: KeyUnit(
                        primary: KeyElement(String.cantonesePeriod),
                        members: [
                                KeyElement(String.cantonesePeriod),
                                KeyElement("？"),
                                KeyElement("！"),
                                KeyElement("…")
                        ]
                )
        )
        static let altCantoneseComma = EnhancedInputKey(
                side: .trailing,
                unit: KeyUnit(
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
