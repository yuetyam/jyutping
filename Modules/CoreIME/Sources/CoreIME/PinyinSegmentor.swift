import Foundation
import SQLite3

public struct PinyinSegmentor {

        public static func segment(text: String) -> [[String]] {
                switch text.count {
                case 0:
                        return []
                case 1:
                        switch text {
                        case "a", "o", "e":
                                return [[text]]
                        default:
                                return []
                        }
                default:
                        return split(text)
                }
        }

        private static func split(_ text: String) -> [[String]] {
                let leadingTokens: [String] = splitLeading(text)
                guard leadingTokens.isNotEmpty else { return [] }
                let textCount = text.count
                var segmentation: [[String]] = leadingTokens.map({ [$0] })
                var previousSubelementCount = segmentation.subelementCount
                var shouldContinue: Bool = true
                while shouldContinue {
                        for scheme in segmentation {
                                let schemeLength = scheme.summedLength
                                guard schemeLength < textCount else { continue }
                                let tailText = String(text.dropFirst(schemeLength))
                                let tailTokens = splitLeading(tailText)
                                guard tailTokens.isNotEmpty else { continue }
                                let newSegmentation: [[String]] = tailTokens.map({ scheme + [$0] })
                                segmentation += newSegmentation
                        }
                        segmentation = segmentation.uniqued()
                        let currentSubelementCount = segmentation.subelementCount
                        if currentSubelementCount != previousSubelementCount {
                                previousSubelementCount = currentSubelementCount
                        } else {
                                shouldContinue = false
                        }
                }
                let sequences: [[String]] = segmentation.sorted(by: {
                        let lhsLength: Int = $0.summedLength
                        let rhsLength: Int = $1.summedLength
                        if lhsLength == rhsLength {
                                return $0.count < $1.count
                        } else {
                                return lhsLength > rhsLength
                        }
                })
                return sequences
        }

        private static func splitLeading(_ text: String) -> [String] {
                let maxLength: Int = min(text.count, 6)
                guard maxLength > 0 else { return [] }
                let tokens = (1...maxLength).reversed().compactMap({ match(text.prefix($0)) })
                return tokens
        }

        private static func match<T: StringProtocol>(_ text: T) -> String? {
                guard let code: Int = text.charcode else { return nil }
                let command: String = "SELECT syllable FROM pinyinsyllabletable WHERE code = \(code) LIMIT 1;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                #if os(iOS)
                guard sqlite3_prepare_v2(Segmentor.database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                #else
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                #endif
                guard sqlite3_step(statement) == SQLITE_ROW else { return nil }
                let syllable: String = String(cString: sqlite3_column_text(statement, 0))
                return syllable
        }
}
