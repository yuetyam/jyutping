import SwiftUI
import CommonExtensions
import CoreIME

struct EmojiBoard: View {

        @EnvironmentObject private var context: KeyboardViewController

        @GestureState private var isBackspacing: Bool = false
        @State private var buffer: Int = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        @State private var currentCategory: Emoji.Category = .smileysAndPeople

        private let rows: [GridItem] = Array(repeating: GridItem(.flexible()), count: 5)

        var body: some View {
                ScrollViewReader { proxy in
                        HStack {
                                Text(verbatim: currentCategory.title)
                                        .font(.footnote)
                                        .foregroundStyle(Color.secondary)
                                        .padding(.horizontal)
                                Spacer()
                        }
                        .frame(height: 22)
                        ScrollView(.horizontal) {
                                LazyHGrid(rows: rows) {
                                        ForEach(Emoji.Category.allCases) { category in
                                                if let emojis: [Emoji] = EmojiMaster.emojis[category] {
                                                        Section {
                                                                ForEach(emojis) { emoji in
                                                                        ScrollViewButton {
                                                                                AudioFeedback.inputed()
                                                                                context.triggerSelectionHapticFeedback()
                                                                                context.operate(.input(emoji.text))
                                                                                EmojiMaster.updateFrequent(latest: emoji.text)
                                                                        } label: {
                                                                                Text(verbatim: emoji.text).font(.largeTitle)
                                                                        }
                                                                }
                                                        }
                                                        .id(category)
                                                }
                                        }
                                }
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
                                                currentCategory = .frequent
                                                proxy.scrollTo(Emoji.Category.frequent)
                                        }
                                        .foregroundStyle((currentCategory == .frequent) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 1, imageName: "EmojiSmiley") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .smileysAndPeople
                                                proxy.scrollTo(Emoji.Category.smileysAndPeople)
                                        }
                                        .foregroundStyle((currentCategory == .smileysAndPeople) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 2, imageName: "hare") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .animalsAndNature
                                                proxy.scrollTo(Emoji.Category.animalsAndNature)
                                        }
                                        .foregroundStyle((currentCategory == .animalsAndNature) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 3, imageName: "EmojiCategoryFoodAndDrink") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .foodAndDrink
                                                proxy.scrollTo(Emoji.Category.foodAndDrink)
                                        }
                                        .foregroundStyle((currentCategory == .foodAndDrink) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 4, imageName: footballImageName) {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .activity
                                                proxy.scrollTo(Emoji.Category.activity)
                                        }
                                        .foregroundStyle((currentCategory == .activity) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 5, imageName: "EmojiCategoryTravelAndPlaces") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .travelAndPlaces
                                                proxy.scrollTo(Emoji.Category.travelAndPlaces)
                                        }
                                        .foregroundStyle((currentCategory == .travelAndPlaces) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 6, imageName: "lightbulb") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .objects
                                                proxy.scrollTo(Emoji.Category.objects)
                                        }
                                        .foregroundStyle((currentCategory == .objects) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 7, imageName: "EmojiCategorySymbols") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .symbols
                                                proxy.scrollTo(Emoji.Category.symbols)
                                        }
                                        .foregroundStyle((currentCategory == .symbols) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 8, imageName: "flag") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .flags
                                                proxy.scrollTo(Emoji.Category.flags)
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

private extension Emoji.Category {
        var title: String {
                switch self {
                case .frequent:
                        return "Frequently Used"
                case .smileysAndPeople:
                        return "Smileys & People"
                case .animalsAndNature:
                        return "Animals & Nature"
                case .foodAndDrink:
                        return "Food & Drink"
                case .activity:
                        return "Activity"
                case .travelAndPlaces:
                        return "Travel & Places"
                case .objects:
                        return "Objects"
                case .symbols:
                        return "Symbols"
                case .flags:
                        return "Flags"
                }
        }
}
