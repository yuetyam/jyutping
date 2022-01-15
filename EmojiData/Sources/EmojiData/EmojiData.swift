import Foundation

public struct EmojiData {

        public static func fetchAll() -> [[String]] {
                return [EmojiData.fetch(name: "emoji_0"),
                        EmojiData.fetch(name: "emoji_1"),
                        EmojiData.fetch(name: "emoji_2"),
                        EmojiData.fetch(name: "emoji_3"),
                        EmojiData.fetch(name: "emoji_4"),
                        EmojiData.fetch(name: "emoji_5"),
                        EmojiData.fetch(name: "emoji_6"),
                        EmojiData.fetch(name: "emoji_7")]
        }

        private static func fetch(name: String) -> [String] {
                guard let path: String = Bundle.module.path(forResource: name, ofType: "txt") else { return fallback(name) }
                guard let content: String = try? String(contentsOfFile: path) else { return fallback(name) }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let transformed: [String] = sourceLines.map { line -> String in
                        guard let codes: String = line.components(separatedBy: "#").first else { return "?" }
                        if codes.contains(" ") {
                                let characters: [Character] = codes.components(separatedBy: " ").map({ character(from: $0) })
                                return String(characters)
                        } else {
                                let character = character(from: codes)
                                return String(character)
                        }
                }
                return transformed
        }

        /// Create a Character from the given Unicode Code Point String (U+XXXX)
        /// - Parameter codePoint: U+XXXX
        /// - Returns: A Character
        private static func character(from codePoint: String) -> Character {
                lazy var fallback: Character = "?"
                let cropped = codePoint.dropFirst(2)
                guard let u32 = UInt32(cropped, radix: 16) else { return fallback }
                guard let scalar = Unicode.Scalar(u32) else { return fallback }
                return Character(scalar)
        }

        private static func fallback(_ name: String) -> [String] {
                let number: Int = {
                        switch name {
                        case "emoji_0": return 461  // Smileys & People
                        case "emoji_1": return 199  // Animals & Nature
                        case "emoji_2": return 123  // Food & Drink
                        case "emoji_3": return 117  // Activity
                        case "emoji_4": return 128  // Travel & Places
                        case "emoji_5": return 217  // Objects
                        case "emoji_6": return 292  // Symbols
                        case "emoji_7": return 259  // Flags
                        default: return 500
                        }
                }()
                return Array(repeating: "?", count: number)
        }
}
