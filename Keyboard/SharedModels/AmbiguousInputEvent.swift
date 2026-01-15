import CoreIME

struct AmbiguousInputEvent: Hashable {
        let keys: Set<VirtualInputKey>
        let `case`: KeyboardCase
}
