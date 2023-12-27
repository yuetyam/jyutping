import SwiftUI
import CoreIME

extension Font {
        static let keyFooter: Font = Font.system(size: 9)

        private(set) static var candidate: Font = candidateFont()
        static func updateCandidateFont(characterStandard: CharacterStandard? = nil) {
                candidate = candidateFont(characterStandard: characterStandard)
        }
        private static func candidateFont(characterStandard: CharacterStandard? = nil) -> Font {
                let standard: CharacterStandard = characterStandard ?? Options.characterStandard
                switch standard {
                case .traditional:
                        return Font.custom(Constant.PingFangHK, fixedSize: 20)
                case .hongkong:
                        return Font.custom(Constant.PingFangHK, fixedSize: 20)
                case .taiwan:
                        return Font.custom(Constant.PingFangTC, fixedSize: 20)
                case .simplified:
                        return Font.custom(Constant.PingFangSC, fixedSize: 20)
                }
        }

        static let romanization: Font = Font.system(size: 12)
        static let tone: Font = Font.system(size: 10)


        // MARK: - Input Key

        static let letterInputKeyCompact: Font = Font.system(size: 24)
        static let dualLettersInputKeyCompact: Font = Font.system(size: 18)
}
