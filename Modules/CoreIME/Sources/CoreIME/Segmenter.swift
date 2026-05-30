import Foundation
import SQLite3
import CommonExtensions
import os.log

public struct Syllable: Hashable, Comparable, Sendable {

        init(aliasCode: Int, originCode: Int) {
                self.aliasCode = aliasCode
                self.originCode = originCode
                self.alias = aliasCode.matchedInputKeys
                self.origin = originCode.matchedInputKeys
        }

        let aliasCode: Int
        let originCode: Int
        let alias: Array<VirtualInputKey>
        let origin: Array<VirtualInputKey>

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

        /// Count of all alias input keys
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

        /// Anchors of alias input keys
        public var aliasAnchors: [VirtualInputKey] {
                return compactMap(\.alias.first)
        }

        /// Anchors of origin input keys
        public var originAnchors: [VirtualInputKey] {
                return compactMap(\.origin.first)
        }

        /// Anchors of alias input key texts, conjoined as one text
        public var aliasAnchorsText: String {
                return compactMap(\.alias.first?.text).joined()
        }

        /// Anchors of origin input key texts, conjoined as one text
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
        @available(*, unavailable, renamed: "isValid", message: "Use isValid instead. This old one just for documentation reference.")
        private var isValid_OLD: Bool {
                guard self.count > 1 else { return true }
                guard self.dropLast().contains(where: { $0.origin.last == VirtualInputKey.letterA }) else { return true }
                let originNumber = self.flatMap(\.origin).map(\.text).joined().occurrenceCount(pattern: "aa(m|ng)")
                guard originNumber > 0 else { return true }
                let aliasNumber = self.flatMap(\.alias).map(\.text).joined().occurrenceCount(pattern: "aa(m|ng)")
                guard aliasNumber > 0 else { return false }
                return originNumber == aliasNumber
        }

        // REASON: *am => [*aa, m] => *aam
        var isValid: Bool {
                guard self.count > 1 else { return true }
                guard self.dropLast().contains(where: { $0.origin.last == VirtualInputKey.letterA }) else { return true }
                let originCount = longAEndingCount(in: \.originCode)
                guard originCount > 0 else { return true }
                return originCount == longAEndingCount(in: \.aliasCode)
        }
        private func longAEndingCount(in keyPath: KeyPath<Syllable, Int>) -> Int {
                let letterACode = VirtualInputKey.letterA.code
                let letterGCode = VirtualInputKey.letterG.code
                let letterMCode = VirtualInputKey.letterM.code
                let letterNCode = VirtualInputKey.letterN.code
                var count: Int = 0
                var thirdLastCode: Int = 0
                var secondLastCode: Int = 0
                var lastCode: Int = 0
                for syllable in self {
                        var syllableCode = syllable[keyPath: keyPath]
                        var divisor: Int = 1
                        while (syllableCode / divisor) >= 100 {
                                divisor *= 100
                        }
                        while divisor > 0 {
                                let keyCode = syllableCode / divisor
                                if secondLastCode == letterACode && lastCode == letterACode && keyCode == letterMCode {
                                        count += 1
                                } else if thirdLastCode == letterACode && secondLastCode == letterACode && lastCode == letterNCode && keyCode == letterGCode {
                                        count += 1
                                }
                                syllableCode %= divisor
                                divisor /= 100
                                thirdLastCode = secondLastCode
                                secondLastCode = lastCode
                                lastCode = keyCode
                        }
                }
                return count
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

        private static let logger = Logger(subsystem: "org.jyutping.Jyutping.CoreIME", category: "Segmenter")

        private static let syllableCodeMap: Dictionary<Int, Syllable> = {
                let command: String = "SELECT alias_code, origin_code FROM core_syllable_table;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [:] }
                var dict: [Int: Syllable] = [:]
                dict.reserveCapacity(1200)
                while sqlite3_step(statement) == SQLITE_ROW {
                        let aliasCode = Int(sqlite3_column_int64(statement, 0))
                        let originCode = Int(sqlite3_column_int64(statement, 1))
                        dict[aliasCode] = Syllable(aliasCode: aliasCode, originCode: originCode)
                }
                return dict
        }()
        static func prepare() {
                if syllableCodeMap.count == 0 {
                        logger.warning("Syllable Dictionary is Empty")
                }
        }

        private static func lookup(by code: Int) -> Syllable? {
                return syllableCodeMap[code]
        }
        private static func splitLeading<T: RandomAccessCollection<VirtualInputKey>>(_ keys: T) -> [Syllable] {
                let maxLength: Int = min(keys.count, 6)
                guard maxLength > 0 else { return [] }
                return (1...maxLength).reversed().compactMap({ lookup(by: keys.prefix($0).combinedCode) })
        }
        private static func split<T: RandomAccessCollection<VirtualInputKey>>(_ keys: T) -> Segmentation {
                let headSyllables = splitLeading(keys)
                guard headSyllables.isNotEmpty else { return [] }
                let inputLength = keys.count
                var segmentation: Set<Scheme> = []
                var frontier: [Scheme] = []
                for syllable in headSyllables {
                        let scheme: Scheme = [syllable]
                        if segmentation.insert(scheme).inserted {
                                frontier.append(scheme)
                        }
                }
                while frontier.isNotEmpty {
                        var nextFrontier: [Scheme] = []
                        for scheme in frontier {
                                let schemeLength = scheme.length
                                guard schemeLength < inputLength else { continue }
                                let tailKeys = keys.dropFirst(schemeLength)
                                let tailSyllables = splitLeading(tailKeys)
                                for tail in tailSyllables {
                                        let newScheme = scheme + [tail]
                                        if segmentation.insert(newScheme).inserted {
                                                nextFrontier.append(newScheme)
                                        }
                                }
                        }
                        frontier = nextFrontier
                }
                return segmentation.filter(\.isValid).descended()
        }
        public static func segment<T: RandomAccessCollection<VirtualInputKey>>(_ keys: T) -> Segmentation {
                switch keys.count {
                case 0: return []
                case 1:
                        switch keys.first {
                        case .letterA: return letterA
                        case .letterO: return letterO
                        case .letterM: return letterM
                        default: return []
                        }
                case 4:
                        switch keys.combinedCode {
                        case 32203220: return mama
                        case 32203228: return mami
                        default:
                                return split(keys.filter(\.isSyllableLetter))
                        }
                default:
                        return split(keys.filter(\.isSyllableLetter))
                }
        }

        public static func bestSegmentedKeys(from keySets: [Set<VirtualInputKey>]) -> [(keys: [VirtualInputKey], segmentation: Segmentation)] {
                guard keySets.isNotEmpty else { return [] }
                var bestLength: Int = 0
                var items: [(keys: [VirtualInputKey], segmentation: Segmentation)] = []
                var keys: [VirtualInputKey] = []
                keys.reserveCapacity(keySets.count)
                func appendKeys(at index: Int) {
                        guard index < keySets.count else {
                                let segmentation = segment(keys)
                                let length = segmentation.first?.length ?? 0
                                guard length >= bestLength else { return }
                                if length > bestLength {
                                        bestLength = length
                                        items.removeAll(keepingCapacity: true)
                                }
                                items.append((keys, segmentation))
                                return
                        }
                        for key in keySets[index] {
                                keys.append(key)
                                appendKeys(at: index + 1)
                                keys.removeLast()
                        }
                }
                appendKeys(at: 0)
                return items
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

        public static func syllableText<T: RandomAccessCollection<VirtualInputKey>>(of keys: T) -> String? {
                guard keys.count <= 6 else { return nil }
                return lookup(by: keys.combinedCode)?.originText
        }
}
