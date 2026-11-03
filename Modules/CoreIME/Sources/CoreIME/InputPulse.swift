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
                        case .basic(let event): event
                        case .ambiguous: nil
                        case .combined: nil
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
