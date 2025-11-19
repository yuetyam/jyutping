import SwiftUI
import CoreIME

struct ToolBar: View {

        @EnvironmentObject private var context: KeyboardViewController

        private let buttonWidth: CGFloat = 48
        private let buttonHeight: CGFloat = PresetConstant.toolBarHeight

        var body: some View {
                HStack(spacing: 0) {
                        ToolBarButton(
                                imageName: "gear",
                                width: buttonWidth,
                                height: buttonHeight,
                                insets: EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
                        ) {
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.updateKeyboardForm(to: .settings)
                        }

                        Spacer()
                        Button {
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.updateKeyboardForm(to: .emojiBoard)
                        } label: {
                                ZStack {
                                        Color.interactiveClear
                                        Image.smiley
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                }
                        }
                        .buttonStyle(.plain)
                        .frame(width: buttonWidth, height: buttonHeight)

                        Spacer()
                        ToolBarButton(
                                imageName: "hand.draw",
                                width: 50,
                                height: buttonHeight,
                                insets: EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0)
                        ) {
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                        }

                        Spacer()
                        Button {
                                AudioFeedback.modified()
                                context.triggerSelectionHapticFeedback()
                                context.toggleInputMethodMode()
                        } label: {
                                ZStack {
                                        Color.interactiveClear
                                        if #available(iOSApplicationExtension 26.0, *) {
                                                InputModeSwitch(isCantoneseMode: context.inputMethodMode.isCantonese, isMutilatedMode: context.characterStandard.isMutilated)
                                        } else {
                                                LegacyInputModeSwitch(isCantoneseMode: context.inputMethodMode.isCantonese, isMutilatedMode: context.characterStandard.isMutilated)
                                        }
                                }
                        }
                        .buttonStyle(.plain)
                        .frame(width: 64, height: buttonHeight)

                        Spacer()
                        ToolBarButton(
                                imageName: "arrow.left.and.line.vertical.and.arrow.right",
                                width: buttonWidth,
                                height: buttonHeight,
                                insets: EdgeInsets(top: 19, leading: 0, bottom: 19, trailing: 0)
                        ) {
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.updateKeyboardForm(to: .editingPanel)
                        }

                        Spacer()
                        Button {
                                AudioFeedback.modified()
                                context.triggerSelectionHapticFeedback()
                                context.toggleCharacterScriptVariant()
                        } label: {
                                ZStack {
                                        Color.interactiveClear
                                        if #available(iOSApplicationExtension 26.0, *) {
                                                CharacterSetSwitch(isMutilatedMode: context.characterStandard.isMutilated)
                                        } else {
                                                LegacyCharacterSetSwitch(isMutilatedMode: context.characterStandard.isMutilated)
                                        }
                                }
                        }
                        .buttonStyle(.plain)
                        .frame(width: 50, height: buttonHeight)

                        Spacer()
                        ToolBarButton(
                                imageName: "keyboard.chevron.compact.down",
                                width: buttonWidth,
                                height: buttonHeight,
                                insets: EdgeInsets(top: 18, leading: 0, bottom: 18, trailing: 0)
                        ) {
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.dismissKeyboard()
                        }
                }
                .frame(height: context.topBarHeight)
        }
}

private struct ToolBarButton: View {

        let imageName: String
        let width: CGFloat
        let height: CGFloat
        let insets: EdgeInsets
        let action: () -> Void

        var body: some View {
                Button(action: action) {
                        ZStack {
                                Color.interactiveClear
                                Image(systemName: imageName)
                                        .resizable()
                                        .scaledToFit()
                                        .padding(.top, insets.top)
                                        .padding(.bottom, insets.bottom)
                                        .padding(.leading, insets.leading)
                                        .padding(.trailing, insets.trailing)
                        }
                }
                .buttonStyle(.plain)
                .frame(width: width, height: height)
        }
}
