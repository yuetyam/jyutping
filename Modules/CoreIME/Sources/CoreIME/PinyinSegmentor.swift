import Foundation
import SQLite3

public struct PinyinSegmentor {

        public static func segment<T: StringProtocol>(text: T) -> [[String]] {
                switch text.count {
                case 0:
                        return []
                case 1:
                        switch text {
                        case "a", "o", "e":
                                return [[String(text)]]
                        default:
                                return []
                        }
                default:
                        let statement = prepareStatement()
                        defer { sqlite3_finalize(statement) }
                        return split(text: text, statement: statement)
                }
        }

        private static func split<T: StringProtocol>(text: T, statement: OpaquePointer?) -> [[String]] {
                let leadingTokens: [String] = splitLeading(text: text, statement: statement)
                guard leadingTokens.isNotEmpty else { return [] }
                let textCount = text.count
                var segmentation: Set<Array<String>> = Set(leadingTokens.map({ [$0] }))
                var previousSubelementCount = segmentation.subelementCount
                var shouldContinue: Bool = true
                while shouldContinue {
                        for scheme in segmentation {
                                let schemeLength = scheme.summedLength
                                guard schemeLength < textCount else { continue }
                                let tailText = text.dropFirst(schemeLength)
                                let tailTokens = splitLeading(text: tailText, statement: statement)
                                guard tailTokens.isNotEmpty else { continue }
                                let newSegmentation = tailTokens.map({ scheme + [$0] })
                                newSegmentation.forEach({ segmentation.insert($0) })
                        }
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

        private static func splitLeading<T: StringProtocol>(text: T, statement: OpaquePointer?) -> [String] {
                let maxLength: Int = min(text.count, 6)
                guard maxLength > 0 else { return [] }
                let tokens = (1...maxLength).reversed().compactMap({ match(text: text.prefix($0), statement: statement) })
                return tokens
        }

        private static func match<T: StringProtocol>(text: T, statement: OpaquePointer?) -> String? {
                guard let code: Int = text.charcode else { return nil }
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                guard sqlite3_step(statement) == SQLITE_ROW else { return nil }
                guard let syllable = sqlite3_column_text(statement, 0) else { return nil }
                return String(cString: syllable)
        }

        private static let queryCommand: String = "SELECT syllable FROM pinyinsyllabletable WHERE code = ? LIMIT 1;"
        private static func prepareStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                #if os(iOS)
                guard sqlite3_prepare_v2(Segmentor.database, queryCommand, -1, &statement, nil) == SQLITE_OK else { return nil }
                #else
                guard sqlite3_prepare_v2(Engine.database, queryCommand, -1, &statement, nil) == SQLITE_OK else { return nil }
                #endif
                return statement
        }
}
