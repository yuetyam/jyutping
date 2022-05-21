import Foundation

public struct EmojiSource {

        public static func fetchAll() -> [[String]] {
                return [fetch(name: "emoji_0"),
                        fetch(name: "emoji_1"),
                        fetch(name: "emoji_2"),
                        fetch(name: "emoji_3"),
                        fetch(name: "emoji_4"),
                        fetch(name: "emoji_5"),
                        fetch(name: "emoji_6"),
                        fetch(name: "emoji_7")]
        }

        private static func fetch(name: String) -> [String] {
                guard let path: String = Bundle.module.path(forResource: name, ofType: "txt") else { return fallback(name) }
                guard let content: String = try? String(contentsOfFile: path) else { return fallback(name) }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let transformed: [String] = sourceLines.map { codes -> String in
                        let blocks: [String] = codes.components(separatedBy: ".")
                        switch blocks.count {
                        case 0, 1:
                                let character = character(from: codes)
                                return String(character)
                        default:
                                let characters: [Character] = blocks.map({ character(from: $0) })
                                return String(characters)
                        }
                }
                return transformed
        }

        /// Create a Character from the given Unicode Code Point String, e.g. 1F600
        /// - Parameter codePoint: e.g. 1F600
        /// - Returns: A Character
        private static func character(from codePoint: String) -> Character {
                lazy var fallback: Character = "?"
                guard let u32 = UInt32(codePoint, radix: 16) else { return fallback }
                guard let scalar = Unicode.Scalar(u32) else { return fallback }
                return Character(scalar)
        }

        private static func fallback(_ name: String) -> [String] {
                let number: Int = {
                        switch name {
                        case "emoji_0": return 480  // Smileys & People
                        case "emoji_1": return 204  // Animals & Nature
                        case "emoji_2": return 126  // Food & Drink
                        case "emoji_3": return 118  // Activity
                        case "emoji_4": return 131  // Travel & Places
                        case "emoji_5": return 222  // Objects
                        case "emoji_6": return 293  // Symbols
                        case "emoji_7": return 259  // Flags
                        default: return 500
                        }
                }()
                return Array(repeating: "?", count: number)
        }
}
