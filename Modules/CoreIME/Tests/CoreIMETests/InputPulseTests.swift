import Testing
@testable import CoreIME

@Suite("Input pulses")
struct InputPulseTests {

        @Test("singleton ambiguous pulses preserve reverse lookup sequences", arguments: ["rni", "va", "xwsad"])
        func reverseLookupPulses(_ text: String) {
                let pulses = inputKeys(text).map({ InputPulse.ambiguous(AmbiguousInputEvent(keys: [$0], case: .lowercased)) })

                #expect(pulses.basicEvents == inputEvents(text))
        }

        @Test("basic projection preserves order and case while excluding unresolved inputs")
        func basicEvents() {
                let pulses: [InputPulse] = [
                        .basic(BasicInputEvent(key: .letterR, case: .lowercased)),
                        .ambiguous(AmbiguousInputEvent(keys: [.letterN], case: .uppercased)),
                        .ambiguous(AmbiguousInputEvent(keys: [], case: .lowercased)),
                        .ambiguous(AmbiguousInputEvent(keys: [.letterQ, .letterW], case: .lowercased)),
                        .combined(.ABC),
                        .ambiguous(AmbiguousInputEvent(keys: [.number1], case: .capsLocked))
                ]
                let expected = [
                        BasicInputEvent(key: .letterR, case: .lowercased),
                        BasicInputEvent(key: .letterN, case: .uppercased),
                        BasicInputEvent(key: .number1, case: .capsLocked)
                ]

                #expect(pulses.basicEvents == expected)
                #expect(pulses.dropFirst().basicEvents == Array(expected.dropFirst()))
        }

        @Test("ambiguous projection preserves key sets order and case")
        func ambiguousEvents() {
                let events = [
                        AmbiguousInputEvent(keys: [.letterS, .letterD], case: .uppercased),
                        AmbiguousInputEvent(keys: [.letterA], case: .lowercased),
                        AmbiguousInputEvent(keys: [], case: .capsLocked)
                ]
                let pulses: [InputPulse] = [
                        .basic(BasicInputEvent(key: .letterR, case: .lowercased)),
                        .ambiguous(events[0]),
                        .combined(.ABC),
                        .ambiguous(events[1]),
                        .ambiguous(events[2])
                ]

                #expect(pulses.ambiguousEvents == events)
                #expect(pulses.suffix(2).ambiguousEvents == Array(events.suffix(2)))
        }

        @Test("keypad projection preserves combo order and excludes letter events")
        func keypadCombos() {
                let pulses: [InputPulse] = [
                        .combined(.MNO),
                        .basic(BasicInputEvent(key: .letterR, case: .lowercased)),
                        .combined(.GHI),
                        .ambiguous(AmbiguousInputEvent(keys: [.letterS, .letterD], case: .lowercased)),
                        .combined(.MNO)
                ]
                let expected: [KeypadCombo] = [.MNO, .GHI, .MNO]

                #expect(pulses.keypadCombos == expected)
                #expect(pulses.dropFirst().keypadCombos == Array(expected.dropFirst()))
        }

        @Test("empty pulse collections have empty projections")
        func emptyProjections() {
                let pulses: [InputPulse] = []

                #expect(pulses.basicEvents.isEmpty)
                #expect(pulses.ambiguousEvents.isEmpty)
                #expect(pulses.keypadCombos.isEmpty)
        }

        @Test("exact reverse lookup triggers are recognized in either letter pulse form", arguments: [VirtualInputKey.letterR, .letterV, .letterX, .letterQ])
        func reverseLookupTriggers(_ key: VirtualInputKey) {
                #expect(InputPulse.basic(BasicInputEvent(key: key, case: .lowercased)).isReverseLookupTrigger)
                #expect(InputPulse.ambiguous(AmbiguousInputEvent(keys: [key], case: .uppercased)).isReverseLookupTrigger)
        }

        @Test("ordinary keys empty sets ambiguous groups and keypad combos are not lookup triggers")
        func nonTriggers() {
                for key in [VirtualInputKey.letterA, .number1, .apostrophe] {
                        #expect(InputPulse.basic(BasicInputEvent(key: key, case: .uppercased)).isReverseLookupTrigger == false)
                        #expect(InputPulse.ambiguous(AmbiguousInputEvent(keys: [key], case: .capsLocked)).isReverseLookupTrigger == false)
                }
                for keys: Set<VirtualInputKey> in [[], [.letterQ, .letterW], [.letterR, .letterV]] {
                        #expect(InputPulse.ambiguous(AmbiguousInputEvent(keys: keys, case: .lowercased)).isReverseLookupTrigger == false)
                }
                for combo in Combo.allCases {
                        #expect(InputPulse.combined(combo).isReverseLookupTrigger == false)
                }
        }

        @Test("pulse equality and hashing preserve event type keys and case")
        func identity() {
                let basic = InputPulse.basic(BasicInputEvent(key: .letterA, case: .lowercased))
                let ambiguous = InputPulse.ambiguous(AmbiguousInputEvent(keys: [.letterA], case: .lowercased))
                let combined = InputPulse.combined(.ABC)
                let distinct: Set<InputPulse> = [
                        basic,
                        ambiguous,
                        combined,
                        .basic(BasicInputEvent(key: .letterA, case: .uppercased)),
                        .basic(BasicInputEvent(key: .letterB, case: .lowercased)),
                        .ambiguous(AmbiguousInputEvent(keys: [.letterA], case: .uppercased)),
                        .ambiguous(AmbiguousInputEvent(keys: [.letterA, .letterB], case: .lowercased)),
                        .combined(.DEF)
                ]

                #expect(distinct.count == 8)
                #expect(distinct.contains(.basic(BasicInputEvent(key: .letterA, case: .lowercased))))
                #expect(distinct.contains(.ambiguous(AmbiguousInputEvent(keys: [.letterA], case: .lowercased))))
                #expect(distinct.contains(.combined(.ABC)))
                #expect(basic != ambiguous)
                #expect(basic != combined)
                #expect(ambiguous != combined)
        }
}
