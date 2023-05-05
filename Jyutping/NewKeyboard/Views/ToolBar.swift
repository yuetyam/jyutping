import SwiftUI

struct ToolBar: View {

        @EnvironmentObject private var context: KeyboardViewController

        @State private var isCantoneseSelected: Bool = true

        private let itemWidth: CGFloat = 50

        var body: some View {
                HStack(spacing: 0) {
                        ToolBarItem(imageName: "gear", width: itemWidth, height: Constant.toolBarHeight, insets: EdgeInsets(top: 18, leading: 0, bottom: 18, trailing: 0))
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
                                        .padding(.vertical, 18)
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
                                isCantoneseSelected.toggle()
                        }

                        Spacer()
                        ToolBarItem(imageName: "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right", width: itemWidth, height: Constant.toolBarHeight, insets: EdgeInsets(top: 19, leading: 0, bottom: 19, trailing: 0))
                                .onTapGesture {
                                        isCantoneseSelected.toggle()
                                }

                        Spacer()
                        ToolBarItem(imageName: "keyboard.chevron.compact.down", width: itemWidth, height: Constant.toolBarHeight, insets: EdgeInsets(top: 19, leading: 0, bottom: 20, trailing: 0))
                                .onTapGesture {
                                        context.dismissKeyboard()
                                }
                }
        }
}
