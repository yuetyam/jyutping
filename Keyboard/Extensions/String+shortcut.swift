extension String {
        var shortcut: Int64 {
                let jyutpings: [String] = self.components(separatedBy: " ")
                let initials: String = jyutpings.reduce("") { (result, jyutping) -> String in
                        if let first = jyutping.first {
                                return result + String(first)
                        } else {
                                return result
                        }
                }
                return Int64(initials.hash)
        }
}
