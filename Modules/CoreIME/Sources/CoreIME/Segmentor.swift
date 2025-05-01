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

        private static let queryCommand: String = "SELECT alias, origin FROM syllabletable WHERE aliascode = ? LIMIT 1;"
        private static func prepareStatement() -> OpaquePointer? {
                var statement: OpaquePointer? = nil
                guard sqlite3_prepare_v2(Engine.database, queryCommand, -1, &statement, nil) == SQLITE_OK else { return nil }
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
        private static func match<T: RandomAccessCollection<InputEvent>>(events: T, statement: OpaquePointer?) -> SegmentToken? {
                let code = events.map(\.code).radix100Combined()
                guard code > 0 else { return nil }
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
                return (1...maxLength).reversed().compactMap({ match(text: text.prefix($0), statement: statement) })
        }
        private static func splitLeading<T: RandomAccessCollection<InputEvent>>(events: T, statement: OpaquePointer?)-> [SegmentToken] {
                let maxLength: Int = min(events.count, 6)
                guard maxLength > 0 else { return [] }
                return (1...maxLength).reversed().compactMap({ match(events: events.prefix($0), statement: statement) })
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
        private static func split<T: RandomAccessCollection<InputEvent>>(events: T, statement: OpaquePointer?) -> Segmentation {
                let leadingTokens = splitLeading(events: events, statement: statement)
                guard leadingTokens.isNotEmpty else { return [] }
                let eventCount = events.count
                var segmentation: Set<SegmentScheme> = Set(leadingTokens.map({ [$0] }))
                var previousSubelementCount = segmentation.subelementCount
                var shouldContinue: Bool = true
                while shouldContinue {
                        for scheme in segmentation {
                                let schemeLength = scheme.length
                                guard schemeLength < eventCount else { continue }
                                let tail = events.dropFirst(schemeLength)
                                let tailTokens = splitLeading(events: tail, statement: statement)
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
                case 4 where events.map(\.code).radix100Combined() == 32203220:
                        return mama
                case 4 where events.map(\.code).radix100Combined() == 32203228:
                        return mami
                default:
                        let statement = prepareStatement()
                        defer { sqlite3_finalize(statement) }
                        let letterEvents = events.filter(\.isLetter)
                        return split(events: letterEvents, statement: statement)
                }
        }

        private static let letterA: Segmentation = [[SegmentToken(text: "a", origin: "aa")]]
        private static let letterO: Segmentation = [[SegmentToken(text: "o", origin: "o")]]
        private static let letterM: Segmentation = [[SegmentToken(text: "m", origin: "m")]]
        private static let mama: Segmentation = [[SegmentToken(text: "ma", origin: "maa"), SegmentToken(text: "ma", origin: "maa")]]
        private static let mami: Segmentation = [[SegmentToken(text: "ma", origin: "maa"), SegmentToken(text: "mi", origin: "mi")]]
}
