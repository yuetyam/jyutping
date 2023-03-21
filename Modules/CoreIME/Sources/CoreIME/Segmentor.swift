import Foundation
import SQLite3

// MARK: - Segmentation

public struct SegmentToken: Hashable {
        public let text: String
        let origin: String
}

public typealias SegmentScheme = Array<SegmentToken>
public typealias Segmentation = Array<SegmentScheme>

extension SegmentScheme {
        public var length: Int {
                return self.map(\.text.count).reduce(0, +)
        }
}
extension Segmentation {
        public var maxLength: Int {
                return self.first?.length ?? 0
        }
}

public struct Segmentor {

        // MARK: - Database

        private static var database: OpaquePointer? = nil
        private static var isDatabaseReady: Bool = false
        static func prepare() {
                guard !isDatabaseReady else { return }
                guard sqlite3_open_v2(":memory:", &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK else { return }
                createTokenTable()
                isDatabaseReady = true
        }
        private static func createTokenTable() {
                let createTable: String = "CREATE TABLE tokentable(code INTEGER NOT NULL PRIMARY KEY, token TEXT NOT NULL, origin TEXT NOT NULL);"
                var createStatement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(database, createTable, -1, &createStatement, nil) == SQLITE_OK else { sqlite3_finalize(createStatement); return }
                guard sqlite3_step(createStatement) == SQLITE_DONE else { sqlite3_finalize(createStatement); return }
                sqlite3_finalize(createStatement)
                guard let url = Bundle.module.url(forResource: "syllables", withExtension: "txt") else { return }
                guard let content = try? String(contentsOf: url) else { return }
                let sourceLines: [String] = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
                let entries = sourceLines.map { line -> String? in
                        let parts = line.split(separator: "\t")
                        guard parts.count == 3 else { return nil }
                        let code = parts[0]
                        let token = parts[1]
                        let origin = parts[2]
                        return "(\(code), '\(token)', '\(origin)')"
                }
                let values: String = entries.compactMap({ $0 }).joined(separator: ", ")
                let insertValues: String = "INSERT INTO tokentable (code, token, origin) VALUES \(values);"
                var insertStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(insertStatement) }
                guard sqlite3_prepare_v2(database, insertValues, -1, &insertStatement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(insertStatement) == SQLITE_DONE else { return }
        }


        // MARK: - SQLite

        private static func match(text: String) -> SegmentToken? {
                let queryString = "SELECT token, origin FROM tokentable WHERE code = \(text.hash);"
                var queryStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(queryStatement) }
                guard sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK else { return nil }
                guard sqlite3_step(queryStatement) == SQLITE_ROW else { return nil }
                let token = String(cString: sqlite3_column_text(queryStatement, 0))
                let origin = String(cString: sqlite3_column_text(queryStatement, 1))
                guard token == text else { return nil }
                return SegmentToken(text: token, origin: origin)
        }
        private static func canSplit(_ text: String) -> Bool {
                let queryString = "SELECT token FROM tokentable WHERE code = \(text.hash);"
                var queryStatement: OpaquePointer? = nil
                defer { sqlite3_finalize(queryStatement) }
                guard sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK else { return false }
                guard sqlite3_step(queryStatement) == SQLITE_ROW else { return false }
                let token = String(cString: sqlite3_column_text(queryStatement, 0))
                return token == text
        }


        // MARK: - Split

        private static func splitLeading(_ text: String) -> [SegmentToken] {
                guard !(text.isEmpty) else { return [] }
                let maxLength: Int = min(text.count, 6)
                let tokens = (1...maxLength).map { length -> SegmentToken? in
                        let prefixSlice: String = String(text.prefix(length))
                        return match(text: prefixSlice)
                }
                return tokens.compactMap({ $0 })
        }

        private static func split(text: String) -> Segmentation {
                let leadingTokens = splitLeading(text)
                guard !(leadingTokens.isEmpty) else { return [] }
                let textCount = text.count
                var segmentation: Segmentation = leadingTokens.map({ [$0] })
                var cache = segmentation
                var shouldContinue: Bool = true
                while shouldContinue {
                        for scheme in segmentation {
                                let schemeLength = scheme.length
                                guard schemeLength < textCount else { continue }
                                let tailText: String = String(text.dropFirst(schemeLength))
                                let tailTokens = splitLeading(tailText)
                                guard !tailTokens.isEmpty else { continue }
                                let newSegmentation: Segmentation = tailTokens.map({ scheme + [$0] })
                                segmentation = (segmentation + newSegmentation).uniqued()
                        }
                        if segmentation != cache {
                                cache = segmentation
                        } else {
                                shouldContinue = false
                        }
                }
                return segmentation.uniqued().descended()
        }

        public static func segment(text: String) -> Segmentation {
                switch text.count {
                case 0:
                        return []
                case 1:
                        guard let token = match(text: text) else { return [] }
                        return [[token]]
                default:
                        let rawText = text.filter({ !$0.isSeparatorOrTone })
                        return split(text: rawText)
                }
        }
}

private extension Segmentation {
        func descended() -> Segmentation {
                return self.sorted(by: {
                        let lhsLength = $0.length
                        let rhsLength = $1.length
                        if lhsLength == rhsLength {
                                return $0.count < $1.count
                        } else {
                                return lhsLength > rhsLength
                        }
                })
        }
}
