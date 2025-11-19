import Foundation
import SQLite3
import CommonExtensions

public struct Syllable: Hashable, Comparable, Sendable {

        init(aliasCode: Int, originCode: Int) {
                self.aliasCode = aliasCode
                self.originCode = originCode
                self.alias = aliasCode.matchedInputEvents
                self.origin = originCode.matchedInputEvents
        }

        let aliasCode: Int
        let originCode: Int
        let alias: Array<InputEvent>
        let origin: Array<InputEvent>

        public static func ==(lhs: Syllable, rhs: Syllable) -> Bool {
                return lhs.aliasCode == rhs.aliasCode && lhs.originCode == rhs.originCode
        }
        public func hash(into hasher: inout Hasher) {
                hasher.combine(aliasCode)
                hasher.combine(originCode)
        }
        public static func <(lhs: Syllable, rhs: Syllable) -> Bool {
                let aliasQuotient = lhs.aliasCode / rhs.aliasCode
                guard aliasQuotient == 0 else { return true }
                let originQuotient = lhs.originCode / rhs.originCode
                return originQuotient > 0
        }

        var aliasText: String {
                return alias.map(\.text).joined()
        }
        var originText: String {
                return origin.map(\.text).joined()
        }
}

public typealias Scheme = Array<Syllable>
public typealias Segmentation = Array<Scheme>

extension RandomAccessCollection where Element == Syllable {

        /// Count of all alias events
        public var length: Int {
                return map(\.alias.count).summation
        }

        /// Alias texts conjoined as one text
        public var aliasText: String {
                return flatMap(\.alias).map(\.text).joined()
        }

        /// Origin texts conjoined as one text
        public var originText: String {
                return flatMap(\.origin).map(\.text).joined()
        }

        /// Anchors of alias events
        public var aliasAnchors: [InputEvent] {
                return compactMap(\.alias.first)
        }

        /// Anchors of origin events
        public var originAnchors: [InputEvent] {
                return compactMap(\.origin.first)
        }

        /// Anchors of alias event texts, conjoined as one text
        public var aliasAnchorsText: String {
                return compactMap(\.alias.first?.text).joined()
        }

        /// Anchors of origin event texts, conjoined as one text
        public var originAnchorsText: String {
                return compactMap(\.origin.first?.text).joined()
        }

        /// Alias texts as syllables
        public var mark: String {
                return map(\.aliasText).joined(separator: String.space)
        }

        /// Origin texts as syllables
        public var syllableText: String {
                return map(\.originText).joined(separator: String.space)
        }
}

private extension Scheme {
        // REASON: *am => [*aa, m] => *aam
        var isValid: Bool {
                guard self.count > 1 else { return true }
                guard self.dropLast().contains(where: { $0.origin.last == InputEvent.letterA }) else { return true }
                let originNumber = self.flatMap(\.origin).map(\.text).joined().occurrenceCount(pattern: "aa(m|ng)")
                guard originNumber > 0 else { return true }
                let aliasNumber = self.flatMap(\.alias).map(\.text).joined().occurrenceCount(pattern: "aa(m|ng)")
                guard aliasNumber > 0 else { return false }
                return originNumber == aliasNumber
        }
}

private extension Sequence where Element == Scheme {
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

public struct Segmenter {

        public static func syllableText<T: RandomAccessCollection<InputEvent>>(of events: T) -> String? {
                guard events.count <= 6 else { return nil }
                let statement = prepareStatement()
                defer { sqlite3_finalize(statement) }
                return match(code: events.combinedCode, statement: statement)?.originText
        }

        private static let queryCommand: String = "SELECT origincode FROM syllabletable WHERE aliascode = ? LIMIT 1;"
        private static func prepareStatement() -> OpaquePointer? {
                var statement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(Engine.database, queryCommand, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }

        private static func match(code: Int, statement: OpaquePointer?) -> Syllable? {
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                guard sqlite3_step(statement) == SQLITE_ROW else { return nil }
                let originCode = Int(sqlite3_column_int64(statement, 0))
                return Syllable(aliasCode: code, originCode: originCode)
        }

        private static func splitLeading<T: RandomAccessCollection<InputEvent>>(events: T, statement: OpaquePointer?) -> [Syllable] {
                let maxLength: Int = min(events.count, 6)
                guard maxLength > 0 else { return [] }
                return (1...maxLength).reversed().compactMap({ match(code: events.prefix($0).combinedCode, statement: statement) })
        }

        private static func split<T: RandomAccessCollection<InputEvent>>(events: T, statement: OpaquePointer?) -> Segmentation {
                let headSyllables = splitLeading(events: events, statement: statement)
                guard headSyllables.isNotEmpty else { return [] }
                let eventCount = events.count
                var segmentation: Set<Scheme> = Set(headSyllables.map({ [$0] }))
                var previousSyllableCount = segmentation.flattenedCount
                var shouldContinue: Bool = true
                while shouldContinue {
                        for scheme in segmentation {
                                let schemeLength = scheme.length
                                guard schemeLength < eventCount else { continue }
                                let tailEvents = events.dropFirst(schemeLength)
                                let tailSyllables = splitLeading(events: tailEvents, statement: statement)
                                guard tailSyllables.isNotEmpty else { continue }
                                let newSegmentation = tailSyllables.map({ scheme + [$0] })
                                newSegmentation.forEach({ segmentation.insert($0) })
                        }
                        let currentSyllableCount = segmentation.flattenedCount
                        if currentSyllableCount != previousSyllableCount {
                                previousSyllableCount = currentSyllableCount
                        } else {
                                shouldContinue = false
                        }
                }
                return segmentation.filter(\.isValid).descended()
        }

        public static func segment<T: RandomAccessCollection<InputEvent>>(events: T) -> Segmentation {
                switch events.count {
                case 0: return []
                case 1:
                        switch events.first {
                        case .letterA: return letterA
                        case .letterO: return letterO
                        case .letterM: return letterM
                        default: return []
                        }
                case 4:
                        switch events.combinedCode {
                        case 32203220: return mama
                        case 32203228: return mami
                        default:
                                let statement = prepareStatement()
                                defer { sqlite3_finalize(statement) }
                                return split(events: events.filter(\.isSyllableLetter), statement: statement)
                        }
                default:
                        let statement = prepareStatement()
                        defer { sqlite3_finalize(statement) }
                        return split(events: events.filter(\.isSyllableLetter), statement: statement)
                }
        }

        private static let letterA: Segmentation = [[Syllable(aliasCode: 20, originCode: 2020)]]
        private static let letterO: Segmentation = [[Syllable(aliasCode: 34, originCode: 34)]]
        private static let letterM: Segmentation = [[Syllable(aliasCode: 32, originCode: 32)]]
        private static let mama: Segmentation = [[
                Syllable(aliasCode: 3220, originCode: 322020),
                Syllable(aliasCode: 3220, originCode: 322020)
        ]]
        private static let mami: Segmentation = [[
                Syllable(aliasCode: 3220, originCode: 322020),
                Syllable(aliasCode: 3228, originCode: 3228)
        ]]
}
