import SwiftUI
import CommonExtensions
import CoreIME

struct CandidateDetailSummaryView: View {
        let candidate: Candidate
        let inputFrequency: Int64
        let latestDate: String?
        var body: some View {
                let isSingleCharacter = (candidate.text.count == 1)
                let isSuitableTextLength = (candidate.text.count <= 6)
                let isTextTransformed = (candidate.text != candidate.lexicon.text)
                VStack(alignment: .leading, spacing: 12) {
                        HStack {
                                HStack(alignment: .bottom) {
                                        RubyStackRow(text: candidate.lexicon.text, romanization: candidate.lexicon.romanization)
                                        if isSuitableTextLength && isTextTransformed {
                                                Text(verbatim: candidate.text).font(.title3).shallow()
                                        }
                                }
                                Spacer()
                                Speaker(candidate.lexicon.romanization)
                        }
                        if isSingleCharacter, let unicode = candidate.lexicon.text.first?.codePointNotation {
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
        }
}

private struct RubyStackRow: View {
        init(text: String, romanization: String) {
                let characters = text.map({ String($0) })
                let syllables = romanization.split(separator: Character.space).map({ String($0) })
                var units: Array<DisplayUnit> = []
                for index in characters.indices {
                        if let character = characters.fetch(index), let syllable = syllables.fetch(index) {
                                let unit = DisplayUnit(character: character, syllable: syllable, id: index)
                                units.append(unit)
                        }
                }
                self.units = units
                self.annotationLength = syllables.map(\.count).max() ?? 7
        }
        private let units: [DisplayUnit]
        private let annotationLength: Int
        var body: some View {
                HStack(spacing: 2) {
                        ForEach(units) { unit in
                                CharacterSyllableView(unit: unit, annotationLength: annotationLength)
                        }
                }
        }
}
private struct DisplayUnit: Hashable, Identifiable {
        let character: String
        let syllable: String
        let id: Int
}
private struct CharacterSyllableView: View {
        init(unit: DisplayUnit, annotationLength: Int) {
                self.character = unit.character
                self.annotation = {
                        let shortAmount = (annotationLength - unit.syllable.count)
                        guard shortAmount > 0 else { return unit.syllable }
                        guard shortAmount > 1 else { return String.space + unit.syllable }
                        let trailing = (shortAmount / 2)
                        let leading = (shortAmount - trailing)
                        return String(repeating: Character.space, count: leading) + unit.syllable + String(repeating: Character.space, count: trailing)
                }()
        }
        private let character: String
        private let annotation: String
        var body: some View {
                VStack(spacing: -2) {
                        Text(verbatim: annotation)
                                .lineLimit(1)
                                .minimumScaleFactor(0.2)
                                .font(.footnote)
                                .monospaced()
                        Text(verbatim: character)
                                .lineLimit(1)
                                .minimumScaleFactor(0.2)
                                .font(.title)
                                .padding(.horizontal, 2)
                }
                .frame(width: 36)
        }
}
