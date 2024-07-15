import SwiftUI

struct ToolBar: View {

        @EnvironmentObject private var context: KeyboardViewController

        private let buttonWidth: CGFloat = 50
        private let buttonHeight: CGFloat = Constant.toolBarHeight

        private let editingButtonImageName: String = {
                if #available(iOSApplicationExtension 16.0, *) {
                        return "arrow.left.and.line.vertical.and.arrow.right"
                } else {
                        return "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right"
                }
        }()

        var body: some View {
                HStack(spacing: 0) {
                        ToolBarButton(
                                imageName: "gear",
                                width: buttonWidth,
                                height: buttonHeight,
                                insets: EdgeInsets(top: 18, leading: 0, bottom: 18, trailing: 0)
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
                                Image.smiley
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                        }
                        .buttonStyle(.plain)
                        .background(Color.interactiveClear)
                        .frame(width: buttonWidth, height: buttonHeight)

                        Spacer()
                        Button {
                                AudioFeedback.modified()
                                context.triggerSelectionHapticFeedback()
                                context.toggleInputMethodMode()
                        } label: {
                                CantoneseABCSwitch(isCantoneseSelected: context.inputMethodMode.isCantonese)
                        }
                        .buttonStyle(.plain)
                        .background(Color.interactiveClear)
                        .frame(width: 80, height: buttonHeight)

                        Spacer()
                        ToolBarButton(
                                imageName: editingButtonImageName,
                                width: buttonWidth,
                                height: buttonHeight,
                                insets: EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
                        ) {
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.updateKeyboardForm(to: .editingPanel)
                        }

                        Spacer()
                        ToolBarButton(
                                imageName: "keyboard.chevron.compact.down",
                                width: buttonWidth,
                                height: buttonHeight,
                                insets: EdgeInsets(top: 19, leading: 0, bottom: 20, trailing: 0)
                        ) {
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.dismissKeyboard()
                        }
                }
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
                        Image(systemName: imageName)
                                .resizable()
                                .scaledToFit()
                                .padding(.top, insets.top)
                                .padding(.bottom, insets.bottom)
                                .padding(.leading, insets.leading)
                                .padding(.trailing, insets.trailing)
                }
                .buttonStyle(.plain)
                .background(Color.interactiveClear)
                .frame(width: width, height: height)
        }
}
