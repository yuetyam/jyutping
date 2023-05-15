import SwiftUI

struct ToolBar: View {

        @EnvironmentObject private var context: KeyboardViewController

        private let itemWidth: CGFloat = 50

        var body: some View {
                HStack(spacing: 0) {
                        ToolBarItem(imageName: "gear", width: itemWidth, height: Constant.toolBarHeight, insets: EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                                .contentShape(Rectangle())
                                .onTapGesture {
                                        context.updateKeyboardType(to: .settings)
                                }

                        Spacer()
                        ZStack {
                                Color.interactiveClear
                                Image(uiImage: UIImage.emojiSmiley)
                                        .resizable()
                                        .scaledToFit()
                                        .padding(.vertical, 15)
                        }
                        .frame(width: itemWidth, height: Constant.toolBarHeight)
                        .contentShape(Rectangle())
                        .onTapGesture {
                                print("No Emoji Board")
                        }

                        Spacer()
                        ZStack {
                                Color.interactiveClear
                                CantoneseABCSwitch(isCantoneseSelected: !(context.keyboardType.isABCMode))
                        }
                        .frame(width: 72, height: Constant.toolBarHeight)
                        .contentShape(Rectangle())
                        .onTapGesture {
                                let newKeyboardType: KeyboardType = {
                                        switch context.keyboardType {
                                        case .abc(let keyboardCase):
                                                return .cantonese(keyboardCase)
                                        case .cantonese(let keyboardCase):
                                                return .abc(keyboardCase)
                                        default:
                                                return .cantonese(.lowercased)
                                        }
                                }()
                                context.updateKeyboardType(to: newKeyboardType)
                        }

                        Spacer()
                        ToolBarItem(imageName: "arrow.left.and.line.vertical.and.arrow.right", width: itemWidth, height: Constant.toolBarHeight, insets: EdgeInsets(top: 17, leading: 0, bottom: 17, trailing: 0))
                                .onTapGesture {
                                        context.updateKeyboardType(to: .editingPanel)
                                }

                        Spacer()
                        ToolBarItem(imageName: "keyboard.chevron.compact.down", width: itemWidth, height: Constant.toolBarHeight, insets: EdgeInsets(top: 16, leading: 0, bottom: 17, trailing: 0))
                                .onTapGesture {
                                        context.dismissKeyboard()
                                }
                }
        }
}
