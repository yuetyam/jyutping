import SwiftUI
import CommonExtensions
import CoreIME

struct EmojiBoard: View {

        @EnvironmentObject private var context: KeyboardViewController

        @State private var currentCategory: Emoji.Category? = .smileysAndPeople

        @GestureState private var isBackspacing: Bool = false
        @State private var buffer: Int = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        private let frequentColumns: [[String]] = EmojiMaster.frequent.chunked(size: 5)

        private func columns(of category: Emoji.Category) -> [[String]] {
                guard let emojis = EmojiMaster.emojis[category] else { return [] }
                return emojis.chunked(size: 5)
        }

        private let gridItems: [GridItem] = [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
        ]
        private let categories: [[String]] = {
                var blocks: [[String]] = [EmojiMaster.frequent]
                _ = Emoji.Category.allCases.map { category in
                        guard let emojis = EmojiMaster.emojis[category] else { return }
                        blocks.append(emojis)
                }
                return blocks
        }()

        var body: some View {
                ScrollViewReader { proxy in
                        HStack {
                                Text(verbatim: currentCategory?.title ?? "Frequently Used")
                                        .font(.footnote)
                                        .foregroundStyle(Color.secondary)
                                        .padding(.horizontal)
                                Spacer()
                        }
                        .frame(height: 22)
                        ScrollView(.horizontal) {
                                LazyHGrid(rows: gridItems) {
                                        ForEach(0..<categories.count, id: \.self) { index in
                                                let emojis = categories[index]
                                                Section {
                                                        ForEach(0..<emojis.count, id: \.self) { deepIndex in
                                                                Text(verbatim: emojis[deepIndex]).font(.largeTitle)
                                                        }
                                                }
                                                .id(index)
                                        }
                                }
                                /*
                                LazyHStack(spacing: 0) {
                                        ForEach(0..<frequentColumns.count, id: \.self) { index in
                                                let column = frequentColumns[index]
                                                VStack(spacing: 0) {
                                                        ForEach(0..<column.count, id: \.self) { deepIndex in
                                                                Text(verbatim: column[deepIndex]).font(.largeTitle)
                                                        }
                                                }
                                        }
                                        Spacer().frame(width: 44)
                                        ForEach(Emoji.Category.allCases) { category in
                                                let emojiColumns = columns(of: category)
                                                ForEach(0..<emojiColumns.count, id: \.self) { index in
                                                        let column = emojiColumns[index]
                                                        VStack(spacing: 0) {
                                                                ForEach(0..<column.count, id: \.self) { deepIndex in
                                                                        Text(verbatim: column[deepIndex]).font(.largeTitle)
                                                                }
                                                        }
                                                }
                                                Spacer().frame(width: 44)
                                        }
                                }
                                */
                        }
                        .frame(maxHeight: .infinity)
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
                                        EmojiIndicator(index: 0, imageName: "clock") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = nil
                                                proxy.scrollTo(0)
                                        }
                                        .foregroundStyle((currentCategory == nil) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 1, imageName: "EmojiSmiley") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .smileysAndPeople
                                                proxy.scrollTo(1)
                                        }
                                        .foregroundStyle((currentCategory == .smileysAndPeople) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 2, imageName: "hare") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .animalsAndNature
                                                proxy.scrollTo(2)
                                        }
                                        .foregroundStyle((currentCategory == .animalsAndNature) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 3, imageName: "EmojiCategoryFoodAndDrink") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .foodAndDrink
                                                proxy.scrollTo(3)
                                        }
                                        .foregroundStyle((currentCategory == .foodAndDrink) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 4, imageName: footballImageName) {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .activity
                                                proxy.scrollTo(4)
                                        }
                                        .foregroundStyle((currentCategory == .activity) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 5, imageName: "EmojiCategoryTravelAndPlaces") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .travelAndPlaces
                                                proxy.scrollTo(5)
                                        }
                                        .foregroundStyle((currentCategory == .travelAndPlaces) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 6, imageName: "lightbulb") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .objects
                                                proxy.scrollTo(6)
                                        }
                                        .foregroundStyle((currentCategory == .objects) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 7, imageName: "EmojiCategorySymbols") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .symbols
                                                proxy.scrollTo(7)
                                        }
                                        .foregroundStyle((currentCategory == .symbols) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 8, imageName: "flag") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .flags
                                                proxy.scrollTo(8)
                                        }
                                        .foregroundStyle((currentCategory == .flags) ? Color.primary : Color.secondary)
                                }
                                ZStack {
                                        Color.interactiveClear
                                        Image.backspace
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
                        .frame(height: 40)
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
