import Foundation

/// The Cantonese Jyutping spelling mode used by the keyboard.
///
/// The raw value is persisted by the keyboard extension.
public enum JyutpingSpellingMode: Int, CaseIterable, Sendable {

        /// Traditional full Jyutping spelling.
        case full = 1

        /// Two-key-per-syllable Jyutping shuangpin spelling.
        case shuangpin = 2
}

extension JyutpingSpellingMode {

        /// Whether the mode uses shuangpin codes instead of full Jyutping.
        public var isShuangpin: Bool { self == .shuangpin }

        /// Resolves a saved raw value, falling back to `.full`.
        public static func mode(of value: Int) -> JyutpingSpellingMode {
                return allCases.first(where: { $0.rawValue == value }) ?? .full
        }
}
