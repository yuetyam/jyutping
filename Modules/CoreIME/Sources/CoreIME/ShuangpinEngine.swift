import Foundation
import CommonExtensions

/// Converts the keyboard's shuangpin input into full Jyutping candidates.
enum ShuangpinEngine {

        /// Initial key -> full Jyutping initial.
        private static let initialsByKey: [String: String] = [
                "b": "b",
                "c": "c",
                "d": "d",
                "f": "f",
                "g": "g",
                "h": "h",
                "i": "gw",
                "k": "k",
                "l": "l",
                "m": "m",
                "n": "n",
                "o": "",
                "p": "p",
                "s": "s",
                "t": "t",
                "u": "kw",
                "v": "ng",
                "w": "w",
                "y": "j",
                "z": "z"
        ]

        /// Final key -> possible full Jyutping finals.
        private static let finalsByKey: [String: [String]] = [
                ";": ["ik", "ing"],
                "a": ["aa"],
                "b": ["ou"],
                "c": ["aam", "aap"],
                "d": ["am", "ap"],
                "e": ["e"],
                "f": ["an", "at"],
                "g": ["ak", "ang", "eng"],
                "h": ["aak", "aang"],
                "i": ["i"],
                "j": ["aan", "aat"],
                "k": ["aau", "au"],
                "l": ["aai", "ai"],
                "m": ["im", "ip"],
                "n": ["in"],
                "o": ["o", "oi"],
                "p": ["eon", "un", "ung", "ut"],
                "q": ["iu"],
                "r": ["uk", "yun", "yut"],
                "s": ["ok", "on", "ong", "ot"],
                "t": ["ek", "it"],
                "u": ["u"],
                "v": ["ui", "yu"],
                "w": ["oe"],
                "x": ["oek", "oeng"],
                "y": ["eoi", "eot"],
                "z": ["ei"]
        ]

        private static let maximumExpansionCount: Int = 512

        static func suggest<T: RandomAccessCollection<VirtualInputKey>>(_ keys: T, deepSearch: Bool) -> [Lexicon] {
                let keyArray: [VirtualInputKey] = Array(keys)
                let typedText: String = keyArray.map(\.text).joined()
                let shuangpinText: String = keyArray.compactMap({ key -> Character? in
                        if key.isLetter {
                                return key.character
                        } else if key.isApostrophe || key.isGrave {
                                return Character(";")
                        } else {
                                return nil
                        }
                }).map(String.init).joined()
                let characters: [Character] = Array(shuangpinText)
                let chunks: [String] = stride(from: 0, to: characters.count, by: 2).map { index -> String in
                        let start = characters.index(characters.startIndex, offsetBy: index)
                        let end = characters.index(start, offsetBy: 2, limitedBy: characters.endIndex) ?? characters.endIndex
                        return String(characters[start..<end])
                }
                let completeChunks: [String] = chunks.filter({ $0.count == 2 })
                guard completeChunks.isNotEmpty else { return [] }
                let optionSets: [[String]] = completeChunks.compactMap({ options(for: $0) })
                guard optionSets.count == completeChunks.count else { return [] }
                let expansionCount: Int = optionSets.reduce(1, { $0 * $1.count })
                let limitedOptionSets: [[String]] = expansionCount > maximumExpansionCount ? optionSets.map({ Array($0.prefix(1)) }) : optionSets
                let combinations: [[String]] = combine(limitedOptionSets)
                var results: [Lexicon] = []
                for syllables in combinations {
                        let fullText: String = syllables.joined()
                        let fullKeys: [VirtualInputKey] = fullText.compactMap(VirtualInputKey.matchInputKey(for:))
                        guard fullKeys.count == fullText.count else { continue }
                        let segmentation = Segmenter.segment(fullKeys)
                        let matched: [Lexicon] = Engine.suggest(fullKeys, segmentation: segmentation, deepSearch: deepSearch)
                        let remapped: [Lexicon] = matched.map({ item in
                                Lexicon(type: item.type, text: item.text, romanization: item.romanization, input: typedText, mark: item.mark, number: item.number, attached: item.attached)
                        })
                        results.append(contentsOf: remapped)
                }
                return results.distinct()
        }

        private static func options(for code: String) -> [String]? {
                if code == "om" {
                        return ["m"]
                }
                if code == "ov" {
                        return ["ng"]
                }
                guard code.count == 2 else { return nil }
                let characters: [Character] = Array(code)
                let initialKey: String = String(characters[0])
                let finalKey: String = String(characters[1])
                guard let initial: String = initialsByKey[initialKey] else { return nil }
                guard let finals: [String] = finalsByKey[finalKey] else { return nil }
                return finals.map({ initial + $0 })
        }

        private static func combine(_ optionSets: [[String]]) -> [[String]] {
                guard let first = optionSets.first else { return [[]] }
                let rest = combine(Array(optionSets.dropFirst()))
                return first.flatMap({ syllable in
                        rest.map({ [syllable] + $0 })
                })
        }
}
