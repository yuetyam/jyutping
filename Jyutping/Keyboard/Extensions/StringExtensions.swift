import CommonExtensions

extension String {
        var ping: Int64 {
                return Int64(self.removedSpacesTones().hash)
        }
        var prefix: Int64 {
                guard !self.isEmpty else { return Int64(self.hash) }
                guard let lastSyllable: String = self.components(separatedBy: String.space).last else { return Int64(self.hash) }
                let leading: String = String(self.dropLast(lastSyllable.count - 1))
                let raw: String = leading.removedSpacesTones()
                return Int64(raw.hash)
        }
        var shortcut: Int64 {
                let syllables: [String] = self.components(separatedBy: String.space)
                let initials: String = syllables.reduce("") { (result, syllable) -> String in
                        if let first = syllable.first {
                                return result + String(first)
                        } else {
                                return result
                        }
                }
                return Int64(initials.hash)
        }

        /// A subsequence that only contains tones (1-6)
        var tones: String {
                return self.filter(\.isTone)
        }

        /// Remove all tones (1-6)
        /// - Returns: A subsequence that leaves off the tones.
        func removedTones() -> String {
                return self.filter({ !$0.isTone })
        }

        /// Remove all spaces and tones
        /// - Returns: A subsequence that leaves off the spaces and tones.
        func removedSpacesTones() -> String {
                return self.filter({ !$0.isSpaceOrTone })
        }

        var isLetters: Bool {
                return self.first?.isBasicLatinLetter ?? false
        }
}
