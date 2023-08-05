import SwiftUI

struct ToolBar: View {

        @EnvironmentObject private var context: KeyboardViewController

        private let itemWidth: CGFloat = 50

        private let editingButtonImageName: String = {
                if #available(iOSApplicationExtension 16.0, *) {
                        return "arrow.left.and.line.vertical.and.arrow.right"
                } else {
                        return "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right"
                }
        }()

        var body: some View {
                HStack(spacing: 0) {
                        ToolBarItem(imageName: "gear", width: itemWidth, height: Constant.toolBarHeight, insets: EdgeInsets(top: 18, leading: 0, bottom: 18, trailing: 0))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        context.updateKeyboardForm(to: .settings)
                                }

                        Spacer()
                        ZStack {
                                Color.interactiveClear
                                Image(uiImage: UIImage.emojiSmiley)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                        }
                        .frame(width: itemWidth, height: Constant.toolBarHeight)
                        .contentShape(Rectangle())
                        .onTapGesture {
                                AudioFeedback.modified()
                                context.triggerHapticFeedback()
                                context.updateKeyboardForm(to: .emojiBoard)
                        }

                        Spacer()
                        ZStack {
                                Color.interactiveClear
                                CantoneseABCSwitch(isCantoneseSelected: context.inputMethodMode.isCantonese)
                        }
                        .frame(width: 80, height: Constant.toolBarHeight)
                        .contentShape(Rectangle())
                        .onTapGesture {
                                AudioFeedback.modified()
                                context.triggerSelectionHapticFeedback()
                                context.toggleInputMethodMode()
                        }

                        Spacer()
                        ToolBarItem(imageName: editingButtonImageName, width: itemWidth, height: Constant.toolBarHeight, insets: EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                                .onTapGesture {
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        context.updateKeyboardForm(to: .editingPanel)
                                }

                        Spacer()
                        ToolBarItem(imageName: "keyboard.chevron.compact.down", width: itemWidth, height: Constant.toolBarHeight, insets: EdgeInsets(top: 19, leading: 0, bottom: 20, trailing: 0))
                                .onTapGesture {
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        context.dismissKeyboard()
                                }
                }
        }
}
