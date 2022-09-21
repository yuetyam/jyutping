/// 鍵盤佈局
///
/// 1: 全鍵盤 QWERTY
///
/// 2: 三拼
///
/// 3: 九宮格（未實現）
enum KeyboardLayout: Int, Hashable {

        /// 全鍵盤
        case qwerty = 1

        /// 三拼
        case saamPing = 2

        /// 九宮格
        case tenKey = 3
}
