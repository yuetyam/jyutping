import SwiftUI

struct KeyboardStack: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                VStack(spacing: 0) {
                        KeyboardRow(events: [
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("q"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("w"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("e"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("r"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("t"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("y"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("u"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("i"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("o"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("p"))),
                        ]).environmentObject(context)

                        KeyboardRow(events: [
                                KeyboardEvent.hidden("a"),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("a"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("s"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("d"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("f"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("g"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("h"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("j"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("k"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("l"))),
                                KeyboardEvent.hidden("l"),
                        ]).environmentObject(context)

                        KeyboardRow(events: [
                                KeyboardEvent.shift,
                                KeyboardEvent.hidden("z"),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("z"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("x"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("c"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("v"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("b"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("n"))),
                                KeyboardEvent.input(KeyUnit(primary: KeyElement("m"))),
                                KeyboardEvent.hidden("m"),
                                KeyboardEvent.backspace
                        ]).environmentObject(context)

                        KeyboardRow(events: [
                                KeyboardEvent.transform(.cantoneseNumeric),
                                KeyboardEvent.comma,
                                KeyboardEvent.space,
                                KeyboardEvent.period,
                                KeyboardEvent.newLine
                        ]).environmentObject(context)
                }
        }
}
