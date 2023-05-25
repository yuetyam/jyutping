import SwiftUI

struct EmojiBoard: View {

        @EnvironmentObject private var context: KeyboardViewController

        @GestureState private var isBackspacing: Bool = false
        @State private var buffer: Int = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        var body: some View {
                VStack(spacing: 0) {
                        HStack(spacing: 0) {
                                ZStack {
                                        Color.interactiveClear
                                        Image(systemName: "abc")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 36, height: 36)
                                }
                                .frame(height: 40)
                                .frame(maxWidth: .infinity)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        context.updateKeyboardForm(to: context.previousKeyboardForm)
                                }
                                Group {
                                        Indicator(index: 0, imageName: "clock")
                                        Indicator(index: 1, imageName: "EmojiSmiley")
                                        Indicator(index: 2, imageName: "hare")
                                        Indicator(index: 3, imageName: "EmojiCategoryFoodAndDrink")
                                        Indicator(index: 4, imageName: footballImageName)
                                        Indicator(index: 5, imageName: "EmojiCategoryTravelAndPlaces")
                                        Indicator(index: 6, imageName: "lightbulb")
                                        Indicator(index: 7, imageName: "EmojiCategorySymbols")
                                        Indicator(index: 8, imageName: "flag")
                                }
                                ZStack {
                                        Color.interactiveClear
                                        Image(systemName: "delete.backward")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                }
                                .frame(height: 40)
                                .frame(maxWidth: .infinity)
                                .contentShape(Rectangle())
                                .gesture(DragGesture(minimumDistance: 0)
                                        .updating($isBackspacing) { _, tapped, _ in
                                                if !tapped {
                                                        AudioFeedback.deleted()
                                                        context.triggerHapticFeedback()
                                                        context.operate(.backspace)
                                                        tapped = true
                                                }
                                        }
                                        .onEnded { _ in
                                                buffer = 0
                                        }
                                )
                                .onReceive(timer) { _ in
                                        guard isBackspacing else { return }
                                        if buffer > 3 {
                                                AudioFeedback.deleted()
                                                context.triggerHapticFeedback()
                                                context.operate(.backspace)
                                        } else {
                                                buffer += 1
                                        }
                                }
                        }
                }
        }

        private let footballImageName: String = {
                if #available(iOSApplicationExtension 16.0, *) {
                        return "soccerball"
                } else {
                        return "EmojiCategoryActivity"
                }
        }()
}

struct Indicator: View {

        init(index: Int, imageName: String) {
                self.index = index
                self.imageName = imageName
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
        }

        let index: Int
        let imageName : String
        let topInset: CGFloat
        let bottomInset: CGFloat

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        if imageName.hasPrefix("Emoji") {
                                Image(uiImage: UIImage(named: imageName)?.cropped()?.withRenderingMode(.alwaysTemplate) ?? UIImage.emojiSmiley)
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
                .frame(height: 40)
                .frame(maxWidth: .infinity)
        }
}
