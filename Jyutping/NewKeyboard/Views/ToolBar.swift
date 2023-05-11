import SwiftUI

struct ToolBar: View {

        @EnvironmentObject private var context: KeyboardViewController

        @State private var isCantoneseSelected: Bool = true

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
                                isCantoneseSelected.toggle()
                        }

                        Spacer()
                        ZStack {
                                Color.interactiveClear
                                CantoneseABCSwitch(isCantoneseSelected: isCantoneseSelected)
                        }
                        .frame(width: 72, height: Constant.toolBarHeight)
                        .contentShape(Rectangle())
                        .onTapGesture {
                                let isLeftSelected: Bool = isCantoneseSelected
                                isCantoneseSelected.toggle()
                                let newKeyboardType: KeyboardType = isLeftSelected ? .abc(.lowercased) : .cantonese(.lowercased)
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
