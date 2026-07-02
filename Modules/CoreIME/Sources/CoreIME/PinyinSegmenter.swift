import Foundation
import SQLite3
import CommonExtensions
import os.log

public struct PinyinSyllable: Hashable, Comparable, Sendable {

        let code: Int
        let keys: Array<VirtualInputKey>
        let text: String

        init(code: Int, text: String) {
                self.code = code
                self.keys = code.matchedInputKeys
                self.text = text
        }

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
                return map(\.keys.count).summation
        }
        public var mark: String {
                return map(\.text).joined(separator: String.space)
        }
}

public struct PinyinSegmenter {

        private static let logger = Logger(subsystem: "org.jyutping.Jyutping.CoreIME", category: "PinyinSegmenter")
        static func prepare() {
                if pinyinSyllableMap.isEmpty {
                        logger.warning("PinyinSyllable Dictionary is Empty")
                }
        }
        private static let pinyinSyllableMap: Dictionary<Int, PinyinSyllable> = {
                let command: String = "SELECT code, syllable FROM pinyin_syllable_table;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(Engine.database, command, -1, &statement, nil) == SQLITE_OK else { return [:] }
                var dict: [Int: PinyinSyllable] = [:]
                dict.reserveCapacity(500)
                while sqlite3_step(statement) == SQLITE_ROW {
                        let code = Int(sqlite3_column_int64(statement, 0))
                        guard let syllable = sqlite3_column_text(statement, 1) else { continue }
                        dict[code] = PinyinSyllable(code: code, text: String(cString: syllable))
                }
                return dict
        }()
        private static func lookup(by code: Int) -> PinyinSyllable? {
                return pinyinSyllableMap[code]
        }

        private static let maxSyllableKeyCount: Int = 6

        private struct SplitEdge {
                let syllable: PinyinSyllable
                let endIndex: Int
        }
        private struct SplitNode {
                let syllable: PinyinSyllable
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
        private static func scheme(at nodeIndex: Int, in nodes: [SplitNode]) -> PinyinScheme {
                var syllables: PinyinScheme = []
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
        private static func split(_ keys: [VirtualInputKey]) -> PinyinSegmentation {
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
                return nodes.indices.map({ nodeIndex -> (scheme: PinyinScheme, length: Int, count: Int) in
                        let node = nodes[nodeIndex]
                        return (scheme(at: nodeIndex, in: nodes), node.length, node.count)
                }).sorted(by: {
                        if $0.length == $1.length {
                                return $0.count < $1.count
                        } else {
                                return $0.length > $1.length
                        }
                }).map(\.scheme)
        }
        public static func segment<T: RandomAccessCollection<VirtualInputKey>>(_ keys: T) -> PinyinSegmentation {
                return split(keys.filter(\.isLetter))
        }
}
