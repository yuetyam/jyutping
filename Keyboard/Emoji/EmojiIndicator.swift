import SwiftUI

struct EmojiIndicator: View {

        init(index: Int, imageName: String, action: @escaping () -> Void = {}) {
                self.index = index
                self.imageName = imageName
                self.isCustomImage = imageName.hasPrefix("Emoji")
                let baseInset: CGFloat = 10
                self.topInset = switch index {
                case 2: baseInset + 2
                case 3: baseInset + 2
                case 4: baseInset + 1
                case 5: baseInset + 2
                case 6: baseInset + 2
                case 7: baseInset + 4
                case 8: baseInset + 2
                default: baseInset
                }
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
