public struct AmbiguousInputEvent: Hashable, Sendable {

        public let keys: Set<VirtualInputKey>
        public let `case`: KeyboardCase

        public init(keys: Set<VirtualInputKey>, `case`: KeyboardCase) {
                self.keys = keys
                self.case = `case`
        }
}

extension RandomAccessCollection where Element == AmbiguousInputEvent {
        public func basicTransformed() -> Array<BasicInputEvent> {
                return compactMap({ event -> BasicInputEvent? in
                        guard let key = event.keys.first else { return nil }
                        return BasicInputEvent(key: key, case: event.case)
                })
        }
}
