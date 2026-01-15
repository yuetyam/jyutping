import CoreIME

struct BasicInputEvent: Hashable {
        let key: VirtualInputKey
        let `case`: KeyboardCase
}
