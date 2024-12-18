#if os(macOS)

import SwiftUI
import AppDataSource
import CommonExtensions

struct MacSearchView: View {

        @State private var submittedText: String = String.empty
        @FocusState private var isTextFieldFocused: Bool

        @State private var cantonese: String = String.empty
        @State private var lexicon: CantoneseLexicon? = nil
        @State private var unihanDefinition: UnihanDefinition? = nil
        @State private var yingWaaEntries: [YingWaaFanWan] = []
        @State private var choHokEntries: [ChoHokYuetYamCitYiu] = []
        @State private var fanWanEntries: [FanWanCuetYiu] = []
        @State private var gwongWanEntries: [GwongWanCharacter] = []
        @State private var animationState: Int = 0
        @Namespace private var topID

        private func handleSubmission(_ text: String) {
                let trimmedInput: String = text.trimmed()
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
                                        if cantonese.isNotEmpty {
                                                VStack {
                                                        CantoneseTextView(cantonese)
                                                        if let pronunciations = lexicon?.pronunciations {
                                                                ForEach(pronunciations.indices, id: \.self) { index in
                                                                        Divider()
                                                                        PronunciationView(pronunciations[index])
                                                                }
                                                        }
                                                        if let definition = unihanDefinition?.definition {
                                                                Divider()
                                                                HStack {
                                                                        Text(verbatim: "英文")
                                                                        Text.separator
                                                                        Text(verbatim: definition).font(.body)
                                                                        Spacer()
                                                                }
                                                        }
                                                }
                                                .block()
                                                .id(topID)
                                        }
                                        if let word = yingWaaEntries.first?.word {
                                                VStack(spacing: 2) {
                                                        HStack {
                                                                Text(verbatim: word)
                                                                Text(verbatim: "《英華分韻撮要》")
                                                                Text(verbatim: "衛三畏 (Samuel Wells Williams)　廣州　1856").opacity(0.66)
                                                                Spacer()
                                                        }
                                                        .font(.copilot)
                                                        VStack {
                                                                ForEach(yingWaaEntries.indices, id: \.self) { index in
                                                                        if (index != 0) {
                                                                                Divider()
                                                                        }
                                                                        YingWaaFanWanView(entry: yingWaaEntries[index])
                                                                }
                                                        }
                                                        .block()
                                                }
                                        }
                                        if let word = choHokEntries.first?.word {
                                                VStack(spacing: 2) {
                                                        HStack {
                                                                Text(verbatim: word)
                                                                Text(verbatim: "《初學粵音切要》")
                                                                Text(verbatim: "湛約翰 (John Chalmers)　香港　1855").opacity(0.66)
                                                                Spacer()
                                                        }
                                                        .font(.copilot)
                                                        VStack {
                                                                ForEach(choHokEntries.indices, id: \.self) { index in
                                                                        if (index != 0) {
                                                                                Divider()
                                                                        }
                                                                        ChoHokYuetYamCitYiuView(entry: choHokEntries[index])
                                                                }
                                                        }
                                                        .block()
                                                }
                                        }
                                        if let word = fanWanEntries.first?.word {
                                                VStack(spacing: 2) {
                                                        HStack {
                                                                Text(verbatim: word)
                                                                Text(verbatim: "《分韻撮要》")
                                                                Text(verbatim: "佚名　清初　廣州府").opacity(0.66)
                                                                Spacer()
                                                        }
                                                        .font(.copilot)
                                                        VStack {
                                                                ForEach(fanWanEntries.indices, id: \.self) { index in
                                                                        if (index != 0) {
                                                                                Divider()
                                                                        }
                                                                        FanWanCuetYiuView(entry: fanWanEntries[index])
                                                                }
                                                        }
                                                        .block()
                                                }
                                        }
                                        if let word = gwongWanEntries.first?.word {
                                                VStack(spacing: 2) {
                                                        HStack {
                                                                Text(verbatim: word)
                                                                Text(verbatim: "《大宋重修廣韻》")
                                                                Text(verbatim: "陳彭年等　北宋").opacity(0.66)
                                                                Spacer()
                                                        }
                                                        .font(.copilot)
                                                        VStack {
                                                                ForEach(gwongWanEntries.indices, id: \.self) { index in
                                                                        if (index != 0) {
                                                                                Divider()
                                                                        }
                                                                        GwongWanView(entry: gwongWanEntries[index])
                                                                }
                                                        }
                                                        .block()
                                                }
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
