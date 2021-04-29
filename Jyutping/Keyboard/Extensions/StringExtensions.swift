extension String {
        var ping: Int64 {
                let useless: Set<Character> = Set("123456 ")
                let raw: String = self.filter { !useless.contains($0) }
                return Int64(raw.hash)
        }
        var prefix: Int64 {
                guard !self.isEmpty else { return Int64(self.hash) }
                guard let lastSyllable: String = self.components(separatedBy: " ").last else { return Int64(self.hash) }
                let useless: Set<Character> = Set("123456 ")
                let leading = self.dropLast(lastSyllable.count - 1)
                let rawPrefix: String = leading.filter { !useless.contains($0) }
                return Int64(rawPrefix.hash)
        }
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
