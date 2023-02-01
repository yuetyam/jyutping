/// 字符集標準
///
/// 1: 傳統漢字
///
/// 2: 傳統漢字・香港
///
/// 3: 傳統漢字・臺灣
///
/// 4: 簡化字
public enum Logogram: Int {

        /// Traditional. 傳統漢字
        case traditional = 1

        /// Traditional, Hong Kong. 傳統漢字・香港
        case hongkong = 2

        /// Traditional, Taiwan. 傳統漢字・臺灣
        case taiwan = 3

        /// Simplified. 簡化字
        case simplified = 4
}
