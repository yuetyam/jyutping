import SwiftUI

/// Bottom row for the glass ABC keyboard.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassABCBottomKeyRow: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                switch (context.keyboardInterface.isPadFloating, context.needsGlobeKey) {
                case (true, true):
                        HStack(spacing: 0) {
                                GlassGlobeKey()
                                GlassTransformKey(context.preferredNumericForm, coefficient: 1.5)
                                GlassABCLeftKey()
                                SpaceKey()
                                GlassABCRightKey()
                                GlassEnterKey()
                        }
                case (true, false):
                        HStack(spacing: 0) {
                                GlassTransformKey(.numeric)
                                GlassABCLeftKey()
                                SpaceKey()
                                GlassABCRightKey()
                                GlassEnterKey()
                        }
                case (false, true):
                        HStack(spacing: 0) {
                                GlassTransformKey(context.preferredNumericForm, coefficient: 1.5)
                                GlassGlobeKey()
                                GlassABCLeftKey()
                                SpaceKey()
                                GlassABCRightKey()
                                GlassEnterKey()
                        }
                case (false, false):
                        HStack(spacing: 0) {
                                GlassTransformKey(context.preferredNumericForm)
                                GlassABCLeftKey()
                                SpaceKey()
                                GlassABCRightKey()
                                GlassEnterKey()
                        }
                }
        }
}

/// Glass-style ABC comma key with vertical pulls and long-press punctuation alternatives.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassABCLeftKey: View {
        var body: some View {
                let primaryExtras: [KeyElement.Extra] = Options.inputKeyStyle.isSymbolApplied ? [.init("!", alignment: .topTrailing)] : []
                GlassEnhancedInputKey(
                        side: .leading,
                        unit: KeyUnit(
                                primary: KeyElement(",", extras: primaryExtras),
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

/// Glass-style ABC period key with vertical pulls and long-press punctuation alternatives.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
private struct GlassABCRightKey: View {
        var body: some View {
                let primaryExtras: [KeyElement.Extra] = Options.inputKeyStyle.isSymbolApplied ? [.init("?", alignment: .topTrailing)] : []
                GlassEnhancedInputKey(
                        side: .trailing,
                        unit: KeyUnit(
                                primary: KeyElement(".", extras: primaryExtras),
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
