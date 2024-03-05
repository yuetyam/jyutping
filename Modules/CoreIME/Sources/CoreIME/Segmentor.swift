import Foundation
import SQLite3

// MARK: - Segmentation

public struct SegmentToken: Hashable {
        /// Token
        public let text: String
        /// Regular Jyutping Syllable
        public let origin: String
}

public typealias SegmentScheme = Array<SegmentToken>
public typealias Segmentation = Array<SegmentScheme>

extension SegmentScheme {
        /// All token texts character count
        public var length: Int {
                return self.map(\.text).summedLength
        }
}
extension Segmentation {
        /// Longest token text character count
        public var maxLength: Int {
                return self.first?.length ?? 0
        }
}

private extension SegmentScheme {
        // REASON: *am => [*aa, m] => *aam
        var isValid: Bool {
                let originNumber = self.map(\.origin).joined().occurrenceCount(pattern: "aa(m|ng)")
                guard originNumber > 0 else { return true }
                let tokenNumber = self.map(\.text).joined().occurrenceCount(pattern: "aa(m|ng)")
                guard tokenNumber > 0 else { return false }
                return originNumber == tokenNumber
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

public struct Segmentor {

        // MARK: - SQLite

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

        private static func match(_ code: Int) -> SegmentToken? {
                let query: String = "SELECT token, origin FROM syllabletable WHERE code = \(code);"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK else { return nil }
                guard sqlite3_step(statement) == SQLITE_ROW else { return nil }
                let token: String = String(cString: sqlite3_column_text(statement, 0))
                let origin: String = String(cString: sqlite3_column_text(statement, 1))
                return SegmentToken(text: token, origin: origin)
        }


        // MARK: - Split

        private static func splitLeading<T: StringProtocol>(_ text: T)-> [SegmentToken] {
                let maxLength: Int = min(text.count, 6)
                guard maxLength > 0 else { return [] }
                let tokens = (1...maxLength).reversed().map({ match(text.prefix($0).hash) })
                return tokens.compactMap({ $0 })
        }

        private static func split(text: String) -> Segmentation {
                let leadingTokens = splitLeading(text)
                guard !(leadingTokens.isEmpty) else { return [] }
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
                                guard !(tailTokens.isEmpty) else { continue }
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
                default:
                        let rawText: String = text.filter({ !$0.isSeparatorOrTone })
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

        private static let maxCachedCount: Int = 1000
        private static var cachedSegmentations: [Int: Segmentation] = [:]
        private static func cache(key: Int, segmentation: Segmentation) {
                defer { cachedSegmentations[key] = segmentation }
                guard cachedSegmentations.count > maxCachedCount else { return }
                cachedSegmentations = [:]
        }

        private static let letterA: Segmentation = [[SegmentToken(text: "a", origin: "aa")]]
        private static let letterO: Segmentation = [[SegmentToken(text: "o", origin: "o")]]
        private static let letterM: Segmentation = [[SegmentToken(text: "m", origin: "m")]]
}
