import SwiftUI
import CommonExtensions
import CoreIME

struct DetailInspectingView: View {
        @EnvironmentObject private var context: KeyboardViewController
        @State private var isTextTransformed: Bool = false
        @State private var isSingleCharacter: Bool = false
        @State private var inputFrequency: Int64 = 0
        @State private var latestDate: String? = nil
        var body: some View {
                let candidate = context.inspectingCandidate
                VStack(spacing: 0) {
                        ZStack {
                                Text("SettingsView.NavigationBar.HintText").font(.footnote).shallow()
                                HStack {
                                        NavigationLeadingBackButton()
                                        Spacer()
                                        NavigationTrailingExpansionButton().hidden()
                                }
                        }
                        .frame(height: PresetConstant.buttonLength)
                        ScrollView(.vertical) {
                                LazyVStack(alignment: .leading, spacing: 16) {
                                        switch candidate.lexicon.type {
                                        case .text, .composed:
                                                Text(verbatim: candidate.text).font(.title).padding()
                                        case .emoji, .symbol:
                                                SymbolCandidateDetailView(candidate: candidate)
                                        case .cantonese:
                                                VStack(alignment: .leading, spacing: 12) {
                                                        HStack {
                                                                HStack(alignment: .bottom) {
                                                                        RubyStackRow(text: candidate.lexicon.text, romanization: candidate.lexicon.romanization)
                                                                        if isTextTransformed {
                                                                                Text(verbatim: candidate.text).font(.title3).shallow()
                                                                        }
                                                                }
                                                                Spacer()
                                                                // TODO: Speaker
                                                        }
                                                        if isSingleCharacter, let unicode = candidate.lexicon.text.first?.codePointsText {
                                                                HStack(spacing: 2) {
                                                                        Text(verbatim: "Unicode")
                                                                        Text.separator
                                                                        Text(verbatim: unicode).monospaced().textSelection(.enabled)
                                                                }
                                                                .font(.footnote)
                                                        }
                                                        HStack(spacing: 2) {
                                                                Text("DetailInspectingView.Summary.InputCount")
                                                                Text.separator
                                                                Text(verbatim: inputFrequency.description).monospacedDigit()
                                                        }
                                                        .font(.footnote)
                                                        if let latestDate {
                                                                HStack(spacing: 2) {
                                                                        Text("DetailInspectingView.Summary.Latest")
                                                                        Text.separator
                                                                        Text(verbatim: latestDate).monospacedDigit()
                                                                }
                                                                .font(.footnote)
                                                        }
                                                }
                                                .padding(8)
                                                .background(Material.regular, in: RoundedRectangle(cornerRadius: 20))
                                                .padding(.horizontal, 10)
                                                .padding(.top, 8)
                                                if inputFrequency > 0 {
                                                        Menu {
                                                                Button(role: .destructive) {
                                                                        AudioFeedback.deleted()
                                                                        context.triggerHapticFeedback()
                                                                        InputMemory.forget(candidate.lexicon)
                                                                        inputFrequency = 0
                                                                        latestDate = nil
                                                                } label: {
                                                                        Label("DetailInspectingView.ForgetCandidate.ButtonTitle", systemImage: "trash")
                                                                }
                                                        } label: {
                                                                if #available(iOS 26.0, *) {
                                                                        HStack {
                                                                                Spacer()
                                                                                Text("DetailInspectingView.ForgetCandidate.ButtonTitle").foregroundStyle(Color.red)
                                                                                Spacer()
                                                                        }
                                                                        .padding(.vertical, 10)
                                                                        .glassEffect()
                                                                        .contentShape(.rect)
                                                                } else {
                                                                        HStack {
                                                                                Spacer()
                                                                                Text("DetailInspectingView.ForgetCandidate.ButtonTitle").foregroundStyle(Color.red)
                                                                                Spacer()
                                                                        }
                                                                        .padding(.vertical, 10)
                                                                        .background(Material.regular, in: .capsule)
                                                                        .contentShape(.rect)
                                                                }
                                                        }
                                                        .padding(.horizontal, 10)
                                                }
                                        }
                                }
                        }
                }
                .task {
                        isTextTransformed = (candidate.text != candidate.lexicon.text)
                        isSingleCharacter = (candidate.text.count == 1)
                        let inspected = InputMemory.inspect(lexicon: candidate.lexicon)
                        if inspected.frequency > 0 {
                                inputFrequency = inspected.frequency
                                latestDate = convert(latest: inspected.latest)
                        }
                }
        }

        private func convert(latest: Int64) -> String {
                let timestamp: TimeInterval = Double(latest) / 1000.0
                let date = Date(timeIntervalSince1970: timestamp)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let formattedDate = dateFormatter.string(from: date)
                return formattedDate
        }
}

private struct RubyStackRow: View {
        init(text: String, romanization: String) {
                let characters = text.map({ String($0) })
                let syllables = romanization.split(separator: Character.space).map({ String($0) })
                var mapped: Array<(character: String, syllable: String)> = []
                for index in characters.indices {
                        if let character = characters.fetch(index), let syllable = syllables.fetch(index) {
                                mapped.append((character, syllable))
                        }
                }
                self.units = mapped
        }
        private let units: Array<(character: String, syllable: String)>
        var body: some View {
                HStack(spacing: 1) {
                        ForEach(units.indices, id: \.self) { index in
                                CharacterSyllableView(unit: units[index])
                        }
                }
        }
}
private struct CharacterSyllableView: View {
        let unit: (character: String, syllable: String)
        var body: some View {
                VStack(spacing: -2) {
                        Text(verbatim: unit.syllable.isEmpty ? String.space : unit.syllable)
                                .lineLimit(1)
                                .minimumScaleFactor(0.2)
                                .font(.footnote)
                                .padding(.leading, 2)
                        Text(verbatim: unit.character)
                                .lineLimit(1)
                                .minimumScaleFactor(0.2)
                                .font(.title)
                }
                .frame(width: 32)
        }
}

private struct SymbolCandidateDetailView: View {
        let candidate: Candidate
        var body: some View {
                VStack(alignment: .leading, spacing: 16) {
                        HStack {
                                Text(verbatim: candidate.text).font(.largeTitle)
                                Spacer()
                        }
                        HStack(spacing: 2) {
                                Text(verbatim: "Unicode")
                                Text.separator
                                Text(verbatim: candidate.text.map(\.codePointsText).joined(separator: ", ")).monospaced().textSelection(.enabled)
                        }
                        .font(.footnote)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
                .background(Material.regular, in: RoundedRectangle(cornerRadius: 20))
                .padding(10)
        }
}
