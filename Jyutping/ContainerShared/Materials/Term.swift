struct Term: Hashable, Identifiable {

        let name: String
        let romanization: String
        let comment: String?

        init(name: String, romanization: String, comment: String? = nil) {
                self.name = name
                self.romanization = romanization
                self.comment = comment
        }

        var id: String {
                return name + romanization
        }

        static func array(from text: String) -> [Term] {
                let lines: [String] = text.components(separatedBy: .newlines).map({ $0.trimmed() }).filter({ !$0.isEmpty })
                let items: [Term] = lines.map { line -> Term in
                        let parts: [String] = line.components(separatedBy: ",")
                        let name: String = parts.first ?? "?"
                        let romanization: String = parts.last ?? "?"
                        return Term(name: name, romanization: romanization)
                }
                return items
        }
}
