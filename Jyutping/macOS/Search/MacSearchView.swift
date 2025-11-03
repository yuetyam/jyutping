#if os(macOS)

import SwiftUI
import AppDataSource
import CommonExtensions

private enum FocusableField: Int, Hashable {
        case searchField
}

struct MacSearchView: View {

        @FocusState private var focusedField: FocusableField?

        @State private var submittedText: String = String.empty
        @State private var previousSubmittedText: String = String.empty

        @State private var lexicons: [CantoneseLexicon] = []
        @State private var yingWaaLexicons: [YingWaaLexicon] = []
        @State private var choHokLexicons: [ChoHokLexicon] = []
        @State private var fanWanLexicons: [FanWanLexicon] = []
        @State private var gwongWanLexicons: [GwongWanLexicon] = []

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
                let ideographicCharacters: [Character] = {
                        let characters = trimmedInput.filter(\.isIdeographic).distinct()
                        guard characters.isNotEmpty && characters.count < 4 else { return [] }
                        return characters
                }()
                lexicons = AppMaster.searchCantoneseLexicons(for: trimmedInput)
                yingWaaLexicons = ideographicCharacters.compactMap({ YingWaa.search($0) })
                choHokLexicons = ideographicCharacters.compactMap({ ChoHok.search($0) })
                fanWanLexicons = ideographicCharacters.compactMap({ FanWan.search($0) })
                gwongWanLexicons = ideographicCharacters.compactMap({ GwongWan.search($0) })
        }

        var body: some View {
                ScrollViewReader { proxy in
                        SearchField("TextField.SearchPronunciation", submittedText: $submittedText)
                                .focused($focusedField, equals: .searchField)
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
                                                CantoneseLexiconView(lexicon: $0)
                                        }
                                        ForEach(yingWaaLexicons) {
                                                YingWaaLexiconView(lexicon: $0)
                                        }
                                        ForEach(choHokLexicons) {
                                                ChoHokLexiconView(lexicon: $0)
                                        }
                                        ForEach(fanWanLexicons) {
                                                FanWanLexiconView(lexicon: $0)
                                        }
                                        ForEach(gwongWanLexicons) {
                                                GwongWanLexiconView(lexicon: $0)
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

#endif
