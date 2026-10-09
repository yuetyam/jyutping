import SwiftUI
import CommonExtensions

/// Shared bottom row for the glass Cantonese numeric and symbolic keyboards.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassCantoneseSymbolBottomKeyRow: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                switch (context.keyboardInterface.isPadFloating, context.needsGlobeKey) {
                case (true, true):
                        HStack(spacing: 0) {
                                GlassGlobeKey()
                                GlassTransformKey(.primary, coefficient: 1.5)
                                GlassCantoneseSymbolCommaKey()
                                SpaceKey()
                                GlassCantoneseSymbolPeriodKey()
                                GlassEnterKey()
                        }
                case (true, false):
                        HStack(spacing: 0) {
                                GlassTransformKey(.primary, coefficient: 2)
                                GlassCantoneseSymbolCommaKey()
                                SpaceKey()
                                GlassCantoneseSymbolPeriodKey()
                                GlassEnterKey()
                        }
                case (false, true):
                        HStack(spacing: 0) {
                                GlassTransformKey(.primary, coefficient: 1.5)
                                GlassGlobeKey()
                                GlassCantoneseSymbolCommaKey()
                                SpaceKey()
                                GlassCantoneseSymbolPeriodKey()
                                GlassEnterKey()
                        }
                case (false, false):
                        HStack(spacing: 0) {
                                GlassTransformKey(.primary, coefficient: 2)
                                GlassCantoneseSymbolCommaKey()
                                SpaceKey()
                                GlassCantoneseSymbolPeriodKey()
                                GlassEnterKey()
                        }
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassCantoneseSymbolCommaKey: View {
        var body: some View {
                GlassEnhancedInputKey(
                        side: .leading,
                        unit: KeyUnit(
                                primary: KeyElement(String.cantoneseComma),
                                members: [
                                        KeyElement(String.cantoneseComma),
                                        KeyElement("！"),
                                        KeyElement("？"),
                                        KeyElement("、")
                                ]
                        )
                )
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassCantoneseSymbolPeriodKey: View {
        var body: some View {
                GlassEnhancedInputKey(
                        side: .trailing,
                        unit: KeyUnit(
                                primary: KeyElement(String.cantonesePeriod),
                                members: [
                                        KeyElement(String.cantonesePeriod),
                                        KeyElement("？"),
                                        KeyElement("！"),
                                        KeyElement("…")
                                ]
                        )
                )
        }
}
