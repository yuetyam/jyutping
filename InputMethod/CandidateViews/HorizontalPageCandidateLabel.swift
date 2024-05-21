import SwiftUI
import CoreIME
import CommonExtensions

struct ModifiedToneColorCommentLabel: View {
        let syllable: String
        var body: some View {
                let phone = syllable.filter(\.isLowercaseBasicLatinLetter)
                let tone = syllable.filter(\.isCantoneseToneDigit)
                HStack(spacing: 0) {
                        Text(verbatim: phone)
                        Text(verbatim: tone).opacity(0.66)
                }
                .font(.comment)
                .lineLimit(1)
                .minimumScaleFactor(0.4)
        }
}
struct SuperscriptCommentLabel: View {
        let syllable: String
        let shouldModifyToneColor: Bool
        var body: some View {
                let phone = syllable.filter(\.isLowercaseBasicLatinLetter)
                let tone = syllable.filter(\.isCantoneseToneDigit)
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text(verbatim: phone).font(.comment)
                        Text(verbatim: tone).font(.commentTone).opacity(shouldModifyToneColor ? 0.66 : 1)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.4)
        }
}
struct SubscriptCommentLabel: View {
        let syllable: String
        let shouldModifyToneColor: Bool
        var body: some View {
                let phone = syllable.filter(\.isLowercaseBasicLatinLetter)
                let tone = syllable.filter(\.isCantoneseToneDigit)
                HStack(alignment: .lastTextBaseline, spacing: 0) {
                        Text(verbatim: phone).font(.comment)
                        Text(verbatim: tone).font(.commentTone).opacity(shouldModifyToneColor ? 0.66 : 1)
                }
                .lineLimit(1)
                .minimumScaleFactor(0.4)
        }
}

struct StackUnit {
        let character: String
        let syllable: String
}

struct TopCommentStackUnitView: View {
        init(unit: StackUnit, toneStyle: ToneDisplayStyle, shouldModifyToneColor: Bool, syllableViewSize: CGSize) {
                self.unit = unit
                self.toneStyle = toneStyle
                self.shouldModifyToneColor = shouldModifyToneColor
                self.syllableViewSize = syllableViewSize
        }
        private let unit: StackUnit
        private let toneStyle: ToneDisplayStyle
        private let shouldModifyToneColor: Bool
        private let syllableViewSize: CGSize
        var body: some View {
                switch toneStyle {
                case .normal where shouldModifyToneColor:
                        VStack(spacing: 2) {
                                ModifiedToneColorCommentLabel(syllable: unit.syllable)
                                        .frame(width: syllableViewSize.width, height: syllableViewSize.height)
                                Text(verbatim: unit.character)
                                        .font(.candidate)
                                        .padding(.trailing, 2)
                                        .frame(maxWidth: .infinity)
                        }
                case .normal:
                        VStack(spacing: 2) {
                                Text(verbatim: unit.syllable)
                                        .font(.comment)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.4)
                                        .frame(width: syllableViewSize.width, height: syllableViewSize.height)
                                Text(verbatim: unit.character)
                                        .font(.candidate)
                                        .padding(.trailing, 2)
                                        .frame(maxWidth: .infinity)
                        }
                case .noTones:
                        VStack(spacing: 2) {
                                Text(verbatim: unit.syllable.filter(\.isLowercaseBasicLatinLetter))
                                        .font(.comment)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.4)
                                        .frame(width: syllableViewSize.width, height: syllableViewSize.height)
                                Text(verbatim: unit.character)
                                        .font(.candidate)
                                        .frame(maxWidth: .infinity)
                        }
                case .superscript:
                        VStack(spacing: 2) {
                                SuperscriptCommentLabel(syllable: unit.syllable, shouldModifyToneColor: shouldModifyToneColor)
                                        .frame(width: syllableViewSize.width, height: syllableViewSize.height)
                                Text(verbatim: unit.character)
                                        .font(.candidate)
                                        .padding(.trailing, 2)
                                        .frame(maxWidth: .infinity)
                        }
                case .subscript:
                        VStack(spacing: 2) {
                                SubscriptCommentLabel(syllable: unit.syllable, shouldModifyToneColor: shouldModifyToneColor)
                                        .frame(width: syllableViewSize.width, height: syllableViewSize.height)
                                Text(verbatim: unit.character)
                                        .font(.candidate)
                                        .padding(.trailing, 2)
                                        .frame(maxWidth: .infinity)
                        }
                }
        }
}
struct BottomCommentStackUnitView: View {
        init(unit: StackUnit, toneStyle: ToneDisplayStyle, shouldModifyToneColor: Bool, syllableViewSize: CGSize) {
                self.unit = unit
                self.toneStyle = toneStyle
                self.shouldModifyToneColor = shouldModifyToneColor
                self.syllableViewSize = syllableViewSize
        }
        private let unit: StackUnit
        private let toneStyle: ToneDisplayStyle
        private let shouldModifyToneColor: Bool
        private let syllableViewSize: CGSize
        var body: some View {
                switch toneStyle {
                case .normal where shouldModifyToneColor:
                        VStack(spacing: 2) {
                                Text(verbatim: unit.character)
                                        .font(.candidate)
                                        .padding(.trailing, 2)
                                        .frame(maxWidth: .infinity)
                                ModifiedToneColorCommentLabel(syllable: unit.syllable)
                                        .frame(width: syllableViewSize.width, height: syllableViewSize.height)
                        }
                case .normal:
                        VStack(spacing: 2) {
                                Text(verbatim: unit.character)
                                        .font(.candidate)
                                        .padding(.trailing, 2)
                                        .frame(maxWidth: .infinity)
                                Text(verbatim: unit.syllable)
                                        .font(.comment)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.4)
                                        .frame(width: syllableViewSize.width, height: syllableViewSize.height)
                        }
                case .noTones:
                        VStack(spacing: 2) {
                                Text(verbatim: unit.character)
                                        .font(.candidate)
                                        .frame(maxWidth: .infinity)
                                Text(verbatim: unit.syllable.filter(\.isLowercaseBasicLatinLetter))
                                        .font(.comment)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.4)
                                        .frame(width: syllableViewSize.width, height: syllableViewSize.height)
                        }
                case .superscript:
                        VStack(spacing: 2) {
                                Text(verbatim: unit.character)
                                        .font(.candidate)
                                        .padding(.trailing, 2)
                                        .frame(maxWidth: .infinity)
                                SuperscriptCommentLabel(syllable: unit.syllable, shouldModifyToneColor: shouldModifyToneColor)
                                        .frame(width: syllableViewSize.width, height: syllableViewSize.height)
                        }
                case .subscript:
                        VStack(spacing: 2) {
                                Text(verbatim: unit.character)
                                        .font(.candidate)
                                        .padding(.trailing, 2)
                                        .frame(maxWidth: .infinity)
                                SubscriptCommentLabel(syllable: unit.syllable, shouldModifyToneColor: shouldModifyToneColor)
                                        .frame(width: syllableViewSize.width, height: syllableViewSize.height)
                        }
                }
        }
}

struct TopCommentStackView: View {
        init(text: String, romanization: String, toneStyle: ToneDisplayStyle, shouldModifyToneColor: Bool) {
                let characters = text.map({ String($0) })
                let syllables = romanization.split(separator: Character.space).map({ String($0) })
                var units: [StackUnit] = []
                for index in 0..<characters.count {
                        let character: String = characters.fetch(index) ?? String.empty
                        let syllable: String = syllables.fetch(index) ?? String.empty
                        let unit = StackUnit(character: character, syllable: syllable)
                        units.append(unit)
                }
                self.units = units
                self.toneStyle = toneStyle
                self.shouldModifyToneColor = shouldModifyToneColor
        }
        private let units: [StackUnit]
        private let toneStyle: ToneDisplayStyle
        private let shouldModifyToneColor: Bool
        private let syllableViewSize: CGSize = AppSettings.syllableViewSize
        var body: some View {
                HStack(alignment: .lastTextBaseline, spacing: 1) {
                        ForEach(0..<units.count, id: \.self) { index in
                                TopCommentStackUnitView(unit: units[index], toneStyle: toneStyle, shouldModifyToneColor: shouldModifyToneColor, syllableViewSize: syllableViewSize)
                        }
                }
        }
}
struct BottomCommentStackView: View {
        init(text: String, romanization: String, toneStyle: ToneDisplayStyle, shouldModifyToneColor: Bool) {
                let characters = text.map({ String($0) })
                let syllables = romanization.split(separator: Character.space).map({ String($0) })
                var units: [StackUnit] = []
                for index in 0..<characters.count {
                        let character: String = characters.fetch(index) ?? String.empty
                        let syllable: String = syllables.fetch(index) ?? String.empty
                        let unit = StackUnit(character: character, syllable: syllable)
                        units.append(unit)
                }
                self.units = units
                self.toneStyle = toneStyle
                self.shouldModifyToneColor = shouldModifyToneColor
        }
        private let units: [StackUnit]
        private let toneStyle: ToneDisplayStyle
        private let shouldModifyToneColor: Bool
        private let syllableViewSize: CGSize = AppSettings.syllableViewSize
        var body: some View {
                HStack(alignment: .firstTextBaseline, spacing: 1) {
                        ForEach(0..<units.count, id: \.self) { index in
                                BottomCommentStackUnitView(unit: units[index], toneStyle: toneStyle, shouldModifyToneColor: shouldModifyToneColor, syllableViewSize: syllableViewSize)
                        }
                }
        }
}

struct HorizontalPageCandidateLabel: View {
        init(isHighlighted: Bool, index: Int, candidate: DisplayCandidate, commentStyle: CommentDisplayStyle, toneStyle: ToneDisplayStyle, toneColor: ToneDisplayColor) {
                self.label = (index == 9) ? "0" : "\(index + 1)"
                self.labelOpacity = isHighlighted ? 1 : 0.75
                self.candidate = candidate
                self.commentStyle = commentStyle
                self.toneStyle = toneStyle
                self.shouldModifyToneColor = toneColor != .normal
        }
        private let label: String
        private let labelOpacity: Double
        private let candidate: DisplayCandidate
        private let commentStyle: CommentDisplayStyle
        private let toneStyle: ToneDisplayStyle
        private let shouldModifyToneColor: Bool
        var body: some View {
                switch candidate.candidate.type {
                case .cantonese:
                        switch commentStyle {
                        case .top:
                                HStack(alignment: .lastTextBaseline, spacing: 2) {
                                        Text(verbatim: label).font(.label).opacity(labelOpacity)
                                        TopCommentStackView(text: candidate.text, romanization: candidate.comment!, toneStyle: toneStyle, shouldModifyToneColor: shouldModifyToneColor)
                                }
                        case .bottom:
                                HStack(alignment: .firstTextBaseline, spacing: 2) {
                                        Text(verbatim: label).font(.label).opacity(labelOpacity)
                                        BottomCommentStackView(text: candidate.text, romanization: candidate.comment!, toneStyle: toneStyle, shouldModifyToneColor: shouldModifyToneColor)
                                }
                        case .right:
                                HStack(spacing: 4) {
                                        Text(verbatim: label).font(.label).opacity(labelOpacity)
                                        Text(verbatim: candidate.text).font(.candidate)
                                        if let comment = candidate.comment {
                                                CommentLabel(comment, toneStyle: toneStyle, shouldModifyToneColor: shouldModifyToneColor)
                                        }
                                }
                        case .noComments:
                                HStack(spacing: 4) {
                                        Text(verbatim: label).font(.label).opacity(labelOpacity)
                                        Text(verbatim: candidate.text).font(.candidate)
                                }
                        }
                case .text:
                        HStack(spacing: 4) {
                                Text(verbatim: label).font(.label).opacity(labelOpacity)
                                Text(verbatim: candidate.text).font(.candidate)
                        }
                        .padding(.top, commentStyle == .top ? 8 : 0)
                        .padding(.bottom, commentStyle == .bottom ? 8 : 0)
                case .emoji, .emojiSequence, .symbol, .symbolSequence:
                        HStack(spacing: 4) {
                                Text(verbatim: label).font(.label).opacity(labelOpacity)
                                Text(verbatim: candidate.text).font(.candidate)
                                if let comment = candidate.comment {
                                        Text(verbatim: comment).font(.annotation)
                                }
                        }
                        .padding(.top, commentStyle == .top ? 8 : 0)
                        .padding(.bottom, commentStyle == .bottom ? 8 : 0)
                case .compose:
                        HStack(spacing: 4) {
                                Text(verbatim: label).font(.label).opacity(labelOpacity)
                                Text(verbatim: candidate.text).font(.candidate)
                                if let comment = candidate.comment {
                                        Text(verbatim: comment).font(.annotation).opacity(0.8)
                                }
                                if let secondaryComment = candidate.secondaryComment {
                                        Text(verbatim: secondaryComment).font(.annotation).opacity(0.8)
                                }
                        }
                }
        }
}
