import SwiftUI

struct AlphabeticKeyboard: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        HStack(spacing: 0 ) {
                                InputKey(key: KeyUnit(primary: KeyElement("q"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("w"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("e"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("r"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("t"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("y"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("u"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("i"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("o"))).environmentObject(context)
                                InputKey(key: KeyUnit(primary: KeyElement("p"))).environmentObject(context)

                        }
                        HStack(spacing: 0) {
                                HiddenLetterKey(letter: .letterA).environmentObject(context)
                                Group {
                                        InputKey(key: KeyUnit(primary: KeyElement("a"))).environmentObject(context)
                                        InputKey(key: KeyUnit(primary: KeyElement("s"))).environmentObject(context)
                                        InputKey(key: KeyUnit(primary: KeyElement("d"))).environmentObject(context)
                                        InputKey(key: KeyUnit(primary: KeyElement("f"))).environmentObject(context)
                                        InputKey(key: KeyUnit(primary: KeyElement("g"))).environmentObject(context)
                                        InputKey(key: KeyUnit(primary: KeyElement("h"))).environmentObject(context)
                                        InputKey(key: KeyUnit(primary: KeyElement("j"))).environmentObject(context)
                                        InputKey(key: KeyUnit(primary: KeyElement("k"))).environmentObject(context)
                                        InputKey(key: KeyUnit(primary: KeyElement("l"))).environmentObject(context)
                                }
                                HiddenLetterKey(letter: .letterL).environmentObject(context)
                        }
                        HStack(spacing: 0) {
                                ShiftKey().environmentObject(context)
                                HiddenLetterKey(letter: .letterZ).environmentObject(context)
                                Group {
                                        InputKey(key: KeyUnit(primary: KeyElement("z"))).environmentObject(context)
                                        InputKey(key: KeyUnit(primary: KeyElement("x"))).environmentObject(context)
                                        InputKey(key: KeyUnit(primary: KeyElement("c"))).environmentObject(context)
                                        InputKey(key: KeyUnit(primary: KeyElement("v"))).environmentObject(context)
                                        InputKey(key: KeyUnit(primary: KeyElement("b"))).environmentObject(context)
                                        InputKey(key: KeyUnit(primary: KeyElement("n"))).environmentObject(context)
                                        InputKey(key: KeyUnit(primary: KeyElement("m"))).environmentObject(context)
                                }
                                HiddenLetterKey(letter: .letterM).environmentObject(context)
                                BackspaceKey().environmentObject(context)
                        }
                        HStack(spacing: 0) {
                                NumericKey().environmentObject(context)
                                CommaKey().environmentObject(context)
                                SpaceKey().environmentObject(context)
                                PeriodKey().environmentObject(context)
                                ReturnKey().environmentObject(context)
                        }
                }
        }
}
