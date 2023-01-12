struct Term: Hashable, Identifiable {

        let name: String
        let romanization: String
        let emoji: String?
        let comment: String?

        init(name: String, romanization: String, emoji: String? = nil, comment: String? = nil) {
                self.name = name
                self.romanization = romanization
                self.emoji = emoji
                self.comment = comment
        }

        var id: String {
                return name + romanization
        }

        static func array(from text: String) -> [Term] {
                let lines: [String] = text.components(separatedBy: .newlines).map({ $0.trimmingCharacters(in: .whitespaces) }).filter({ !$0.isEmpty })
                let items: [Term?] = lines.map { line -> Term? in
                        let parts: [String] = line.components(separatedBy: ",")
                        switch parts.count {
                        case 0, 1:
                                return nil
                        case 2:
                                let name: String = parts[0]
                                let romanization: String = parts[1]
                                return Term(name: name, romanization: romanization)
                        case 3:
                                let name: String = parts[0]
                                let romanization: String = parts[1]
                                let third: String = parts[2]
                                if third.count == 1 {
                                        return Term(name: name, romanization: romanization, emoji: third)
                                } else {
                                        return Term(name: name, romanization: romanization, comment: third)
                                }
                        default:
                                let name: String = parts[0]
                                let romanization: String = parts[1]
                                let emoji: String = parts[2]
                                let comment: String = parts[3]
                                return Term(name: name, romanization: romanization, emoji: emoji, comment: comment)
                        }
                }
                return items.compactMap({ $0 })
        }
}
