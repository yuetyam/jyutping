import SwiftUI
import Combine
import CommonExtensions

struct BottomCommentStackView: View {
        init(text: String, romanization: String, toneStyle: ToneDisplayStyle, shallowTone: Bool, compatibleMode: Bool) {
                let characters = text.map({ String($0) })
                let syllables = romanization.split(separator: Character.space).map({ String($0) })
                var units: [StackUnit] = []
                for index in characters.indices {
                        let character: String = characters.fetch(index) ?? String.empty
                        let syllable: String = syllables.fetch(index) ?? String.empty
                        let unit = StackUnit(character: character, syllable: syllable)
                        units.append(unit)
                }
                self.units = units
                self.toneStyle = toneStyle
                self.shallowTone = shallowTone
                self.syllableViewSize = AppSettings.syllableViewSize
                self.compatibleMode = compatibleMode
        }
        private let units: [StackUnit]
        private let toneStyle: ToneDisplayStyle
        private let shallowTone: Bool
        private let syllableViewSize: CGSize
        private let compatibleMode: Bool
        var body: some View {
                HStack(alignment: .firstTextBaseline, spacing: 1) {
                        ForEach(units.indices, id: \.self) { index in
                                BottomCommentUnitView(unit: units[index], toneStyle: toneStyle, shallowTone: shallowTone, syllableViewSize: syllableViewSize, compatibleMode: compatibleMode)
                        }
                }
        }
}

private struct BottomCommentUnitView: View {
        let unit: StackUnit
        let toneStyle: ToneDisplayStyle
        let shallowTone: Bool
        let syllableViewSize: CGSize
        let compatibleMode: Bool
        var body: some View {
                switch toneStyle {
                case .normal:
                        VStack(spacing: 2) {
                                Text(verbatim: unit.character)
                                        .font(.candidate)
                                        .padding(.trailing, 2)
                                        .frame(maxWidth: .infinity)
                                RomanizationLabel(syllable: unit.syllable, toneStyle: toneStyle, shallowTone: shallowTone, compatibleMode: compatibleMode, size: syllableViewSize)
                        }
                case .noTones:
                        VStack(spacing: 2) {
                                Text(verbatim: unit.character)
                                        .font(.candidate)
                                        .frame(maxWidth: .infinity)
                                RomanizationLabel(syllable: unit.syllable, toneStyle: toneStyle, shallowTone: shallowTone, compatibleMode: compatibleMode, size: syllableViewSize)
                        }
                case .superscript:
                        VStack(spacing: 2) {
                                Text(verbatim: unit.character)
                                        .font(.candidate)
                                        .padding(.trailing, 2)
                                        .frame(maxWidth: .infinity)
                                RomanizationLabel(syllable: unit.syllable, toneStyle: toneStyle, shallowTone: shallowTone, compatibleMode: compatibleMode, size: syllableViewSize)
                        }
                case .subscript:
                        VStack(spacing: 2) {
                                Text(verbatim: unit.character)
                                        .font(.candidate)
                                        .padding(.trailing, 2)
                                        .frame(maxWidth: .infinity)
                                RomanizationLabel(syllable: unit.syllable, toneStyle: toneStyle, shallowTone: shallowTone, compatibleMode: compatibleMode, size: syllableViewSize)
                        }
                }
        }
}
