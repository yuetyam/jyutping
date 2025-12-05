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
                                        keyLocale: .leading,
                                        keyModel: KeyModel(
                                                primary: KeyElement("-"),
                                                members: [
                                                        KeyElement("-"),
                                                        KeyElement("–", footer: "2013"),
                                                        KeyElement("—", footer: "2014"),
                                                        KeyElement("•", footer: "2022")
                                                ]
                                        )
                                )
                                EnhancedInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("/"), members: [KeyElement("/"), KeyElement("\\")]))
                                SymbolInputKey(":")
                                SymbolInputKey(";")
                                SymbolInputKey("(")
                                SymbolInputKey(")")
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(
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
                                EnhancedInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("&"), members: [KeyElement("&"), KeyElement("§")]))
                                SymbolInputKey("@")
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(
                                                primary: KeyElement("\u{0022}"),
                                                members: [
                                                        KeyElement("\u{0022}", footer: "0022"),
                                                        KeyElement("\u{201D}", footer: "201D"),
                                                        KeyElement("\u{201C}", footer: "201C"),
                                                        KeyElement("\u{201E}", footer: "201E"),
                                                        KeyElement("\u{00BB}", footer: "00BB"),
                                                        KeyElement("\u{00AB}", footer: "00AB")
                                                ]
                                        )
                                )
                        }
                        HStack(spacing: 0) {
                                TransformKey(destination: .symbolic, widthUnitTimes: 1.3)
                                Spacer()
                                EnhancedInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("."), members: [KeyElement("."), KeyElement("…")]))
                                SymbolInputKey(",")
                                EnhancedInputKey(keyLocale: .leading, keyModel: KeyModel(primary: KeyElement("?"), members: [KeyElement("?"), KeyElement("¿")]))
                                EnhancedInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("!"), members: [KeyElement("!"), KeyElement("¡")]))
                                EnhancedInputKey(keyLocale: .trailing, keyModel: KeyModel(primary: KeyElement("%"), members: [KeyElement("%"), KeyElement("‰")]))
                                SymbolInputKey("*")
                                EnhancedInputKey(
                                        keyLocale: .trailing,
                                        keyModel: KeyModel(
                                                primary: KeyElement("\u{0027}"),
                                                members: [
                                                        KeyElement("\u{0027}", footer: "0027"),
                                                        KeyElement("\u{2019}", footer: "2019"),
                                                        KeyElement("\u{2018}", footer: "2018"),
                                                        KeyElement("\u{0060}", footer: "0060")
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
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        SpaceKey()
                                        SharedBottomKeys.altPeriod
                                        ReturnKey()
                                }
                        case (true, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        SharedBottomKeys.comma
                                        SpaceKey()
                                        SharedBottomKeys.period
                                        ReturnKey()
                                }
                        case (false, true):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        GlobeKey()
                                        SpaceKey()
                                        SharedBottomKeys.altPeriod
                                        ReturnKey()
                                }
                        case (false, false):
                                HStack(spacing: 0) {
                                        TransformKey(destination: .alphabetic, widthUnitTimes: 2)
                                        SharedBottomKeys.comma
                                        SpaceKey()
                                        SharedBottomKeys.period
                                        ReturnKey()
                                }
                        }
                }
        }
}
