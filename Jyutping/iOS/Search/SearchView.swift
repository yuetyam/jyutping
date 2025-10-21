#if os(iOS)

import SwiftUI
import AppDataSource
import CommonExtensions

struct SearchView: View {

        init(placeholder: LocalizedStringKey = "General.Search", submitLabel: SubmitLabel = .search, animationState: Binding<Int>) {
                self.placeholder = placeholder
                self.submitLabel = submitLabel
                self._animationState = animationState
        }

        private let placeholder: LocalizedStringKey
        private let submitLabel: SubmitLabel
        @Binding private var animationState: Int

        @State private var inputText: String = String.empty
        @State private var previousInputText: String = String.empty
        @State private var lexicons: [CantoneseLexicon] = []
        @State private var yingWaaLexicons: [YingWaaLexicon] = []
        @State private var choHokLexicons: [ChoHokLexicon] = []
        @State private var fanWanLexicons: [FanWanLexicon] = []
        @State private var gwongWanLexicons: [GwongWanLexicon] = []

        var body: some View {
                Section {
                        TextField(placeholder, text: $inputText)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                                .submitLabel(submitLabel)
                                .onSubmit {
                                        let trimmedInput: String = inputText.trimmed()
                                        guard trimmedInput != previousInputText else { return }
                                        previousInputText = trimmedInput
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
                                                let characters = trimmedInput.filter(\.isIdeographic).distinct()
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
                }
                ForEach(lexicons.indices, id: \.self) { index in
                        Section {
                                LexiconView(lexicon: lexicons[index])
                        }
                        .textSelection(.enabled)
                }
                ForEach(yingWaaLexicons.indices, id: \.self) { index in
                        Section {
                                YingWaaFanWanLexiconView(lexicon: yingWaaLexicons[index])
                        } header: {
                                if #available(iOS 16.0, *) {
                                        ViewThatFits(in: .horizontal) {
                                                Text(verbatim: "《英華分韻撮要》　衛三畏 (Samuel Wells Williams)　廣州　1856").textCase(nil)
                                                Text(verbatim: "《英華分韻撮要》　衛三畏　1856　廣州").textCase(nil)
                                                Text(verbatim: "《英華分韻撮要》衛三畏 1856 廣州").textCase(nil)
                                        }
                                } else {
                                        Text(verbatim: "《英華分韻撮要》　衛三畏　1856　廣州").textCase(nil)
                                }
                        }
                        .textSelection(.enabled)
                }
                ForEach(choHokLexicons.indices, id: \.self) { index in
                        Section {
                                ChoHokYuetYamCitYiuLexiconView(lexicon: choHokLexicons[index])
                        } header: {
                                if #available(iOS 16.0, *) {
                                        ViewThatFits(in: .horizontal) {
                                                Text(verbatim: "《初學粵音切要》　湛約翰 (John Chalmers)　香港　1855").textCase(nil)
                                                Text(verbatim: "《初學粵音切要》　湛約翰　1855　香港").textCase(nil)
                                                Text(verbatim: "《初學粵音切要》湛約翰 1855 香港").textCase(nil)
                                        }
                                } else {
                                        Text(verbatim: "《初學粵音切要》　湛約翰　1855　香港").textCase(nil)
                                }
                        }
                        .textSelection(.enabled)
                }
                ForEach(fanWanLexicons.indices, id: \.self) { index in
                        Section {
                                FanWanLexiconView(lexicon: fanWanLexicons[index])
                        } header: {
                                Text(verbatim: "《分韻撮要》　佚名　廣州府　清初").textCase(nil)
                        }
                        .textSelection(.enabled)
                }
                ForEach(gwongWanLexicons.indices, id: \.self) { index in
                        Section {
                                GwongWanLexiconView(lexicon: gwongWanLexicons[index])
                        } header: {
                                Text(verbatim: "《大宋重修廣韻》　陳彭年等　北宋").textCase(nil)
                        }
                        .textSelection(.enabled)
                }
        }
}

#endif
