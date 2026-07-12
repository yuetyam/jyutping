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

public struct Segmenter {

        private static let logger = Logger(subsystem: "org.jyutping.Jyutping.CoreIME", category: "Segmenter")
        static func prepare() {
                if syllableCodeMap.isEmpty {
                        logger.warning("Syllable Dictionary is Empty")
                }
        }
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
        private static func lookup(by code: Int) -> Syllable? {
                return syllableCodeMap[code]
        }
        private static let syllableCodePrefixes: Set<Int> = {
                var prefixes: Set<Int> = []
                for syllable in syllableCodeMap.values {
                        var code: Int = 0
                        for key in syllable.alias {
                                code = code * 100 + key.code
                                prefixes.insert(code)
                        }
                }
                return prefixes
        }()

        private static let maxSyllableKeyCount: Int = 6

        private struct SplitEdge {
                let syllable: Syllable
                let endIndex: Int
        }
        private struct AmbiguousSplitEdge {
                let syllable: Syllable
                let endIndex: Int
                let matchedIndices: [Int]
        }
        private struct SplitNode {
                let syllable: Syllable
                let previousIndex: Int?
                let length: Int
                let count: Int
        }
        private struct AmbiguousSplitNode {
                let edge: AmbiguousSplitEdge
                let previousIndex: Int?
                let length: Int
                let count: Int
        }
        private static func splitEdges(for keys: [VirtualInputKey]) -> [[SplitEdge]] {
                let inputLength = keys.count
                var edges = Array(repeating: Array<SplitEdge>(), count: inputLength)
                for startIndex in 0..<inputLength {
                        var code: Int = 0
                        let endIndexLimit = min(inputLength, startIndex + maxSyllableKeyCount)
                        for endIndex in startIndex..<endIndexLimit {
                                code = code * 100 + keys[endIndex].code
                                guard let syllable = lookup(by: code) else { continue }
                                edges[startIndex].append(SplitEdge(syllable: syllable, endIndex: endIndex + 1))
                        }
                }
                return edges
        }
        private static func ambiguousSplitEdges(for keySets: [Set<VirtualInputKey>]) -> [[AmbiguousSplitEdge]] {
                let inputLength = keySets.count
                let syllableKeyOptions: [[VirtualInputKey]] = keySets.map({ $0.filter(\.isSyllableLetter).sorted() })
                let skippableIndices: [Bool] = keySets.map({ $0.contains(where: \.isSyllableLetter.negative) })
                var edges = Array(repeating: Array<AmbiguousSplitEdge>(), count: inputLength)
                for startIndex in 0..<inputLength {
                        var matchedIndices: [Int] = []
                        matchedIndices.reserveCapacity(maxSyllableKeyCount)
                        func appendEdges(from index: Int, code: Int, keyCount: Int) {
                                guard index < inputLength else { return }
                                if keyCount < maxSyllableKeyCount {
                                        for key in syllableKeyOptions[index] {
                                                let matchedCode = code * 100 + key.code
                                                guard syllableCodePrefixes.contains(matchedCode) else { continue }
                                                matchedIndices.append(index)
                                                if let syllable = lookup(by: matchedCode) {
                                                        let edge = AmbiguousSplitEdge(syllable: syllable, endIndex: index + 1, matchedIndices: matchedIndices)
                                                        edges[startIndex].append(edge)
                                                }
                                                appendEdges(from: index + 1, code: matchedCode, keyCount: keyCount + 1)
                                                matchedIndices.removeLast()
                                        }
                                }
                                if skippableIndices[index] {
                                        appendEdges(from: index + 1, code: code, keyCount: keyCount)
                                }
                        }
                        appendEdges(from: startIndex, code: 0, keyCount: 0)
                        edges[startIndex].sort(by: {
                                if $0.endIndex == $1.endIndex {
                                        return $0.syllable.aliasCode < $1.syllable.aliasCode
                                } else {
                                        return $0.endIndex < $1.endIndex
                                }
                        })
                }
                return edges
        }
        private static func scheme(at nodeIndex: Int, in nodes: [SplitNode]) -> Scheme {
                var syllables: Scheme = []
                syllables.reserveCapacity(nodes[nodeIndex].count)
                var currentIndex: Int? = nodeIndex
                while let index = currentIndex {
                        let node = nodes[index]
                        syllables.append(node.syllable)
                        currentIndex = node.previousIndex
                }
                syllables.reverse()
                return syllables
        }
        private static func scheme(at nodeIndex: Int, in nodes: [AmbiguousSplitNode]) -> Scheme {
                var syllables: Scheme = []
                syllables.reserveCapacity(nodes[nodeIndex].count)
                var currentIndex: Int? = nodeIndex
                while let index = currentIndex {
                        let node = nodes[index]
                        syllables.append(node.edge.syllable)
                        currentIndex = node.previousIndex
                }
                syllables.reverse()
                return syllables
        }
        private static func keys(at nodeIndex: Int, in nodes: [AmbiguousSplitNode], keySets: [Set<VirtualInputKey>]) -> [[VirtualInputKey]] {
                var currentIndex: Int? = nodeIndex
                var edges: [AmbiguousSplitEdge] = []
                edges.reserveCapacity(nodes[nodeIndex].count)
                while let index = currentIndex {
                        let node = nodes[index]
                        edges.append(node.edge)
                        currentIndex = node.previousIndex
                }
                edges.reverse()

                var matchedKeys: [Int: VirtualInputKey] = [:]
                matchedKeys.reserveCapacity(nodes[nodeIndex].length)
                for edge in edges {
                        for (index, key) in zip(edge.matchedIndices, edge.syllable.alias) {
                                matchedKeys[index] = key
                        }
                }
                let consumedEndIndex = edges.last?.endIndex ?? 0
                let choices: [[VirtualInputKey]] = keySets.indices.map({ index -> [VirtualInputKey] in
                        if let key = matchedKeys[index] {
                                return [key]
                        } else if index < consumedEndIndex {
                                return keySets[index].filter(\.isSyllableLetter.negative).sorted()
                        } else {
                                return keySets[index].sorted()
                        }
                })
                guard choices.allSatisfy(\.isNotEmpty) else { return [] }

                var items: [[VirtualInputKey]] = []
                var keys: [VirtualInputKey] = []
                keys.reserveCapacity(keySets.count)
                func appendKeys(at index: Int) {
                        guard index < choices.count else {
                                items.append(keys)
                                return
                        }
                        for key in choices[index] {
                                keys.append(key)
                                appendKeys(at: index + 1)
                                keys.removeLast()
                        }
                }
                appendKeys(at: 0)
                return items
        }
        private static func split(_ keys: [VirtualInputKey]) -> Segmentation {
                let inputLength = keys.count
                guard inputLength > 0 else { return [] }
                let edges = splitEdges(for: keys)
                guard (edges.first?.isNotEmpty ?? false) else { return [] }
                var nodes: [SplitNode] = []
                var frontier: [Int] = []
                for edge in edges[0] {
                        let node = SplitNode(syllable: edge.syllable, previousIndex: nil, length: edge.endIndex, count: 1)
                        nodes.append(node)
                        frontier.append(nodes.endIndex - 1)
                }
                while frontier.isNotEmpty {
                        var nextFrontier: [Int] = []
                        for nodeIndex in frontier {
                                let node = nodes[nodeIndex]
                                guard node.length < inputLength else { continue }
                                for edge in edges[node.length] {
                                        let nextNode = SplitNode(syllable: edge.syllable, previousIndex: nodeIndex, length: edge.endIndex, count: node.count + 1)
                                        nodes.append(nextNode)
                                        nextFrontier.append(nodes.endIndex - 1)
                                }
                        }
                        frontier = nextFrontier
                }
                return nodes.indices.compactMap({ nodeIndex -> (scheme: Scheme, length: Int, count: Int)? in
                        let node = nodes[nodeIndex]
                        let scheme = scheme(at: nodeIndex, in: nodes)
                        guard scheme.isValid else { return nil }
                        return (scheme, node.length, node.count)
                }).sorted(by: {
                        if $0.length == $1.length {
                                return $0.count < $1.count
                        } else {
                                return $0.length > $1.length
                        }
                }).map(\.scheme)
        }

        private static func ambiguousSplit(_ keySets: [Set<VirtualInputKey>]) -> (nodes: [AmbiguousSplitNode], nodeIndices: [Int]) {
                let inputLength = keySets.count
                guard inputLength > 0 else { return ([], []) }
                let edges = ambiguousSplitEdges(for: keySets)
                guard (edges.first?.isNotEmpty ?? false) else { return ([], []) }
                var nodes: [AmbiguousSplitNode] = []
                var frontier: [Int] = []
                for edge in edges[0] {
                        let node = AmbiguousSplitNode(edge: edge, previousIndex: nil, length: edge.syllable.alias.count, count: 1)
                        nodes.append(node)
                        frontier.append(nodes.endIndex - 1)
                }
                while frontier.isNotEmpty {
                        var nextFrontier: [Int] = []
                        for nodeIndex in frontier {
                                let node = nodes[nodeIndex]
                                guard node.edge.endIndex < inputLength else { continue }
                                for edge in edges[node.edge.endIndex] {
                                        let nextNode = AmbiguousSplitNode(edge: edge, previousIndex: nodeIndex, length: node.length + edge.syllable.alias.count, count: node.count + 1)
                                        nodes.append(nextNode)
                                        nextFrontier.append(nodes.endIndex - 1)
                                }
                        }
                        frontier = nextFrontier
                }
                let validNodeIndices: [(index: Int, length: Int, count: Int)] = nodes.indices.compactMap({ nodeIndex -> (index: Int, length: Int, count: Int)? in
                        let node = nodes[nodeIndex]
                        let scheme = scheme(at: nodeIndex, in: nodes)
                        guard scheme.isValid else { return nil }
                        return (nodeIndex, node.length, node.count)
                })
                let bestLength = validNodeIndices.map(\.length).max() ?? 0
                let bestNodeIndices = validNodeIndices.filter({ $0.length == bestLength }).sorted(by: {
                        if $0.count == $1.count {
                                return $0.index < $1.index
                        } else {
                                return $0.count < $1.count
                        }
                }).map(\.index)
                return (nodes, bestNodeIndices)
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
                        switch keys.conjoinedCode {
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
                var seenKeys: Set<[VirtualInputKey]> = []
                func appendItem(keys: [VirtualInputKey]) {
                        guard seenKeys.insert(keys).inserted else { return }
                        let segmentation = segment(keys)
                        let length = segmentation.first?.length ?? 0
                        guard length >= bestLength else { return }
                        if length > bestLength {
                                bestLength = length
                                items.removeAll(keepingCapacity: true)
                        }
                        items.append((keys, segmentation))
                }
                func appendEveryCombination() {
                        var keys: [VirtualInputKey] = []
                        keys.reserveCapacity(keySets.count)
                        func appendKeys(at index: Int) {
                                guard index < keySets.count else {
                                        appendItem(keys: keys)
                                        return
                                }
                                for key in keySets[index].sorted() {
                                        keys.append(key)
                                        appendKeys(at: index + 1)
                                        keys.removeLast()
                                }
                        }
                        appendKeys(at: 0)
                }

                let splitResult = ambiguousSplit(keySets)
                for nodeIndex in splitResult.nodeIndices {
                        let keyItems = keys(at: nodeIndex, in: splitResult.nodes, keySets: keySets)
                        keyItems.forEach({ appendItem(keys: $0) })
                }
                if keySets.count == 4 {
                        let mamiKeys: [VirtualInputKey] = [.letterM, .letterA, .letterM, .letterI]
                        if zip(keySets, mamiKeys).allSatisfy({ keySet, key in keySet.contains(key) }) {
                                appendItem(keys: mamiKeys)
                        }
                }
                guard items.isNotEmpty else {
                        appendEveryCombination()
                        return items
                }
                if bestLength == 0 {
                        appendEveryCombination()
                }
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
                return lookup(by: keys.conjoinedCode)?.originText
        }
}
