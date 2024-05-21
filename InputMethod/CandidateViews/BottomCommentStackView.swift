import SwiftUI
import CommonExtensions

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
                                BottomCommentUnitView(unit: units[index], toneStyle: toneStyle, shouldModifyToneColor: shouldModifyToneColor, syllableViewSize: syllableViewSize)
                        }
                }
        }
}

private struct BottomCommentUnitView: View {
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
