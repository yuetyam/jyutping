import SwiftUI

/// Shared glass-style bottom key row for (compact) Cantonese keyboard views.
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassCantoneseBottomKeyRow: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                switch (context.keyboardInterface.isPadFloating, context.needsGlobeKey) {
                case (true, true):
                        HStack(spacing: 0) {
                                GlassGlobeKey()
                                GlassTransformKey(context.preferredNumericForm, coefficient: 1.5)
                                GlassLeftKey()
                                SpaceKey()
                                GlassRightKey()
                                ReturnKey()
                        }
                case (true, false):
                        HStack(spacing: 0) {
                                GlassTransformKey(.numeric)
                                GlassLeftKey()
                                SpaceKey()
                                GlassRightKey()
                                ReturnKey()
                        }
                case (false, true):
                        HStack(spacing: 0) {
                                GlassTransformKey(context.preferredNumericForm, coefficient: 1.5)
                                GlassGlobeKey()
                                GlassLeftKey()
                                SpaceKey()
                                GlassRightKey()
                                ReturnKey()
                        }
                case (false, false):
                        HStack(spacing: 0) {
                                GlassTransformKey(context.preferredNumericForm)
                                GlassLeftKey()
                                SpaceKey()
                                GlassRightKey()
                                ReturnKey()
                        }
                }
        }
}
