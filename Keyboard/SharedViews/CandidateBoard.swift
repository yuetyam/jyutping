import SwiftUI
import CoreIME
import CommonExtensions

extension Candidate {
        var width: CGFloat {
                let textCount: Int = text.count
                switch type {
                case .cantonese:
                        return CGFloat(textCount * 20 + 32)
                case _ where textCount == 1:
                        return 48
                case .text:
                        let letterCount: Int = text.count(where: \.isBasicLatinLetter)
                        let computed: Int = (letterCount * 12) + ((textCount - letterCount) * 28)
                        return CGFloat(computed)
                default:
                        return CGFloat(textCount * 12)
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
                        if #available(iOSApplicationExtension 18.0, *) {
                                CandidateBoardScrollViewIOS18()
                        } else if #available(iOSApplicationExtension 17.0, *) {
                                CandidateBoardScrollViewIOS17()
                        } else {
                                CandidateBoardScrollView()
                        }
                        Button {
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.updateKeyboardForm(to: context.previousKeyboardForm)
                        } label: {
                                ZStack {
                                        Color.interactiveClear
                                        if #available(iOSApplicationExtension 26.0, *) {
                                                Circle()
                                                        #if canImport(FoundationModels)
                                                        .glassEffect(.clear)
                                                        #else
                                                        .fill(Material.ultraThin)
                                                        #endif
                                        } else {
                                                Circle()
                                                        .fill(Material.ultraThin)
                                                        .padding(.top, 2)
                                                        .padding(.trailing, 2)
                                        }
                                        Image.chevronUp
                                                .resizable()
                                                .scaledToFit()
                                                .padding(12)
                                }
                                .frame(width: PresetConstant.collapseWidth, height: PresetConstant.collapseHeight)
                        }
                        .buttonStyle(.plain)
                }
        }
}
