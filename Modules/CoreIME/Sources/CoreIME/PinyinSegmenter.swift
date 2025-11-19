import Foundation
import SQLite3
import CommonExtensions

public struct PinyinSyllable: Hashable, Comparable, Sendable {

        let code: Int
        let events: Array<InputEvent>
        let text: String

        public static func ==(lhs: PinyinSyllable, rhs: PinyinSyllable) -> Bool {
                return lhs.code == rhs.code
        }
        public func hash(into hasher: inout Hasher) {
                hasher.combine(code)
        }
        public static func <(lhs: PinyinSyllable, rhs: PinyinSyllable) -> Bool {
                return (lhs.code / rhs.code) > 0
        }
}

public typealias PinyinScheme = Array<PinyinSyllable>
public typealias PinyinSegmentation = Array<PinyinScheme>

extension PinyinScheme {
        public var length: Int {
                return map(\.events.count).summation
        }
        public var mark: String {
                return map(\.text).joined(separator: String.space)
        }
}

private extension Sequence where Element == PinyinScheme {
        func descended() -> PinyinSegmentation {
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

public struct PinyinSegmenter {

        public static func segment<T: RandomAccessCollection<InputEvent>>(events: T) -> PinyinSegmentation {
                let statement = prepareStatement()
                defer { sqlite3_finalize(statement) }
                return split(events: events.filter(\.isLetter), statement: statement)
        }
        private static func split<T: RandomAccessCollection<InputEvent>>(events: T, statement: OpaquePointer?) -> PinyinSegmentation {
                let headSyllables = splitLeading(events: events, statement: statement)
                guard headSyllables.isNotEmpty else { return [] }
                let eventCount = events.count
                var segmentation: Set<PinyinScheme> = Set(headSyllables.map({ [$0] }))
                var previousSyllableCount = segmentation.flattenedCount
                var shouldContinue: Bool = true
                while shouldContinue {
                        for scheme in segmentation {
                                let schemeLength: Int = scheme.length
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
                return segmentation.descended()
        }
        private static func splitLeading<T: RandomAccessCollection<InputEvent>>(events: T, statement: OpaquePointer?) -> [PinyinSyllable] {
                let maxLength: Int = min(events.count, 6)
                guard maxLength > 0 else { return [] }
                return (1...maxLength).reversed().compactMap({ number -> PinyinSyllable? in
                        let leadingEvents = events.prefix(number)
                        let code = leadingEvents.combinedCode
                        guard let text = match(code: code, statement: statement) else { return nil }
                        return PinyinSyllable(code: code, events: Array<InputEvent>(leadingEvents), text: text)
                })
        }

        private static func match(code: Int, statement: OpaquePointer?) -> String? {
                sqlite3_reset(statement)
                sqlite3_bind_int64(statement, 1, Int64(code))
                guard sqlite3_step(statement) == SQLITE_ROW else { return nil }
                guard let syllable = sqlite3_column_text(statement, 0) else { return nil }
                return String(cString: syllable)
        }

        private static let queryCommand: String = "SELECT syllable FROM pinyinsyllabletable WHERE code = ? LIMIT 1;"
        private static func prepareStatement() -> OpaquePointer? {
                var statement: OpaquePointer?
                guard sqlite3_prepare_v2(Engine.database, queryCommand, -1, &statement, nil) == SQLITE_OK else { return nil }
                return statement
        }
}
