import Foundation
import SQLite3

// MARK: - Segmentation

public struct SegmentToken: Hashable, Sendable {
        /// Token
        public let text: String
        /// Regular Jyutping Syllable
        public let origin: String
}

public typealias SegmentScheme = Array<SegmentToken>
public typealias Segmentation = Array<SegmentScheme>

extension SegmentScheme {
        /// All token text character count
        public var length: Int {
                return self.map(\.text).summedLength
        }
}
extension Segmentation {
        /// Longest scheme token text character count
        public var maxSchemeLength: Int {
                return self.first?.length ?? 0
        }
        /// All token count
        public var tokenCount: Int {
                return self.map(\.count).summation
        }
}

extension SegmentScheme {
        // REASON: *am => [*aa, m] => *aam
        var isValid: Bool {
                let originNumber = self.map(\.origin).joined().occurrenceCount(pattern: "aa(m|ng)")
                guard originNumber > 0 else { return true }
                let tokenNumber = self.map(\.text).joined().occurrenceCount(pattern: "aa(m|ng)")
                guard tokenNumber > 0 else { return false }
                return originNumber == tokenNumber
        }
}

extension Sequence where Element == SegmentScheme {
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

public struct Segmentor {

        #if os(iOS)
        nonisolated(unsafe) static let database: OpaquePointer? = {
                var db: OpaquePointer? = nil
                guard let path: String = Bundle.module.path(forResource: "syllabledb", ofType: "sqlite3") else { return nil }
                var storageDatabase: OpaquePointer? = nil
                defer { sqlite3_close_v2(storageDatabase) }
                guard sqlite3_open_v2(path, &storageDatabase, SQLITE_OPEN_READONLY | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK else { return nil }
                guard sqlite3_open_v2(":memory:", &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE | SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK else { return nil }
                let backup = sqlite3_backup_init(db, "main", storageDatabase, "main")
                guard sqlite3_backup_step(backup, -1) == SQLITE_DONE else { return nil }
                guard sqlite3_backup_finish(backup) == SQLITE_OK else { return nil }
                return db
        }()
        #endif

        static func prepare() {
                let statement = prepareStatement()
                defer { sqlite3_finalize(statement) }
                let testCode: Int64 = 20
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, testCode)
                guard sqlite3_step(statement) == SQLITE_ROW else { return }
        }

        private static let queryCommand: String = "SELECT token, origin FROM syllabletable WHERE code = ? LIMIT 1;"
        private static func prepareStatement() -> OpaquePointer? {
                var statement: OpaquePointer? = nil
                #if os(iOS)
                guard sqlite3_prepare_v2(Self.database, queryCommand, -1, &statement, nil) == SQLITE_OK else { return nil }
                #else
                guard sqlite3_prepare_v2(Engine.database, queryCommand, -1, &statement, nil) == SQLITE_OK else { return nil }
                #endif
                return statement
        }

        private static func match<T: StringProtocol>(text: T, statement: OpaquePointer?) -> SegmentToken? {
                guard let code = text.charcode else { return nil }
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                guard sqlite3_step(statement) == SQLITE_ROW else { return nil }
                guard let token = sqlite3_column_text(statement, 0),
                      let origin = sqlite3_column_text(statement, 1) else { return nil }
                return SegmentToken(text: String(cString: token), origin: String(cString: origin))
        }

        private static func splitLeading<T: StringProtocol>(text: T, statement: OpaquePointer?)-> [SegmentToken] {
                let maxLength: Int = min(text.count, 6)
                guard maxLength > 0 else { return [] }
                let tokens = (1...maxLength).reversed().compactMap({ match(text: text.prefix($0), statement: statement) })
                return tokens
        }

        private static func split<T: StringProtocol>(text: T, statement: OpaquePointer?) -> Segmentation {
                let leadingTokens = splitLeading(text: text, statement: statement)
                guard leadingTokens.isNotEmpty else { return [] }
                let textCount = text.count
                var segmentation: Set<SegmentScheme> = Set(leadingTokens.map({ [$0] }))
                var previousSubelementCount = segmentation.subelementCount
                var shouldContinue: Bool = true
                while shouldContinue {
                        for scheme in segmentation {
                                let schemeLength = scheme.length
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
                return segmentation.filter(\.isValid).descended()
        }

        public static func segment<T: StringProtocol>(text: T) -> Segmentation {
                switch text.count {
                case 0:
                        return []
                case 1:
                        switch text {
                        case "a":
                                return letterA
                        case "o":
                                return letterO
                        case "m":
                                return letterM
                        default:
                                return []
                        }
                case 4 where text == "mama":
                        return mama
                case 4 where text == "mami":
                        return mami
                default:
                        let statement = prepareStatement()
                        defer { sqlite3_finalize(statement) }
                        if let text = text as? String {
                                let rawText = text.filter(\.isSeparatorOrTone.negative)
                                return split(text: rawText, statement: statement)
                        } else {
                                let rawText = text.filter(\.isSeparatorOrTone.negative)
                                return split(text: String(rawText), statement: statement)
                        }
                }
        }

        private static let letterA: Segmentation = [[SegmentToken(text: "a", origin: "aa")]]
        private static let letterO: Segmentation = [[SegmentToken(text: "o", origin: "o")]]
        private static let letterM: Segmentation = [[SegmentToken(text: "m", origin: "m")]]
        private static let mama: Segmentation = [[SegmentToken(text: "ma", origin: "maa"), SegmentToken(text: "ma", origin: "maa")]]
        private static let mami: Segmentation = [[SegmentToken(text: "ma", origin: "maa"), SegmentToken(text: "mi", origin: "mi")]]
}
