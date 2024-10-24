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
        @State private var cantonese: String = String.empty
        @State private var lexicon: CantoneseLexicon? = nil
        @State private var unihanDefinition: UnihanDefinition? = nil

        @State private var yingWaaEntries: [YingWaaFanWan] = []
        @State private var choHokEntries: [ChoHokYuetYamCitYiu] = []
        @State private var fanWanEntries: [FanWanCuetYiu] = []
        @State private var gwongWanEntries: [GwongWanCharacter] = []

        var body: some View {
                Section {
                        TextField(placeholder, text: $inputText)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                                .submitLabel(submitLabel)
                                .onSubmit {
                                        let trimmedInput: String = inputText.trimmed()
                                        guard trimmedInput != cantonese else { return }
                                        defer { animationState += 1 }
                                        guard trimmedInput.isNotEmpty else {
                                                yingWaaEntries = []
                                                choHokEntries = []
                                                fanWanEntries = []
                                                gwongWanEntries = []
                                                lexicon = nil
                                                unihanDefinition = nil
                                                cantonese = String.empty
                                                return
                                        }
                                        yingWaaEntries = YingWaaFanWan.match(text: trimmedInput)
                                        choHokEntries = ChoHokYuetYamCitYiu.match(text: trimmedInput)
                                        fanWanEntries = FanWanCuetYiu.match(text: trimmedInput)
                                        gwongWanEntries = GwongWan.match(text: trimmedInput)
                                        let cantoneseLexicon = AppMaster.lookupCantoneseLexicon(for: trimmedInput)
                                        unihanDefinition = UnihanDefinition.match(text: cantoneseLexicon.text)
                                        if cantoneseLexicon.pronunciations.isEmpty {
                                                lexicon = nil
                                                cantonese = trimmedInput
                                        } else {
                                                lexicon = cantoneseLexicon
                                                cantonese = cantoneseLexicon.text
                                        }
                                }
                }
                if cantonese.isNotEmpty {
                        Section {
                                CantoneseTextLabel(cantonese)
                                if let pronunciations = lexicon?.pronunciations {
                                        ForEach(pronunciations.indices, id: \.self) { index in
                                                PronunciationLabel(pronunciations[index])
                                        }
                                }
                                if let definition = unihanDefinition?.definition {
                                        HStack {
                                                Text(verbatim: "英文").font(.copilot)
                                                Text.separator.font(.copilot)
                                                Text(verbatim: definition).font(.subheadline)
                                        }
                                }
                        }
                        .textSelection(.enabled)
                }
                if yingWaaEntries.isNotEmpty {
                        Section {
                                ForEach(yingWaaEntries.indices, id: \.self) { index in
                                        YingWaaFanWanLabel(entry: yingWaaEntries[index])
                                }
                        } header: {
                                if #available(iOS 16.0, *) {
                                        ViewThatFits(in: .horizontal) {
                                                Text(verbatim: yingWaaFullHeader).textCase(nil)
                                                Text(verbatim: yingWaaHeader).textCase(nil)
                                                Text(verbatim: yingWaaShortHeader).textCase(nil)
                                        }
                                } else {
                                        Text(verbatim: yingWaaHeader).textCase(nil)
                                }
                        }
                        .textSelection(.enabled)
                }
                if choHokEntries.isNotEmpty {
                        Section {
                                ForEach(choHokEntries.indices, id: \.self) { index in
                                        ChoHokYuetYamCitYiuLabel(entry: choHokEntries[index])
                                }
                        } header: {
                                if #available(iOS 16.0, *) {
                                        ViewThatFits(in: .horizontal) {
                                                Text(verbatim: choHokFullHeader).textCase(nil)
                                                Text(verbatim: choHokHeader).textCase(nil)
                                                Text(verbatim: choHokShortHeader).textCase(nil)
                                        }
                                } else {
                                        Text(verbatim: choHokHeader).textCase(nil)
                                }
                        }
                        .textSelection(.enabled)
                }
                if fanWanEntries.isNotEmpty {
                        Section {
                                ForEach(fanWanEntries.indices, id: \.self) { index in
                                        FanWanCuetYiuLabel(entry: fanWanEntries[index])
                                }
                        } header: {
                                Text(verbatim: fanWanHeader).textCase(nil)
                        }
                        .textSelection(.enabled)
                }
                if gwongWanEntries.isNotEmpty {
                        Section {
                                ForEach(gwongWanEntries.indices, id: \.self) { index in
                                        GwongWanLabel(entry: gwongWanEntries[index])
                                }
                        } header: {
                                Text(verbatim: gwongWanHeader).textCase(nil)
                        }
                        .textSelection(.enabled)
                }
        }

        private let yingWaaMeta: String = "《英華分韻撮要》　衛三畏　1856　廣州"
        private let yingWaaShortMeta: String = "《英華分韻撮要》衛三畏 1856 廣州"
        private let yingWaaFullMeta: String = "《英華分韻撮要》　衛三畏 (Samuel Wells Williams)　廣州　1856"
        private let choHokMeta: String = "《初學粵音切要》　湛約翰　1855　香港"
        private let choHokShortMeta: String = "《初學粵音切要》湛約翰 1855 香港"
        private let choHokFullMeta: String = "《初學粵音切要》　湛約翰 (John Chalmers)　香港　1855"
        private let fanWanMeta: String = "《分韻撮要》　佚名　清初　廣州府"
        private let gwongWanMeta: String = "《大宋重修廣韻》　陳彭年等　北宋"

        private var yingWaaHeader: String {
                guard let word: String = yingWaaEntries.first?.word else { return yingWaaMeta }
                return word + String.fullWidthSpace + yingWaaMeta
        }
        private var yingWaaShortHeader: String {
                guard let word: String = yingWaaEntries.first?.word else { return yingWaaShortMeta }
                return word + String.fullWidthSpace + yingWaaShortMeta
        }
        private var yingWaaFullHeader: String {
                guard let word: String = yingWaaEntries.first?.word else { return yingWaaFullMeta }
                return word + String.fullWidthSpace + yingWaaFullMeta
        }
        private var choHokHeader: String {
                guard let word: String = choHokEntries.first?.word else { return choHokMeta }
                return word + String.fullWidthSpace + choHokMeta
        }
        private var choHokShortHeader: String {
                guard let word: String = choHokEntries.first?.word else { return choHokShortMeta }
                return word + String.fullWidthSpace + choHokShortMeta
        }
        private var choHokFullHeader: String {
                guard let word: String = choHokEntries.first?.word else { return choHokFullMeta }
                return word + String.fullWidthSpace + choHokFullMeta
        }
        private var fanWanHeader: String {
                guard let word: String = fanWanEntries.first?.word else { return fanWanMeta }
                return word + String.fullWidthSpace + fanWanMeta
        }
        private var gwongWanHeader: String {
                guard let word: String = gwongWanEntries.first?.word else { return gwongWanMeta }
                return word + String.fullWidthSpace + gwongWanMeta
        }
}

#endif
