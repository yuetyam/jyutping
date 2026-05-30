import Foundation
import CommonExtensions

extension String {

        /// A subsequence that only contains tones (1-6)
        var tones: String {
                return self.filter(\.isCantoneseToneDigit)
        }

        /// Remove all tones (1-6)
        /// - Returns: A subsequence that leaves off tones.
        func removedTones() -> String {
                return self.filter(\.isCantoneseToneDigit.negative)
        }

        /// Remove all spaces
        /// - Returns: A subsequence that leaves off spaces.
        func removedSpaces() -> String {
                return self.filter(\.isSpace.negative)
        }

        /// Remove all spaces and tones
        /// - Returns: A subsequence that leaves off spaces and tones.
        func removedSpacesTones() -> String {
                return self.filter({ $0.isSpace.negative && $0.isCantoneseToneDigit.negative })
        }
}

private extension Character {
        static let letterV: Character = "v"
        static let letterX: Character = "x"
        static let letterQ: Character = "q"
        static let digit1 : Character = "1"
        static let digit2 : Character = "2"
        static let digit3 : Character = "3"
        static let digit4 : Character = "4"
        static let digit5 : Character = "5"
        static let digit6 : Character = "6"
}
extension StringProtocol {
        /// Transforms v/x/q to Cantonese tone digits
        /// - Returns: Converted text with digit tones
        public func toneConverted() -> String {
                var result = String()
                result.reserveCapacity(count)
                var iterator = makeIterator()
                var current = iterator.next()
                while let char = current {
                        let next = iterator.next()
                        switch (char, next) {
                        case (Character.letterV, Character.letterV):
                                result.append(Character.digit4)
                                current = iterator.next()
                        case (Character.letterX, Character.letterX):
                                result.append(Character.digit5)
                                current = iterator.next()
                        case (Character.letterQ, Character.letterQ):
                                result.append(Character.digit6)
                                current = iterator.next()
                        case (Character.letterV, _):
                                result.append(Character.digit1)
                                current = next
                        case (Character.letterX, _):
                                result.append(Character.digit2)
                                current = next
                        case (Character.letterQ, _):
                                result.append(Character.digit3)
                                current = next
                        default:
                                result.append(char)
                                current = next
                        }
                }
                return result
        }
}
extension StringProtocol {
        /// Inserts a space after any non-letter character
        /// - Returns: Formatted text for preview-mark
        public func markFormatted() -> String {
                var result = String()
                result.reserveCapacity(count * 2)
                for index in indices {
                        let character = self[index]
                        result.append(character)
                        if character.isBasicLatinLetter.negative && index < endIndex {
                                result.append(Character.space)
                        }
                }
                return result
        }
}
