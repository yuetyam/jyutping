import SwiftUI
import CoreIME
import CommonExtensions

/// ABC mode keyboard
struct NumericKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        ToolBar()
                        if Options.needsNumberRow {
                                ABCNumberRow()
                        }
                        ABCNumberRow()
                        HStack(spacing: 0) {
                                EnhancedInputKey(
                                        side: .leading,
                                        unit: KeyUnit(
                                                primary: KeyElement("-"),
                                                members: [
                                                        KeyElement("-"),
                                                        KeyElement("–", extras: [.init("2013", alignment: .bottom)]),
                                                        KeyElement("—", extras: [.init("2014", alignment: .bottom)]),
                                                        KeyElement("•", extras: [.init("2022", alignment: .bottom)])
                                                ]
                                        )
                                )
                                EnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("/"), members: [KeyElement("/"), KeyElement("\\")]))
                                SymbolInputKey(":")
                                SymbolInputKey(";")
                                SymbolInputKey("(")
                                SymbolInputKey(")")
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(
                                                primary: KeyElement("$"),
                                                members: [
                                                        KeyElement("$"),
                                                        KeyElement("€"),
                                                        KeyElement("£"),
                                                        KeyElement("¥"),
                                                        KeyElement("₩"),
                                                        KeyElement("₽"),
                                                        KeyElement("¢")
                                                ]
                                        )
                                )
                                EnhancedInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("&"), members: [KeyElement("&"), KeyElement("§")]))
                                SymbolInputKey("@")
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(
                                                primary: KeyElement("\u{0022}"),
                                                members: [
                                                        KeyElement("\u{0022}", extras: [.init("0022", alignment: .bottom)]),
                                                        KeyElement("\u{201D}", extras: [.init("201D", alignment: .bottom)]),
                                                        KeyElement("\u{201C}", extras: [.init("201C", alignment: .bottom)]),
                                                        KeyElement("\u{201E}", extras: [.init("201E", alignment: .bottom)]),
                                                        KeyElement("\u{00BB}", extras: [.init("00BB", alignment: .bottom)]),
                                                        KeyElement("\u{00AB}", extras: [.init("00AB", alignment: .bottom)])
                                                ]
                                        )
                                )
                        }
                        HStack(spacing: 0) {
                                TransformKey(destination: .symbolic, coefficient: 1.3)
                                Spacer()
                                EnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("."), members: [KeyElement("."), KeyElement("…")]))
                                SymbolInputKey(",")
                                EnhancedInputKey(side: .leading, unit: KeyUnit(primary: KeyElement("?"), members: [KeyElement("?"), KeyElement("¿")]))
                                EnhancedInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("!"), members: [KeyElement("!"), KeyElement("¡")]))
                                EnhancedInputKey(side: .trailing, unit: KeyUnit(primary: KeyElement("%"), members: [KeyElement("%"), KeyElement("‰")]))
                                SymbolInputKey("*")
                                EnhancedInputKey(
                                        side: .trailing,
                                        unit: KeyUnit(
                                                primary: KeyElement("\u{0027}"),
                                                members: [
                                                        KeyElement("\u{0027}", extras: [.init("0027", alignment: .bottom)]),
                                                        KeyElement("\u{2019}", extras: [.init("2019", alignment: .bottom)]),
                                                        KeyElement("\u{2018}", extras: [.init("2018", alignment: .bottom)]),
                                                        KeyElement("\u{0060}", extras: [.init("0060", alignment: .bottom)])
                                                ]
                                        )
                                )
                                Spacer()
                                BackspaceKey()
                        }
                        switch (context.keyboardInterface.isPadFloating, context.needsInputModeSwitchKey) {
                        case (true, true):
                                HStack(spacing: 0) {
                                        GlobeKey()
                                        TransformKey(destination: .primary, coefficient: 2)
                                        SpaceKey()
                                        SharedBottomKeys.altPeriod
                                        ReturnKey()
                                }
                        case (true, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .primary, coefficient: 2)
                                        SharedBottomKeys.comma
                                        SpaceKey()
                                        SharedBottomKeys.period
                                        ReturnKey()
                                }
                        case (false, true):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .primary, coefficient: 2)
                                        GlobeKey()
                                        SpaceKey()
                                        SharedBottomKeys.altPeriod
                                        ReturnKey()
                                }
                        case (false, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .primary, coefficient: 2)
                                        SharedBottomKeys.comma
                                        SpaceKey()
                                        SharedBottomKeys.period
                                        ReturnKey()
                                }
                        }
                }
        }
}
