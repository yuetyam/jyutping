import CommonExtensions

/// 漢字字符集標準／字形標準
public enum CharacterStandard: Int, CaseIterable, Sendable {

        /// Traditional (Default). 傳統漢字(預設)
        case preset = 1

        /// Traditional, Custom Variant. 傳統漢字・自定轉換字符集
        case custom = 2

        /// Traditional, Inherited, Old School. 傳統漢字・舊字形・傳承字形
        case inherited = 3

        /// Traditional, Philology, Grammatology. 傳統漢字・字源、字理、文字學
        case etymology = 4

        /// Traditional, OpenCC. 傳統漢字・OpenCC 字表
        case opencc = 5

        /// Traditional, Hong Kong. 傳統漢字・香港《常用字字形表》
        case hongkong = 6

        /// Traditional, Taiwan. 傳統漢字・臺灣《國字標準字體表》
        case taiwan = 7

        /// Traditional, PRC Mainland. 傳統漢字・大陸《通用規範漢字表》
        case prcGeneral = 8

        /// Traditional, PRC Mainland. 傳統漢字・大陸《古籍印刷通用字規範字形表》
        case ancientBooksPublishing = 9

        /// Simplified, PRC Mainland. 簡化字・大陸《通用規範漢字表》
        case mutilated = 51
}

extension CharacterStandard {

        /// isSimplified
        public var isMutilated: Bool {
                return self == .mutilated
        }

        /// isNotSimplified
        public var isTraditional: Bool {
                return self != .mutilated
        }

        /// Match the CharacterStandard for the given RawValue
        /// - Parameter value: RawValue
        /// - Returns: CharacterStandard
        public static func standard(of value: Int) -> CharacterStandard {
                return allCases.first(where: { $0.rawValue == value }) ?? .preset
        }
}
