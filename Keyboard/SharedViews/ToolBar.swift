import SwiftUI
import CoreIME
import CommonExtensions

struct ToolBar: View {

        @EnvironmentObject private var context: KeyboardViewController

        private let height: CGFloat = PresetConstant.toolBarHeight

        var body: some View {
                let keyboardInterface = context.keyboardInterface
                let isDenseMode: Bool = switch keyboardInterface {
                case .padFloating: true
                case .phonePortrait where (context.keyboardWidth < 359): true
                case .phoneOnPadPortrait where (context.keyboardWidth < 359): true
                default: false
                }
                let width: CGFloat = isDenseMode ? 44 : 48
                let isCompactMode: Bool = keyboardInterface.isCompact
                let extra: CGFloat = isCompactMode ? 0 : 2
                HStack(spacing: 0) {
                        ToolBarButton(
                                imageName: "gear",
                                width: width,
                                height: height,
                                insets: EdgeInsets(top: 17 - extra, leading: 0, bottom: 17 - extra, trailing: 0)
                        ) {
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.updateKeyboardForm(to: .settings)
                        }

                        Spacer().frame(minWidth: 0, maxWidth: .infinity)
                        ToolBarButton(
                                imageName: "keyboard",
                                width: width,
                                height: height,
                                insets: EdgeInsets(top: 19 - extra, leading: 0, bottom: 20 - extra, trailing: 0)
                        ) {
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.updateKeyboardForm(to: .layoutPicker)
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
                                                .frame(width: 22 + (extra * 2), height: 22 + (extra * 2))
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
                                                InputModeSwitch(isDenseMode: isDenseMode, isCompactMode: isCompactMode, isCantoneseMode: context.inputMethodMode.isCantonese, isMutilatedMode: context.characterStandard.isMutilated)
                                        } else {
                                                LegacyInputModeSwitch(isDenseMode: isDenseMode, isCompactMode: isCompactMode, isCantoneseMode: context.inputMethodMode.isCantonese, isMutilatedMode: context.characterStandard.isMutilated)
                                        }
                                }
                                .frame(width: isDenseMode ? 56 : 64, height: height)
                        }
                        .buttonStyle(.plain)

                        Spacer().frame(minWidth: 0, maxWidth: .infinity)
                        ToolBarButton(
                                imageName: "arrow.left.and.line.vertical.and.arrow.right",
                                width: width,
                                height: height,
                                insets: EdgeInsets(top: 20 - extra, leading: 0, bottom: 19 - extra, trailing: 0)
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
                                                CharacterSetSwitch(width: width, isCompactMode: isCompactMode, isMutilatedMode: context.characterStandard.isMutilated).disableAnimations()
                                        } else {
                                                LegacyCharacterSetSwitch(width: width, isCompactMode: isCompactMode, isMutilatedMode: context.characterStandard.isMutilated).disableAnimations()
                                        }
                                }
                                .frame(width: width, height: height)
                        }
                        .buttonStyle(.plain)

                        Spacer().frame(minWidth: 0, maxWidth: .infinity)
                        ToolBarButton(
                                imageName: "keyboard.chevron.compact.down",
                                width: width,
                                height: height,
                                insets: EdgeInsets(top: 19 - extra, leading: 0, bottom: 18 - extra, trailing: 0)
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
                                        .padding(insets)
                        }
                        .frame(width: width, height: height)
                }
                .buttonStyle(.plain)
        }
}
