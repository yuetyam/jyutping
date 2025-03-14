/// 倉頡／速成版本
public enum CangjieVariant: Int, CaseIterable {

        /// 倉頡五代
        case cangjie5 = 11

        /// 倉頡三代
        case cangjie3 = 12

        /// 速成五代
        case quick5 = 21

        /// 速成三代
        case quick3 = 22
        
        /// Match the variant for the given RawValue
        /// - Parameter value: RawValue
        /// - Returns: CangjieVariant
        public static func variant(of value: Int) -> CangjieVariant {
                return Self.allCases.first(where: { $0.rawValue == value }) ?? Self.cangjie5
        }
}
