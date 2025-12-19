import SwiftUI
import CoreIME
import CommonExtensions

struct ToolBar: View {

        @EnvironmentObject private var context: KeyboardViewController

        private let width: CGFloat = 48
        private let height: CGFloat = PresetConstant.toolBarHeight

        var body: some View {
                HStack(spacing: 0) {
                        ToolBarButton(
                                imageName: "gear",
                                width: width,
                                height: height,
                                insets: EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
                        ) {
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.updateKeyboardForm(to: .settings)
                        }

                        if context.keyboardInterface.isPadFloating.negative {
                                Spacer().frame(minWidth: 0, maxWidth: .infinity)
                                ToolBarButton(
                                        imageName: "keyboard",
                                        width: width,
                                        height: height,
                                        insets: EdgeInsets(top: 19, leading: 0, bottom: 19, trailing: 0)
                                ) {
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        let newForm: KeyboardForm = (context.keyboardForm == .layoutPicker) ? context.previousKeyboardForm : .layoutPicker
                                        context.updateKeyboardForm(to: newForm)
                                }
                        }

                        Spacer().frame(minWidth: 0, maxWidth: .infinity)
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
                                .frame(width: width, height: height)
                        }
                        .buttonStyle(.plain)


                        Spacer().frame(minWidth: 0, maxWidth: .infinity)
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
                                .frame(width: 64, height: height)
                        }
                        .buttonStyle(.plain)

                        Spacer().frame(minWidth: 0, maxWidth: .infinity)
                        ToolBarButton(
                                imageName: "arrow.left.and.line.vertical.and.arrow.right",
                                width: width,
                                height: height,
                                insets: EdgeInsets(top: 19, leading: 0, bottom: 19, trailing: 0)
                        ) {
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.updateKeyboardForm(to: .editingPanel)
                        }

                        Spacer().frame(minWidth: 0, maxWidth: .infinity)
                        Button {
                                AudioFeedback.modified()
                                context.triggerSelectionHapticFeedback()
                                context.toggleCharacterScriptVariant()
                        } label: {
                                ZStack {
                                        Color.interactiveClear
                                        if #available(iOSApplicationExtension 26.0, *) {
                                                CharacterSetSwitch(isMutilatedMode: context.characterStandard.isMutilated).disableAnimations()
                                        } else {
                                                LegacyCharacterSetSwitch(isMutilatedMode: context.characterStandard.isMutilated).disableAnimations()
                                        }
                                }
                                .frame(width: width, height: height)
                        }
                        .buttonStyle(.plain)

                        if context.keyboardInterface.isPadFloating.negative {
                                Spacer().frame(minWidth: 0, maxWidth: .infinity)
                                ToolBarButton(
                                        imageName: "keyboard.chevron.compact.down",
                                        width: width,
                                        height: height,
                                        insets: EdgeInsets(top: 18, leading: 0, bottom: 18, trailing: 0)
                                ) {
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        context.dismissKeyboard()
                                }
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
                                        .padding(insets)
                        }
                        .frame(width: width, height: height)
                }
                .buttonStyle(.plain)
        }
}
