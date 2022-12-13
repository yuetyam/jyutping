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
}
