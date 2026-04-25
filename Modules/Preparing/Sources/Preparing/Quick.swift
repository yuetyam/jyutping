import Foundation
import SQLite3
import CommonExtensions

struct QuickEntry: Hashable {
        let word: String
        let quick5: String
        let quick3: String
        let q5complex: Int
        let q3complex: Int
        let q5code: Int
        let q3code: Int
}

struct Quick {
        static func generate() -> [QuickEntry] {
                let words = LexiconConverter.jyutpingSourceLines.compactMap({ line -> String? in
                        guard let word = line.split(separator: "\t").first else { return nil }
                        return word.trimmingCharacters(in: .whitespaces)
                }).distinct()
                return words.flatMap({ word -> [QuickEntry] in
                        switch word.count {
                        case 1:
                                let cangjie5Matches = Cangjie.match(cangjie5: word)
                                let cangjie3Matches = Cangjie.match(cangjie3: word)
                                guard !(cangjie5Matches.isEmpty && cangjie3Matches.isEmpty) else { return [] }
                                var instances: [QuickEntry] = []
                                let upperBound: Int = max(cangjie5Matches.count, cangjie3Matches.count)
                                for index in 0..<upperBound {
                                        let cangjie5: String = cangjie5Matches.fetch(index) ?? "X"
                                        let cangjie3: String = cangjie3Matches.fetch(index) ?? "X"
                                        let quick5: String = (cangjie5.count > 2) ? "\(cangjie5.first!)\(cangjie5.last!)" : cangjie5
                                        let quick3: String = (cangjie3.count > 2) ? "\(cangjie3.first!)\(cangjie3.last!)" : cangjie3
                                        let q5complex: Int = quick5.count
                                        let q3complex: Int = quick3.count
                                        let q5code: Int = quick5.charCode ?? 0
                                        let q3code: Int = quick3.charCode ?? 0
                                        let instance = QuickEntry(word: word, quick5: quick5, quick3: quick3, q5complex: q5complex, q3complex: q3complex, q5code: q5code, q3code: q3code)
                                        instances.append(instance)
                                }
                                return instances
                        default:
                                let characters: [String] = word.map({ String($0) })
                                let cangjie5Sequence: [String] = characters.map({ Cangjie.match(cangjie5: $0).first ?? "X" })
                                let cangjie3Sequence: [String] = characters.map({ Cangjie.match(cangjie3: $0).first ?? "X" })
                                let quick5Sequence: [String] = cangjie5Sequence.map({ $0.count > 2 ? "\($0.first!)\($0.last!)" : $0 })
                                let quick3Sequence: [String] = cangjie3Sequence.map({ $0.count > 2 ? "\($0.first!)\($0.last!)" : $0 })
                                let quick5 = quick5Sequence.joined()
                                let quick3 = quick3Sequence.joined()
                                let q5complex = quick5.count
                                let q3complex = quick3.count
                                let q5code: Int = quick5.charCode ?? 0
                                let q3code: Int = quick3.charCode ?? 0
                                let instance = QuickEntry(word: word, quick5: quick5, quick3: quick3, q5complex: q5complex, q3complex: q3complex, q5code: q5code, q3code: q3code)
                                return [instance]
                        }
                }).distinct()
        }
}
