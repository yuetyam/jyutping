import SwiftUI
import CommonExtensions

struct MotherBoard: View {
        @EnvironmentObject private var context: InputContext
        private let pageCornerRadius: CGFloat = CGFloat(AppSettings.pageCornerRadius)
        private let contentInsets: CGFloat = CGFloat(AppSettings.contentInsets)
        private let verticalSpacing: CGFloat = -((PresetConstant.contentWindowGap * 2) - 4)
        var body: some View {
                ZStack(alignment: context.quadrant.alignment) {
                        Color.clear
                        VStack(alignment: .leading, spacing: verticalSpacing) {
                                if #available(macOS 26.0, *) {
                                        switch context.quadrant {
                                        case .upperRight, .upperLeft:
                                                if context.isReverseLookup.negative {
                                                        GlassIndicatorBar()
                                                }
                                        case .bottomLeft, .bottomRight:
                                                if context.isReverseLookup {
                                                        GlassIndicatorBar()
                                                }
                                        }
                                        switch context.inputForm {
                                        case .options:
                                                ZStack {
                                                        Color.clear.glassEffect(.regular, in: RoundedRectangle(cornerRadius: pageCornerRadius))
                                                        OptionsView()
                                                                .padding(contentInsets)
                                                                .background(Color.clear, in: RoundedRectangle(cornerRadius: pageCornerRadius))
                                                }
                                                .padding(PresetConstant.contentWindowGap)
                                                .fixedSize()
                                        case .cantonese where context.displayCandidates.isNotEmpty:
                                                ZStack {
                                                        Color.clear.glassEffect(.regular, in: RoundedRectangle(cornerRadius: pageCornerRadius))
                                                        CandidateBoard()
                                                                .padding(contentInsets)
                                                                .background(Color.clear, in: RoundedRectangle(cornerRadius: pageCornerRadius))
                                                }
                                                .padding(PresetConstant.contentWindowGap)
                                                .fixedSize()
                                        default:
                                                Color.clear
                                        }
                                        switch context.quadrant {
                                        case .upperRight, .upperLeft:
                                                if context.isReverseLookup {
                                                        GlassIndicatorBar()
                                                }
                                        case .bottomLeft, .bottomRight:
                                                if context.isReverseLookup.negative {
                                                        GlassIndicatorBar()
                                                }
                                        }
                                } else {
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
                                                        .padding(contentInsets)
                                                        .background(VisualEffectView())
                                                        .clipShape(RoundedRectangle(cornerRadius: pageCornerRadius))
                                                        .shadow(radius: 2)
                                                        .padding(PresetConstant.contentWindowGap)
                                                        .fixedSize()
                                        case .cantonese where context.displayCandidates.isNotEmpty:
                                                CandidateBoard()
                                                        .padding(contentInsets)
                                                        .background(VisualEffectView())
                                                        .clipShape(RoundedRectangle(cornerRadius: pageCornerRadius))
                                                        .shadow(radius: 2)
                                                        .padding(PresetConstant.contentWindowGap)
                                                        .fixedSize()
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
