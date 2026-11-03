/// An input event representing a set of possible virtual keys with a shared keyboard case.
public struct AmbiguousInputEvent: Hashable, Sendable {

        /// The possible keys for this event; the set may be empty.
        public let keys: Set<VirtualInputKey>

        /// The keyboard case shared by all possible keys.
        public let `case`: KeyboardCase

        /// Creates an event preserving the supplied key set and keyboard case.
        /// - Parameters:
        ///   - keys: The possible virtual keys, without an ordering or preferred key.
        ///   - case: The keyboard case at the time of input.
        public init(keys: Set<VirtualInputKey>, `case`: KeyboardCase) {
                self.keys = keys
                self.case = `case`
        }
}
