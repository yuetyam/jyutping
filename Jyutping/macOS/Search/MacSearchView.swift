#if os(macOS)

import SwiftUI
import AppDataSource
import CommonExtensions

struct MacSearchView: View {

        @State private var submittedText: String = String.empty
        @State private var previousSubmittedText: String = String.empty
        @FocusState private var isTextFieldFocused: Bool

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
                let ideographicWords: [String] = {
                        let characters = trimmedInput.filter(\.isIdeographic).uniqued()
                        let isCharacterCountFine: Bool = characters.isNotEmpty && characters.count < 4
                        guard isCharacterCountFine else { return [] }
                        return characters.map({ String($0) })
                }()
                lexicons = AppMaster.searchCantoneseLexicons(for: trimmedInput)
                yingWaaLexicons = ideographicWords.map({ YingWaaFanWan.match(text: $0) }).filter(\.isNotEmpty)
                choHokLexicons = ideographicWords.map({ ChoHokYuetYamCitYiu.match(text: $0) }).filter(\.isNotEmpty)
                fanWanLexicons = ideographicWords.map({ FanWanCuetYiu.match(text: $0) }).filter(\.isNotEmpty)
                gwongWanLexicons = ideographicWords.map({ GwongWan.match(text: $0) }).filter(\.isNotEmpty)
        }

        var body: some View {
                ScrollViewReader { proxy in
                        SearchField("TextField.SearchPronunciation", submittedText: $submittedText)
                                .focused($isTextFieldFocused)
                                .font(.master)
                                .padding(8)
                                .background(Color.textBackgroundColor, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .onAppear {
                                        isTextFieldFocused = true
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
                                        ForEach(lexicons.indices, id: \.self) { index in
                                                CantoneseLexiconView(lexicon: lexicons[index])
                                        }
                                        ForEach(yingWaaLexicons.indices, id: \.self) { index in
                                                YingWaaLexiconView(lexicon: yingWaaLexicons[index])
                                        }
                                        ForEach(choHokLexicons.indices, id: \.self) { index in
                                                ChoHokLexiconView(lexicon: choHokLexicons[index])
                                        }
                                        ForEach(fanWanLexicons.indices, id: \.self) { index in
                                                FanWanLexiconView(lexicon: fanWanLexicons[index])
                                        }
                                        ForEach(gwongWanLexicons.indices, id: \.self) { index in
                                                GwongWanLexiconView(lexicon: gwongWanLexicons[index])
                                        }
                                }
                                .font(.master)
                                .textSelection(.enabled)
                                .padding(.horizontal)
                                .padding(.bottom)
                        }
                        .animation(.default, value: animationState)
                }
                .navigationTitle("MacSidebar.NavigationTitle.Search")
        }
}

#endif
