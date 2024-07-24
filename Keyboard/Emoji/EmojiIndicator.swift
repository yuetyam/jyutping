import SwiftUI

struct EmojiIndicator: View {

        init(index: Int, imageName: String, action: @escaping () -> Void = {}) {
                self.index = index
                self.imageName = imageName
                self.isCustomImage = imageName.hasPrefix("Emoji")
                let baseInset: CGFloat = 10
                self.topInset = {
                        switch index {
                        case 2:
                                return baseInset + 2
                        case 3:
                                return baseInset + 2
                        case 4:
                                if #available(iOSApplicationExtension 16.0, *) {
                                        return baseInset + 1
                                } else {
                                        return baseInset + 3
                                }
                        case 5:
                                return baseInset + 2
                        case 6:
                                return baseInset + 2
                        case 7:
                                return baseInset + 4
                        case 8:
                                return baseInset + 2
                        default:
                                return baseInset
                        }
                }()
                self.bottomInset = 10
                self.action = action
        }

        private let index: Int
        private let imageName: String
        private let isCustomImage: Bool
        private let topInset: CGFloat
        private let bottomInset: CGFloat
        private let action: () -> Void

        var body: some View {
                Button(action: action) {
                        ZStack {
                                Color.interactiveClear
                                if isCustomImage {
                                        Image(uiImage: UIImage(named: imageName)?.cropped()?.withRenderingMode(.alwaysTemplate) ?? UIImage())
                                                .resizable()
                                                .scaledToFit()
                                                .padding(.top, topInset)
                                                .padding(.bottom, bottomInset)
                                } else {
                                        Image(systemName: imageName)
                                                .resizable()
                                                .scaledToFit()
                                                .padding(.top, topInset)
                                                .padding(.bottom, bottomInset)
                                }
                        }
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
}
