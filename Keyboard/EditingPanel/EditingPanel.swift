import SwiftUI

struct EditingPanel: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                let edgeKeyWidth: CGFloat = {
                        let widthUnit: CGFloat = context.keyboardWidth / 4.0
                        return min(widthUnit, 128)
                }()
                HStack(spacing: 0) {
                        VStack(spacing: 0) {
                                EditingPanelCopyKey().frame(maxHeight: .infinity)
                                EditingPanelCutKey().frame(maxHeight: .infinity)
                                EditingPanelClearKey().frame(maxHeight: .infinity)
                                EditingPanelConversionKey().frame(maxHeight: .infinity)
                        }
                        .frame(width: edgeKeyWidth)
                        VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                        EditingPanelClearClipboardKey().frame(maxWidth: .infinity)
                                        EditingPanelPasteKey().frame(maxWidth: .infinity)
                                }
                                .frame(maxHeight: .infinity)
                                HStack(spacing: 0) {
                                        EditingPanelMoveBackwardKey().frame(maxWidth: .infinity)
                                        EditingPanelMoveForwardKey().frame(maxWidth: .infinity)
                                }
                                .frame(maxHeight: .infinity)
                                HStack(spacing: 0) {
                                        EditingPanelJump2HeadKey().frame(maxWidth: .infinity)
                                        EditingPanelJump2TailKey().frame(maxWidth: .infinity)
                                }
                                .frame(maxHeight: .infinity)
                                EditingPanelSpaceKey().frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        VStack(spacing: 0) {
                                EditingPanelBackKey().frame(maxHeight: .infinity)
                                EditingPanelBackspaceKey().frame(maxHeight: .infinity)
                                EditingPanelForwardDeleteKey().frame(maxHeight: .infinity)
                                EditingPanelReturnKey().frame(maxHeight: .infinity)
                        }
                        .frame(width: edgeKeyWidth)
                }
        }
}
