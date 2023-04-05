enum WindowPattern: Int {

        case regular
        case horizontalReversed
        case verticalReversed
        case reversed

        var isReversingHorizontal: Bool {
                switch self {
                case .regular:
                        return false
                case .horizontalReversed:
                        return true
                case .verticalReversed:
                        return false
                case .reversed:
                        return true
                }
        }
        var isReversingVertical: Bool {
                switch self {
                case .regular:
                        return false
                case .horizontalReversed:
                        return false
                case .verticalReversed:
                        return true
                case .reversed:
                        return true
                }
        }
}
