import AppKit

extension NSEvent.ModifierFlags {
        var isShift: Bool {
                return self == .shift
        }
}

extension UInt16 {
        var isShiftKeyCode: Bool {
                return self == KeyCode.Modifier.shiftLeft || self == KeyCode.Modifier.shiftRight
        }
}

enum ShiftSituation: Int {
        case irrelevant
        case transparent
        case buffer
        case handle
}
