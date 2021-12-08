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

        private static func fetch(name: String, type: String = "txt") -> [String] {
                guard let path: String = Bundle.module.path(forResource: name, ofType: type) else { return [] }
                guard let content: String = try? String(contentsOfFile: path) else { return [] }
                let sourceLines: [String] = content.components(separatedBy: .newlines)
                let transformed: [String] = sourceLines.map { line -> String in
                        guard let codes: String = line.components(separatedBy: "#").first else { return "X" }
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
                lazy var fallback: Character = "X"
                let cropped = codePoint.dropFirst(2)
                guard let u32 = UInt32(cropped, radix: 16) else { return fallback }
                guard let scalar = Unicode.Scalar(u32) else { return fallback }
                return Character(scalar)
        }
}
