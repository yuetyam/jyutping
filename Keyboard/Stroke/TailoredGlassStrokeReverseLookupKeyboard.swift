import SwiftUI
import CoreIME
import CommonExtensions

/// A tailored stroke reverse-lookup keyboard with glass-styled keys and an optional number row.
///
/// Arranges five stroke keys and a wildcard in two rows of three, with disabled placeholders preserving the surrounding layout.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct TailoredGlassStrokeReverseLookupKeyboard: View {

        /// Renders the candidate bar, optional glass number row, stroke grid, space key, and trailing backspace and return keys.
        var body: some View {
                VStack(spacing: 0) {
                        CandidateBar()
                        if Options.needsNumberRow {
                                CantoneseGlassNumberRow()
                        }
                        HStack(spacing: 0) {
                                VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                                PlaceholderView(widthCoefficient: PresetConstant.tailoredActionKeyWidthCoefficient, heightCoefficient: 3).disabled(true)
                                                VStack(spacing: 0) {
                                                        HStack(spacing: 0) {
                                                                TailoredGlassStrokeInputKey(.horizontal)
                                                                TailoredGlassStrokeInputKey(.vertical)
                                                                TailoredGlassStrokeInputKey(.leftFalling)
                                                        }
                                                        HStack(spacing: 0) {
                                                                TailoredGlassStrokeInputKey(.rightFalling)
                                                                TailoredGlassStrokeInputKey(.turning)
                                                                TailoredGlassStrokeInputKey(.wildcard)
                                                        }
                                                        HStack(spacing: 0) {
                                                                PlaceholderView().disabled(true)
                                                                PlaceholderView().disabled(true)
                                                                PlaceholderView().disabled(true)
                                                        }
                                                }
                                        }
                                        HStack(spacing: 0) {
                                                PlaceholderView(widthCoefficient: PresetConstant.tailoredActionKeyWidthCoefficient).disabled(true)
                                                GlassTailoredSpaceKey()
                                        }
                                }
                                VStack(spacing: 0) {
                                        GlassTailoredBackspaceKey()
                                        PlaceholderView(widthCoefficient: PresetConstant.tailoredActionKeyWidthCoefficient).disabled(true)
                                        TailoredReturnKey()
                                }
                        }
                }
        }
}

/// A decorative glass key shape used to fill unused positions in the tailored stroke layout.
///
/// Call sites disable interaction so the placeholder occupies space without handling input.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct PlaceholderView: View {

        /// Keyboard dimensions used to size the placeholder.
        @EnvironmentObject private var context: KeyboardViewController

        /// Creates a glass placeholder sized relative to the keyboard's nine-key width and height units.
        ///
        /// - Parameters:
        ///   - widthCoefficient: Width as a multiple of the nine-key width unit; defaults to the stroke key width of 1.06.
        ///   - heightCoefficient: Height as a multiple of the keyboard height unit; defaults to one row.
        init(widthCoefficient: CGFloat = PresetConstant.tailoredInputKeyWidthCoefficient, heightCoefficient: CGFloat = 1) {
                self.widthCoefficient = widthCoefficient
                self.heightCoefficient = heightCoefficient
        }

        /// Width as a multiple of the keyboard's nine-key width unit.
        private let widthCoefficient: CGFloat

        /// Height as a multiple of the keyboard's height unit.
        private let heightCoefficient: CGFloat

        /// Renders a clear glass shape with the same corner radius and inset as the surrounding stroke keys.
        var body: some View {
                Color.interactiveClear
                        .glassEffect(.clear, in: .rect(cornerRadius: PresetConstant.largeKeyCornerRadius))
                        .padding(3)
                        .frame(width: context.nineKeyWidthUnit * widthCoefficient, height: context.heightUnit * heightCoefficient)
        }
}
