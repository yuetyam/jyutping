import SwiftUI
import CoreIME
import CommonExtensions

extension Candidate {
        var width: CGFloat {
                let textCount: Int = text.count
                switch lexicon.type {
                case .cantonese:
                        return CGFloat(textCount * 20 + 32)
                case _ where textCount == 1:
                        return 50
                case .text:
                        let letterCount: Int = text.count(where: \.isBasicLatinLetter)
                        let computed: Int = (letterCount * 14) + ((textCount - letterCount) * 28)
                        return CGFloat(max(56, computed))
                default:
                        return CGFloat(max(56, textCount * 14))
                }
        }
}

struct CandidateBoardElement: Hashable, Identifiable {
        let identifier: Int
        let candidate: Candidate
        var id: Int { identifier }
        static let minIdentifier: Int = 5000
}
struct CandidateBoardRow: Hashable, Identifiable {
        let identifier: Int
        let elements: [CandidateBoardElement]
        var id: Int { identifier }
        static let minIdentifier: Int = 1000
}

extension Array where Element == Candidate {
        func boardRows(keyboardWidth: CGFloat) -> [CandidateBoardRow] {
                var rows: [CandidateBoardRow] = []
                var cache: [CandidateBoardElement] = []
                var rowID: Int = CandidateBoardRow.minIdentifier
                var rowWidth: CGFloat = 0
                for index in indices {
                        let itemId: Int = index + CandidateBoardElement.minIdentifier
                        let candidate = self[index]
                        let item = CandidateBoardElement(identifier: itemId, candidate: candidate)
                        let isFirstRow: Bool = rows.isEmpty
                        let maxWidth: CGFloat = isFirstRow ? (keyboardWidth - PresetConstant.collapseWidth) : keyboardWidth
                        let length: CGFloat = candidate.width
                        if rowWidth < (maxWidth - length) {
                                cache.append(item)
                                rowWidth += length
                        } else {
                                let row = CandidateBoardRow(identifier: rowID, elements: cache)
                                rows.append(row)
                                cache = [item]
                                rowID += 1
                                rowWidth = length
                        }
                }
                let lastRow = CandidateBoardRow(identifier: rowID, elements: cache)
                rows.append(lastRow)
                return rows
        }
}

struct CandidateBoard: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                ZStack(alignment: .topTrailing) {
                        if #available(iOSApplicationExtension 26.0, *) {
                                CandidateBoardScrollView().scrollEdgeEffectHidden()
                        } else if #available(iOSApplicationExtension 18.0, *) {
                                CandidateBoardScrollView()
                        } else {
                                CandidateBoardScrollViewIOS17()
                        }
                        BackButton()
                }
        }
}

private struct BackButton: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                Button(action: back) {
                        if #available(iOS 26.0, *), context.appearanceStyle.isGlass {
                                ZStack {
                                        Color.interactiveClear
                                        Image.chevronUp
                                                .resizable()
                                                .scaledToFit()
                                                .padding(11)
                                }
                                .glassEffect(.clear, in: .circle)
                                .frame(width: PresetConstant.buttonLength, height: PresetConstant.buttonLength)
                        } else {
                                ZStack {
                                        Color.interactiveClear
                                        Circle().fill(Material.thin)
                                        Image.chevronUp
                                                .resizable()
                                                .scaledToFit()
                                                .padding(11)
                                }
                                .frame(width: PresetConstant.buttonLength, height: PresetConstant.buttonLength)
                        }
                }
                .buttonStyle(.plain)
                .padding(2)
                .padding(.top, context.keyboardInterface.isCompact ? 0 : 2)
        }

        private func back() {
                context.performAudioFeedback(.modify)
                context.triggerHapticFeedback()
                context.routeBackKeyboardForm(from: .candidateBoard)
        }
}
