/// A single input carrying a definite key, a set of possible keys, or a keypad letter group.
public enum InputPulse: Hashable, Sendable {

        /// A definite virtual key and its keyboard case.
        case basic(BasicInputEvent)

        /// A set of possible virtual keys sharing a keyboard case.
        case ambiguous(AmbiguousInputEvent)

        /// A nine-key keypad letter group without keyboard-case information.
        case combined(KeypadCombo)
}

public extension Collection where Element == InputPulse {

        /// Basic events and ambiguous events containing exactly one key, in collection order.
        ///
        /// Converted ambiguous events retain their keyboard case.
        /// Empty or multi-key ambiguous events and keypad combos are omitted.
        var basicEvents: [BasicInputEvent] {
                compactMap({ pulse -> BasicInputEvent? in
                        switch pulse {
                        case .basic(let event):
                                return event
                        case .ambiguous(let event):
                                guard (event.keys.count == 1), let key = event.keys.first else { return nil }
                                return BasicInputEvent(key: key, case: event.case)
                        case .combined:
                                return nil
                        }
                })
        }

        /// Only the ambiguous events, in collection order, including empty and single-key sets.
        var ambiguousEvents: [AmbiguousInputEvent] {
                compactMap({ pulse -> AmbiguousInputEvent? in
                        switch pulse {
                        case .basic: nil
                        case .ambiguous(let event): event
                        case .combined: nil
                        }
                })
        }

        /// Only the combined keypad letter groups, in collection order.
        var keypadCombos: [KeypadCombo] {
                compactMap({ pulse -> KeypadCombo? in
                        switch pulse {
                        case .basic: nil
                        case .ambiguous: nil
                        case .combined(let combo): combo
                        }
                })
        }
}

public extension InputPulse {

        /// Whether this pulse identifies a reverse-lookup trigger (`r`, `v`, `x`, or `q`), regardless of keyboard case.
        ///
        /// Basic events use their key's trigger status.
        /// Ambiguous events must contain exactly one key;
        /// keypad combos always return `false`.
        var isReverseLookupTrigger: Bool {
                switch self {
                case .basic(let event):
                        return event.key.isReverseLookupTrigger
                case .ambiguous(let event):
                        guard (event.keys.count == 1), let key = event.keys.first else { return false }
                        return key.isReverseLookupTrigger
                case .combined:
                        return false
                }
        }
}
