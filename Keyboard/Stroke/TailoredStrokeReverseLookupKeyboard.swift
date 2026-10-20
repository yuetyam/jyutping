import SwiftUI
import CommonExtensions
import CoreIME

/// A tailored stroke reverse-lookup keyboard with five stroke keys, a wildcard, and an optional number row.
///
/// Arranges the stroke keys in two rows of three, with disabled placeholders preserving the surrounding layout.
struct TailoredStrokeReverseLookupKeyboard: View {

        /// Renders the candidate bar, optional number row, stroke grid, space key, and trailing backspace and return keys.
        var body: some View {
                VStack(spacing: 0) {
                        CandidateBar()
                        if Options.needsNumberRow {
                                CantoneseNumberRow()
                        }
                        HStack(spacing: 0) {
                                VStack(spacing: 0) {
                                        HStack(spacing: 0) {
                                                PlaceholderView(widthCoefficient: PresetConstant.tailoredActionKeyWidthCoefficient, heightCoefficient: 3).disabled(true)
                                                VStack(spacing: 0) {
                                                        HStack(spacing: 0) {
                                                                TailoredStrokeInputKey(.horizontal)
                                                                TailoredStrokeInputKey(.vertical)
                                                                TailoredStrokeInputKey(.leftFalling)
                                                        }
                                                        HStack(spacing: 0) {
                                                                TailoredStrokeInputKey(.rightFalling)
                                                                TailoredStrokeInputKey(.turning)
                                                                TailoredStrokeInputKey(.wildcard)
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
                                                TailoredSpaceKey()
                                        }
                                }
                                VStack(spacing: 0) {
                                        TailoredBackspaceKey()
                                        PlaceholderView(widthCoefficient: PresetConstant.tailoredActionKeyWidthCoefficient).disabled(true)
                                        TailoredEnterKey()
                                }
                        }
                }
        }
}

/// A decorative material key shape used to fill unused positions in the tailored stroke layout.
///
/// Call sites disable interaction so the placeholder occupies space without handling input.
private struct PlaceholderView: View {

        /// Keyboard dimensions used to size the placeholder.
        @EnvironmentObject private var context: KeyboardViewController

        /// Creates a placeholder sized relative to the keyboard's nine-key width and height units.
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

        /// Renders a rounded material shape with the same inset and shadow as the surrounding stroke keys.
        var body: some View {
                RoundedRectangle(cornerRadius: PresetConstant.largeKeyCornerRadius)
                        .fill(Material.regular)
                        .shadow(color: .shadowGray, radius: 0.5, y: 0.5)
                        .padding(3)
                        .frame(width: context.nineKeyWidthUnit * widthCoefficient, height: context.heightUnit * heightCoefficient)
        }
}
