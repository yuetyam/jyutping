public enum InputPulse: Hashable, Sendable {

        case basic(BasicInputEvent)

        case ambiguous(AmbiguousInputEvent)

        case combined(KeypadCombo)
}

public typealias KeypadCombo = Combo

public extension Collection where Element == InputPulse {

        var basicEvents: [BasicInputEvent] {
                compactMap({ pulse -> BasicInputEvent? in
                        switch pulse {
                        case .basic(let event):
                                return event
                        case .ambiguous(let event):
                                guard event.keys.count == 1, let key = event.keys.first else { return nil }
                                return BasicInputEvent(key: key, case: event.case)
                        case .combined:
                                return nil
                        }
                })
        }

        var ambiguousEvents: [AmbiguousInputEvent] {
                compactMap({ pulse -> AmbiguousInputEvent? in
                        switch pulse {
                        case .basic: nil
                        case .ambiguous(let event): event
                        case .combined: nil
                        }
                })
        }

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
