import SwiftUI

struct KeyboardStack: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        HStack(spacing: 0 ) {
                                LetterKey(key: KeyUnit(primary: KeyElement("q"))).environmentObject(context)
                                LetterKey(key: KeyUnit(primary: KeyElement("w"))).environmentObject(context)
                                LetterKey(key: KeyUnit(primary: KeyElement("e"))).environmentObject(context)
                                LetterKey(key: KeyUnit(primary: KeyElement("r"))).environmentObject(context)
                                LetterKey(key: KeyUnit(primary: KeyElement("t"))).environmentObject(context)
                                LetterKey(key: KeyUnit(primary: KeyElement("y"))).environmentObject(context)
                                LetterKey(key: KeyUnit(primary: KeyElement("u"))).environmentObject(context)
                                LetterKey(key: KeyUnit(primary: KeyElement("i"))).environmentObject(context)
                                LetterKey(key: KeyUnit(primary: KeyElement("o"))).environmentObject(context)
                                LetterKey(key: KeyUnit(primary: KeyElement("p"))).environmentObject(context)

                        }
                        HStack(spacing: 0) {
                                HiddenLetterKey(letter: .letterA).environmentObject(context)
                                Group {
                                        LetterKey(key: KeyUnit(primary: KeyElement("a"))).environmentObject(context)
                                        LetterKey(key: KeyUnit(primary: KeyElement("s"))).environmentObject(context)
                                        LetterKey(key: KeyUnit(primary: KeyElement("d"))).environmentObject(context)
                                        LetterKey(key: KeyUnit(primary: KeyElement("f"))).environmentObject(context)
                                        LetterKey(key: KeyUnit(primary: KeyElement("g"))).environmentObject(context)
                                        LetterKey(key: KeyUnit(primary: KeyElement("h"))).environmentObject(context)
                                        LetterKey(key: KeyUnit(primary: KeyElement("j"))).environmentObject(context)
                                        LetterKey(key: KeyUnit(primary: KeyElement("k"))).environmentObject(context)
                                        LetterKey(key: KeyUnit(primary: KeyElement("l"))).environmentObject(context)
                                }
                                HiddenLetterKey(letter: .letterL).environmentObject(context)
                        }
                        HStack(spacing: 0) {
                                ShiftKey().environmentObject(context)
                                HiddenLetterKey(letter: .letterZ).environmentObject(context)
                                Group {
                                        LetterKey(key: KeyUnit(primary: KeyElement("z"))).environmentObject(context)
                                        LetterKey(key: KeyUnit(primary: KeyElement("x"))).environmentObject(context)
                                        LetterKey(key: KeyUnit(primary: KeyElement("c"))).environmentObject(context)
                                        LetterKey(key: KeyUnit(primary: KeyElement("v"))).environmentObject(context)
                                        LetterKey(key: KeyUnit(primary: KeyElement("b"))).environmentObject(context)
                                        LetterKey(key: KeyUnit(primary: KeyElement("n"))).environmentObject(context)
                                        LetterKey(key: KeyUnit(primary: KeyElement("m"))).environmentObject(context)
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
