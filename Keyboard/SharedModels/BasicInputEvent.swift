import CoreIME

struct BasicInputEvent: Hashable {
        let key: VirtualInputKey
        let `case`: KeyboardCase
}

struct AmbiguousInputEvent: Hashable {
        let keys: Set<VirtualInputKey>
        let `case`: KeyboardCase
}
