#if os(macOS)

import SwiftUI
import AppDataSource
import CommonExtensions

extension Notification.Name {
        static let focusSearch = Notification.Name("JyutpingApp.Notification.Name.focusSearch")
}

private enum FocusableField: Int, Hashable {
        case searchField
}

struct MacSearchView: View {

        @FocusState private var focusedField: FocusableField?

        @State private var submittedText: String = String.empty
        @State private var previousSubmittedText: String = String.empty

        @State private var lexicons: [CantoneseLexiconWithId] = []
        @State private var yingWaaLexicons: [YingWaaLexiconWithId] = []
        @State private var choHokLexicons: [ChoHokLexiconWithId] = []
        @State private var fanWanLexicons: [FanWanLexiconWithId] = []
        @State private var gwongWanLexicons: [GwongWanLexiconWithId] = []

        @State private var animationState: Int = 0
        @Namespace private var topID

        private func handleSubmission(_ text: String) {
                let trimmedInput: String = text.trimmed()
                guard trimmedInput != previousSubmittedText else { return }
                previousSubmittedText = trimmedInput
                defer { animationState += 1 }
                guard trimmedInput.isNotEmpty else {
                        lexicons = []
                        yingWaaLexicons = []
                        choHokLexicons = []
                        fanWanLexicons = []
                        gwongWanLexicons = []
                        return
                }
                let ideographicWords: [String] = {
                        let characters = trimmedInput.filter(\.isIdeographic).uniqued()
                        let isCharacterCountFine: Bool = characters.isNotEmpty && characters.count < 4
                        guard isCharacterCountFine else { return [] }
                        return characters.map({ String($0) })
                }()
                lexicons = AppMaster.searchCantoneseLexicons(for: trimmedInput).map({ CantoneseLexiconWithId(lexicon: $0) })
                yingWaaLexicons = ideographicWords.map({ YingWaaFanWan.match(text: $0) }).filter(\.isNotEmpty).map({ YingWaaLexiconWithId(lexicon: $0) })
                choHokLexicons = ideographicWords.map({ ChoHokYuetYamCitYiu.match(text: $0) }).filter(\.isNotEmpty).map({ ChoHokLexiconWithId(lexicon: $0) })
                fanWanLexicons = ideographicWords.map({ FanWanCuetYiu.match(text: $0) }).filter(\.isNotEmpty).map({ FanWanLexiconWithId(lexicon: $0) })
                gwongWanLexicons = ideographicWords.map({ GwongWan.match(text: $0) }).filter(\.isNotEmpty).map({ GwongWanLexiconWithId(lexicon: $0) })
        }

        var body: some View {
                ScrollViewReader { proxy in
                        SearchField("TextField.SearchPronunciation", submittedText: $submittedText)
                                .focused($focusedField, equals: .searchField)
                                .font(.master)
                                .padding(8)
                                .background(Color.textBackgroundColor, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background {
                                        Button {
                                                focusedField = .searchField
                                        } label: {
                                                EmptyView()
                                        }
                                        .buttonStyle(.plain)
                                        .keyboardShortcut("l", modifiers: .command)
                                }
                                .onAppear {
                                        focusedField = .searchField
                                }
                                .onReceive(NotificationCenter.default.publisher(for: .focusSearch)) { _ in
                                        focusedField = .searchField
                                }
                                .onChange(of: submittedText) { newText in
                                        withAnimation {
                                                proxy.scrollTo(topID)
                                        }
                                        Task(priority: .high) {
                                                handleSubmission(newText)
                                        }
                                }
                        ScrollView {
                                LazyVStack(spacing: 16) {
                                        EmptyView().id(topID)
                                        ForEach(lexicons) {
                                                CantoneseLexiconView(lexicon: $0.lexicon)
                                        }
                                        ForEach(yingWaaLexicons) {
                                                YingWaaLexiconView(lexicon: $0.lexicon)
                                        }
                                        ForEach(choHokLexicons) {
                                                ChoHokLexiconView(lexicon: $0.lexicon)
                                        }
                                        ForEach(fanWanLexicons) {
                                                FanWanLexiconView(lexicon: $0.lexicon)
                                        }
                                        ForEach(gwongWanLexicons) {
                                                GwongWanLexiconView(lexicon: $0.lexicon)
                                        }
                                }
                                .font(.master)
                                .textSelection(.enabled)
                                .padding(.horizontal)
                                .padding(.bottom, 32)
                        }
                        .animation(.default, value: animationState)
                }
                .navigationTitle("MacSidebar.NavigationTitle.Search")
        }
}

private struct CantoneseLexiconWithId: Hashable, Identifiable {
        let id: UUID = UUID()
        let lexicon: CantoneseLexicon
}
private struct YingWaaLexiconWithId: Hashable, Identifiable {
        let id: UUID = UUID()
        let lexicon: YingWaaLexicon
}
private struct ChoHokLexiconWithId: Hashable, Identifiable {
        let id: UUID = UUID()
        let lexicon: ChoHokLexicon
}
private struct FanWanLexiconWithId: Hashable, Identifiable {
        let id: UUID = UUID()
        let lexicon: FanWanLexicon
}
private struct GwongWanLexiconWithId: Hashable, Identifiable {
        let id: UUID = UUID()
        let lexicon: GwongWanLexicon
}

#endif
