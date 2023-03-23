import Foundation
import SQLite3

// MARK: - Segmentation

public struct SegmentToken: Hashable {
        /// Token
        public let text: String
        /// Regular Jyutping Syllable
        let origin: String
}

public typealias SegmentScheme = Array<SegmentToken>
public typealias Segmentation = Array<SegmentScheme>

extension SegmentScheme {
        /// All texts character count
        public var length: Int {
                return self.map(\.text).summedLength
        }
}
extension Segmentation {
        public var maxLength: Int {
                return self.first?.length ?? 0
        }
}

public struct Segmentor {

        // MARK: - Database

        private static var storageDatabase: OpaquePointer? = nil
        private static var database: OpaquePointer? = nil
        private static var isDatabaseReady: Bool = false

        static func prepare() {
                guard !isDatabaseReady else { return }
                guard let path: String = Bundle.module.path(forResource: "syllabledb", ofType: "sqlite3") else { return }
                guard sqlite3_open_v2(path, &storageDatabase, SQLITE_OPEN_READONLY, nil) == SQLITE_OK else { return }
                guard sqlite3_open_v2(":memory:", &database, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, nil) == SQLITE_OK else { return }
                let backup = sqlite3_backup_init(database, "main", storageDatabase, "main")
                guard sqlite3_backup_step(backup, -1) == SQLITE_DONE else { return }
                guard sqlite3_backup_finish(backup) == SQLITE_OK else { return }
                sqlite3_close_v2(storageDatabase)
                isDatabaseReady = true
        }


        // MARK: - SQLite

        private static func match(text: String) -> SegmentToken? {
                let queryString = "SELECT token, origin FROM syllabletable WHERE code = \(text.hash);"
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
                let queryString = "SELECT token FROM syllabletable WHERE code = \(text.hash);"
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
                var previousSegmentation = segmentation
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
                        if segmentation.subelementCount != previousSegmentation.subelementCount {
                                previousSegmentation = segmentation
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
