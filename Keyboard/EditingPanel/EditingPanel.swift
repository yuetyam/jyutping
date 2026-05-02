import SwiftUI

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct GlassEditingPanel: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                let edgeKeyWidth: CGFloat = min(context.keyboardWidth / 4.0, 128)
                HStack(spacing: 0) {
                        VStack(spacing: 0) {
                                EditingPanelGlassCopyKey().frame(maxHeight: .infinity)
                                EditingPanelGlassCutKey().frame(maxHeight: .infinity)
                                EditingPanelGlassClearKey().frame(maxHeight: .infinity)
                                EditingPanelGlassConversionKey().frame(maxHeight: .infinity)
                        }
                        .frame(width: edgeKeyWidth)
                        VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                        EditingPanelGlassClearClipboardKey().frame(maxWidth: .infinity)
                                        EditingPanelGlassPasteKey().frame(maxWidth: .infinity)
                                }
                                .frame(maxHeight: .infinity)
                                HStack(spacing: 0) {
                                        EditingPanelGlassMoveBackwardKey().frame(maxWidth: .infinity)
                                        EditingPanelGlassMoveForwardKey().frame(maxWidth: .infinity)
                                }
                                .frame(maxHeight: .infinity)
                                HStack(spacing: 0) {
                                        EditingPanelGlassJump2HeadKey().frame(maxWidth: .infinity)
                                        EditingPanelGlassJump2TailKey().frame(maxWidth: .infinity)
                                }
                                .frame(maxHeight: .infinity)
                                EditingPanelSpaceKey().frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        VStack(spacing: 0) {
                                EditingPanelGlassBackKey().frame(maxHeight: .infinity)
                                EditingPanelGlassBackspaceKey().frame(maxHeight: .infinity)
                                EditingPanelGlassForwardDeleteKey().frame(maxHeight: .infinity)
                                EditingPanelReturnKey().frame(maxHeight: .infinity)
                        }
                        .frame(width: edgeKeyWidth)
                }
        }
}

@available(iOS, introduced: 16.0, deprecated: 26.0, message: "Use GlassEditingPanel instead")
@available(iOSApplicationExtension, introduced: 16.0, deprecated: 26.0, message: "Use GlassEditingPanel instead")
struct EditingPanel: View {
        @EnvironmentObject private var context: KeyboardViewController
        var body: some View {
                let edgeKeyWidth: CGFloat = min(context.keyboardWidth / 4.0, 128)
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
                                if #available(iOSApplicationExtension 26.0, *) {
                                        EditingPanelGlassBackKey().frame(maxHeight: .infinity)
                                } else {
                                        EditingPanelBackKey().frame(maxHeight: .infinity)
                                }
                                EditingPanelBackspaceKey().frame(maxHeight: .infinity)
                                EditingPanelForwardDeleteKey().frame(maxHeight: .infinity)
                                EditingPanelReturnKey().frame(maxHeight: .infinity)
                        }
                        .frame(width: edgeKeyWidth)
                }
        }
}
