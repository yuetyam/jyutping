import SwiftUI
import Combine
import CommonExtensions
import CoreIME

private extension Emoji.Category {
        var viewID: Int {
                return self.rawValue + 100
        }
}

struct EmojiBoard: View {

        @EnvironmentObject private var context: KeyboardViewController

        @GestureState private var isBackspacing: Bool = false
        @State private var buffer: Int = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        @State private var currentCategory: Emoji.Category = .frequent

        var body: some View {
                let rows: [GridItem] = Array(repeating: GridItem(.flexible()), count: context.keyboardInterface.isPhoneLandscape ? 3 : 5)
                ScrollViewReader { proxy in
                        HStack {
                                Text(currentCategory.title)
                                        .font(.footnote)
                                        .foregroundStyle(Color.secondary)
                                        .padding(.horizontal, 8)
                                Spacer()
                        }
                        .frame(height: 20)
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
                                                                                EmojiMaster.updateFrequent(latest: emoji)
                                                                        } label: {
                                                                                Text(verbatim: emoji.text).font(.emoji)
                                                                        }
                                                                        .id(emoji.id)
                                                                }
                                                        }
                                                        .id(category.viewID)
                                                }
                                        }
                                }
                        }
                        .frame(maxHeight: .infinity)
                        HStack(spacing: 0) {
                                Button {
                                        AudioFeedback.modified()
                                        context.triggerHapticFeedback()
                                        context.updateKeyboardForm(to: context.previousKeyboardForm)
                                } label: {
                                        ZStack {
                                                Color.interactiveClear
                                                Image(systemName: "abc")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 36, height: 36)
                                        }
                                }
                                .buttonStyle(.plain)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                Group {
                                        EmojiIndicator(index: 0, imageName: "clock") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .frequent
                                                proxy.scrollTo(Emoji.Category.frequent.viewID)
                                        }
                                        .foregroundStyle((currentCategory == .frequent) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 1, imageName: "EmojiSmiley") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .smileysAndPeople
                                                proxy.scrollTo(Emoji.Category.smileysAndPeople.viewID)
                                        }
                                        .foregroundStyle((currentCategory == .smileysAndPeople) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 2, imageName: "hare") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .animalsAndNature
                                                proxy.scrollTo(Emoji.Category.animalsAndNature.viewID)
                                        }
                                        .foregroundStyle((currentCategory == .animalsAndNature) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 3, imageName: "EmojiCategoryFoodAndDrink") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .foodAndDrink
                                                proxy.scrollTo(Emoji.Category.foodAndDrink.viewID)
                                        }
                                        .foregroundStyle((currentCategory == .foodAndDrink) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 4, imageName: footballImageName) {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .activity
                                                proxy.scrollTo(Emoji.Category.activity.viewID)
                                        }
                                        .foregroundStyle((currentCategory == .activity) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 5, imageName: "EmojiCategoryTravelAndPlaces") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .travelAndPlaces
                                                proxy.scrollTo(Emoji.Category.travelAndPlaces.viewID)
                                        }
                                        .foregroundStyle((currentCategory == .travelAndPlaces) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 6, imageName: "lightbulb") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .objects
                                                proxy.scrollTo(Emoji.Category.objects.viewID)
                                        }
                                        .foregroundStyle((currentCategory == .objects) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 7, imageName: "EmojiCategorySymbols") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .symbols
                                                proxy.scrollTo(Emoji.Category.symbols.viewID)
                                        }
                                        .foregroundStyle((currentCategory == .symbols) ? Color.primary : Color.secondary)
                                        EmojiIndicator(index: 8, imageName: "flag") {
                                                AudioFeedback.modified()
                                                context.triggerHapticFeedback()
                                                currentCategory = .flags
                                                proxy.scrollTo(Emoji.Category.flags.viewID)
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
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .contentShape(Rectangle())
                                .gesture(DragGesture(minimumDistance: 0)
                                        .updating($isBackspacing) { _, tapped, _ in
                                                if tapped.negative {
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
        var title: LocalizedStringKey {
                switch self {
                case .frequent:
                        return "Emoji.Category.FrequentlyUsed"
                case .smileysAndPeople:
                        return "Emoji.Category.SmileysAndPeople"
                case .animalsAndNature:
                        return "Emoji.Category.AnimalsAndNature"
                case .foodAndDrink:
                        return "Emoji.Category.FoodAndDrink"
                case .activity:
                        return "Emoji.Category.Activity"
                case .travelAndPlaces:
                        return "Emoji.Category.TravelAndPlaces"
                case .objects:
                        return "Emoji.Category.Objects"
                case .symbols:
                        return "Emoji.Category.Symbols"
                case .flags:
                        return "Emoji.Category.Flags"
                }
        }
}
