import SwiftUI

struct ToolBarItem: View {

        let imageName: String
        let width: CGFloat
        let height: CGFloat
        let insets: EdgeInsets

        var body: some View {
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
                .frame(width: width, height: height)
                .contentShape(Rectangle())
        }
}
