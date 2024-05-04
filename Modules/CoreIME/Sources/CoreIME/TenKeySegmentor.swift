import Foundation
import SQLite3

extension Segmentor {
        public static func segment(combos: [Combo]) -> Segmentation {
                switch combos.count {
                case 0:
                        return []
                case 1:
                        let code: Int = combos.first?.rawValue ?? 0
                        let tokens = tenKeyMatch(tenKeyCode: code)
                        return [tokens]
                default:
                        return split(combos: combos)
                }
        }
        private static func split(combos: [Combo]) -> Segmentation {
                let leadingTokens = splitLeading(combos: combos)
                guard !(leadingTokens.isEmpty) else { return [] }
                let textCount = combos.count
                var segmentation: Segmentation = leadingTokens.map({ [$0] })
                var previousSubelementCount = segmentation.subelementCount
                var shouldContinue: Bool = true
                while shouldContinue {
                        for scheme in segmentation {
                                let schemeLength = scheme.length
                                guard schemeLength < textCount else { continue }
                                let tailCombos = combos.dropFirst(schemeLength)
                                let tailTokens = splitLeading(combos: tailCombos)
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
        private static func splitLeading<T: RandomAccessCollection<Combo>>(combos: T)-> [SegmentToken] {
                let maxLength: Int = min(combos.count, 6)
                guard maxLength > 0 else { return [] }
                let sequences = (1...maxLength).reversed().map({ combos.prefix($0) })
                let matches = sequences.map { sequence -> [SegmentToken] in
                        let code: Int = sequence.map(\.rawValue).tenKeyCombined()
                        return tenKeyMatch(tenKeyCode: code)
                }
                return matches.flatMap({ $0 }).uniqued()
        }
        private static func tenKeyMatch(tenKeyCode: Int) -> [SegmentToken] {
                var tokens: [SegmentToken] = []
                let command: String = "SELECT token, origin FROM syllabletable WHERE tenkey = \(tenKeyCode);"
                var pointer: OpaquePointer? = nil
                defer { sqlite3_finalize(pointer) }
                guard sqlite3_prepare_v2(database, command, -1, &pointer, nil) == SQLITE_OK else { return tokens }
                while sqlite3_step(pointer) == SQLITE_ROW {
                        let token: String = String(cString: sqlite3_column_text(pointer, 0))
                        let origin: String = String(cString: sqlite3_column_text(pointer, 1))
                        let instance = SegmentToken(text: token, origin: origin)
                        tokens.append(instance)
                }
                return tokens
        }
}
