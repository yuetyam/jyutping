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

extension Segmentation {
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
        static func prepare() {
                let command: String = "SELECT rowid FROM syllabletable WHERE code = 20 LIMIT 1;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return }
                guard sqlite3_step(statement) == SQLITE_ROW else { return }
        }
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


        private static func match<T: StringProtocol>(_ text: T) -> SegmentToken? {
                guard let code: Int = text.charcode else { return nil }
                let command: String = "SELECT token, origin FROM syllabletable WHERE code = \(code) LIMIT 1;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                #if os(iOS)
                guard sqlite3_prepare_v2(Self.database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                #else
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return nil }
                #endif
                guard sqlite3_step(statement) == SQLITE_ROW else { return nil }
                let token: String = String(cString: sqlite3_column_text(statement, 0))
                let origin: String = String(cString: sqlite3_column_text(statement, 1))
                return SegmentToken(text: token, origin: origin)
        }

        private static func splitLeading<T: StringProtocol>(_ text: T)-> [SegmentToken] {
                let maxLength: Int = min(text.count, 6)
                guard maxLength > 0 else { return [] }
                let tokens = (1...maxLength).reversed().compactMap({ match(text.prefix($0)) })
                return tokens
        }

        private static func split(text: String) -> Segmentation {
                let leadingTokens = splitLeading(text)
                guard leadingTokens.isNotEmpty else { return [] }
                let textCount = text.count
                var segmentation: Segmentation = leadingTokens.map({ [$0] })
                var previousSubelementCount = segmentation.subelementCount
                var shouldContinue: Bool = true
                while shouldContinue {
                        for scheme in segmentation {
                                let schemeLength = scheme.length
                                guard schemeLength < textCount else { continue }
                                let tailText = text.dropFirst(schemeLength)
                                let tailTokens = splitLeading(tailText)
                                guard tailTokens.isNotEmpty else { continue }
                                let newSegmentation: Segmentation = tailTokens.map({ scheme + [$0] })
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
                return segmentation.filter(\.isValid).descended()
        }

        public static func segment(text: String) -> Segmentation {
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
                        let rawText: String = text.filter(\.isSeparatorOrTone.negative)
                        let key: Int = rawText.hash
                        if let cached = cachedSegmentations[key] {
                                return cached
                        } else {
                                let segmented = split(text: rawText)
                                cache(key: key, segmentation: segmented)
                                return segmented
                        }
                }
        }

        private static let maxCacheCount: Int = 1000
        nonisolated(unsafe) private static var cachedSegmentations: [Int: Segmentation] = [:]
        private static func cache(key: Int, segmentation: Segmentation) {
                defer { cachedSegmentations[key] = segmentation }
                guard cachedSegmentations.count > maxCacheCount else { return }
                cachedSegmentations = [:]
        }

        private static let letterA: Segmentation = [[SegmentToken(text: "a", origin: "aa")]]
        private static let letterO: Segmentation = [[SegmentToken(text: "o", origin: "o")]]
        private static let letterM: Segmentation = [[SegmentToken(text: "m", origin: "m")]]
        private static let mama: Segmentation = [[SegmentToken(text: "ma", origin: "maa"), SegmentToken(text: "ma", origin: "maa")]]
        private static let mami: Segmentation = [[SegmentToken(text: "ma", origin: "maa"), SegmentToken(text: "mi", origin: "mi")]]
}
