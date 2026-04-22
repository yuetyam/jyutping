public struct AmbiguousInputEvent: Hashable, Sendable {

        public let keys: Set<VirtualInputKey>
        public let `case`: KeyboardCase

        public init(keys: Set<VirtualInputKey>, `case`: KeyboardCase) {
                self.keys = keys
                self.`case` = `case`
        }
}
