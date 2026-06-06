import SwiftUI
import CommonExtensions

struct MotherBoard: View {
        @EnvironmentObject private var context: InputContext
        var body: some View {
                ZStack(alignment: context.quadrant.alignment) {
                        Color.clear
                        VStack(alignment: .leading, spacing: -12) {
                                switch context.quadrant {
                                case .upperRight, .upperLeft:
                                        if context.isReverseLookup.negative {
                                                IndicatorBar()
                                        }
                                case .bottomLeft, .bottomRight:
                                        if context.isReverseLookup {
                                                IndicatorBar()
                                        }
                                }
                                switch context.inputForm {
                                case .options:
                                        OptionsView()
                                case .cantonese where context.displayCandidates.isNotEmpty:
                                        CandidateBoard()
                                default:
                                        Color.clear
                                }
                                switch context.quadrant {
                                case .upperRight, .upperLeft:
                                        if context.isReverseLookup {
                                                IndicatorBar()
                                        }
                                case .bottomLeft, .bottomRight:
                                        if context.isReverseLookup.negative {
                                                IndicatorBar()
                                        }
                                }
                        }
                        .fixedSize()
                        .onGeometryChange(for: CGSize.self) { proxy in
                                proxy.size
                        } action: { newSize in
                                guard context.quadrant.isNegativeHorizontal else { return }
                                NotificationCenter.default.post(name: .contentSize, object: nil, userInfo: [NotificationKey.contentSize : newSize])
                        }
                }
        }
}
