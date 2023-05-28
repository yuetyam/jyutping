import SwiftUI
import CoreIME

struct EmojiBoard: View {

        @EnvironmentObject private var context: KeyboardViewController

        @State private var currentCategory: Emoji.Category = .smileysAndPeople

        @GestureState private var isBackspacing: Bool = false
        @State private var buffer: Int = 0
        private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

        private let gridItems: [GridItem] = [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
        ]

        var body: some View {
                ScrollViewReader { proxy in
                        HStack {
                                Text(verbatim: currentCategory.title).font(.footnote).foregroundColor(.secondary)
                                Spacer()
                        }
                        .frame(height: 24)
                        ScrollView(.horizontal) {
                                LazyHGrid(rows: gridItems) {
                                        ForEach(Emoji.Category.allCases) { category in
                                                if let emojis = EmojiMaster.emojis[category] {
                                                        Section {
                                                                ForEach(0..<emojis.count, id: \.self) { index in
                                                                        EmojiCell(emoji: emojis[index])
                                                                }
                                                        }
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


struct EmojiCell: View {

        let emoji: String

        @EnvironmentObject private var context: KeyboardViewController

        @Environment(\.colorScheme) private var colorScheme
        private var activeKeyColor: Color {
                switch colorScheme {
                case .light:
                        return .light
                case .dark:
                        return .dark
                @unknown default:
                        return .light
                }
        }

        @GestureState private var isTouching: Bool = false

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        Text(verbatim: emoji).font(.largeTitle)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                        context.operate(.input(emoji))
                }
        }
}


struct EmojiMaster {

        private static let key: String = "emoji_frequent"
        private(set) static var frequent: [String] = {
                let history = UserDefaults.standard.string(forKey: key)
                guard let history else { return defaultFrequent }
                guard !(history.isEmpty) else { return defaultFrequent }
                guard history.contains(",") else { return [history] }
                return history.split(separator: ",").map({ $0.trimmingCharacters(in: .whitespaces).trimmingCharacters(in: .controlCharacters) })
        }()
        static func updateFrequent(latest emoji: String) {
                let combined: [String] = ([emoji] + frequent).uniqued()
                let updated: [String] = combined.count <= 30 ? combined : combined.dropLast(combined.count - 30)
                frequent = updated
                let frequentText: String = updated.joined(separator: ",")
                UserDefaults.standard.set(frequentText, forKey: key)
        }
        static func clearFrequent() {
                frequent = defaultFrequent
                let emptyText: String = ""
                UserDefaults.standard.set(emptyText, forKey: key)
        }

        static let emojis: [Emoji.Category: [String]] = {
                var dict: [Emoji.Category: [String]] = [:]
                let fetched = Engine.fetchEmoji()
                _ = Emoji.Category.allCases.map { category in
                        let categoryEmoji = fetched.filter({ $0.category == category })
                        let filtered: [String] = {
                                if #available(iOSApplicationExtension 16.4, *) {
                                        return categoryEmoji.map(\.text).uniqued()
                                } else if #available(iOSApplicationExtension 15.4, *) {
                                        return categoryEmoji.map(\.text).uniqued().filter({ !new_in_iOS_16_4.contains($0) })
                                } else {
                                        return categoryEmoji.map(\.text).uniqued().filter({ !new_in_iOS_16_4.contains($0) && !new_in_iOS_15_4.contains($0) })
                                }
                        }()
                        dict[category] = filtered
                }
                return dict
        }()


        private static let defaultFrequent: [String] = ["👋", "👍", "👌", "✌️", "👏", "🤩", "😍", "😘", "🥰", "😋", "😎", "😇", "🤗", "😏", "🤔", "❤️", "💖", "💕", "💞", "🌹", "🌚", "👀", "🐶", "👻", "🤪", "🍻", "🔥", "✅", "💯", "🎉"]

        private static let new_in_iOS_16_4: Set<String> = ["🫨", "🩷", "🩵", "🩶", "🫷", "🫸", "🫎", "🫏", "🪽", "🐦‍⬛", "🪿", "🪼", "🪻", "🫚", "🫛", "🪭", "🪮", "🪇", "🪈", "🪯", "🛜"]

        private static let new_in_iOS_15_4: Set<String> = ["🥹", "🫣", "🫢", "🫡", "🫠", "🫥", "🫤", "🫶", "🤝", "🫰", "🫳", "🫴", "🫲", "🫱", "🫵", "🫦", "🫅", "🧌", "🫄", "🫃", "🪺", "🪹", "🪸", "🪷", "🫧", "🫙", "🫘", "🫗", "🛝", "🩼", "🛞", "🛟", "🪫", "🪪", "🪬", "🩻", "🪩", "🟰"]
}
