import SwiftUI

/// Shared bottom key row for (compact) Cantonese keyboard views.
struct CantoneseBottomKeyRow: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                switch (context.keyboardInterface.isPadFloating, context.needsGlobeKey) {
                case (true, true):
                        HStack(spacing: 0) {
                                GlobeKey()
                                TransformKey(destination: context.preferredNumericForm, coefficient: 1.5)
                                LeftKey()
                                SpaceKey()
                                RightKey()
                                ReturnKey()
                        }
                case (true, false):
                        HStack(spacing: 0) {
                                TransformKey(destination: .numeric, coefficient: 2)
                                LeftKey()
                                SpaceKey()
                                RightKey()
                                ReturnKey()
                        }
                case (false, true):
                        HStack(spacing: 0) {
                                TransformKey(destination: context.preferredNumericForm, coefficient: 1.5)
                                GlobeKey()
                                LeftKey()
                                SpaceKey()
                                RightKey()
                                ReturnKey()
                        }
                case (false, false):
                        HStack(spacing: 0) {
                                TransformKey(destination: context.preferredNumericForm, coefficient: 2)
                                LeftKey()
                                SpaceKey()
                                RightKey()
                                ReturnKey()
                        }
                }
        }
}
