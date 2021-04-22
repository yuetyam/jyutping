extension String {
        var shortcut: Int64 {
                let syllables: [String] = self.components(separatedBy: " ")
                let initials: String = syllables.reduce("") { (result, syllable) -> String in
                        if let first = syllable.first {
                                return result + String(first)
                        } else {
                                return result
                        }
                }
                return Int64(initials.hash)
        }
}
