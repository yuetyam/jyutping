/// Cantonese / ABC
enum InputMethodMode: Int, CaseIterable {

        case cantonese = 1
        case abc = 2

        var isCantonese: Bool { self == .cantonese }
        var isABC: Bool { self == .abc }

        static func mode(of value: Int) -> InputMethodMode {
                return allCases.first(where: { $0.rawValue == value }) ?? .cantonese
        }
}
