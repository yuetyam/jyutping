import SwiftUI

/// Shared bottom row for the glass ABC numeric and symbolic keyboards.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassABCSymbolBottomKeyRow: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                switch (context.keyboardInterface.isPadFloating, context.needsGlobeKey) {
                case (true, true):
                        HStack(spacing: 0) {
                                GlassGlobeKey()
                                GlassTransformKey(.primary, coefficient: 1.5)
                                GlassABCSymbolCommaKey()
                                SpaceKey()
                                GlassABCSymbolPeriodKey()
                                GlassEnterKey()
                        }
                case (true, false):
                        HStack(spacing: 0) {
                                GlassTransformKey(.primary)
                                GlassABCSymbolCommaKey()
                                SpaceKey()
                                GlassABCSymbolPeriodKey()
                                GlassEnterKey()
                        }
                case (false, true):
                        HStack(spacing: 0) {
                                GlassTransformKey(.primary, coefficient: 1.5)
                                GlassGlobeKey()
                                GlassABCSymbolCommaKey()
                                SpaceKey()
                                GlassABCSymbolPeriodKey()
                                GlassEnterKey()
                        }
                case (false, false):
                        HStack(spacing: 0) {
                                GlassTransformKey(.primary)
                                GlassABCSymbolCommaKey()
                                SpaceKey()
                                GlassABCSymbolPeriodKey()
                                GlassEnterKey()
                        }
                }
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassABCSymbolCommaKey: View {
        var body: some View {
                GlassEnhancedInputKey(
                        side: .leading,
                        unit: KeyUnit(
                                primary: KeyElement(","),
                                members: [
                                        KeyElement(","),
                                        KeyElement("!"),
                                        KeyElement("?"),
                                        KeyElement(";")
                                ]
                        )
                )
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassABCSymbolPeriodKey: View {
        var body: some View {
                GlassEnhancedInputKey(
                        side: .trailing,
                        unit: KeyUnit(
                                primary: KeyElement("."),
                                members: [
                                        KeyElement("."),
                                        KeyElement("?"),
                                        KeyElement("!"),
                                        KeyElement("…")
                                ]
                        )
                )
        }
}
