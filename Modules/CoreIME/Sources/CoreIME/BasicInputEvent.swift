public struct BasicInputEvent: Hashable, Sendable {

        public let key: VirtualInputKey
        public let `case`: KeyboardCase

        public var isCapitalized: Bool { self.case.isCapitalized }

        public init(key: VirtualInputKey, `case`: KeyboardCase) {
                self.key = key
                self.`case` = `case`
        }

        public init(key: VirtualInputKey, isCapitalized: Bool) {
                self.key = key
                self.`case` = isCapitalized ? .uppercased : .lowercased
        }
}
