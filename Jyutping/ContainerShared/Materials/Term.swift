struct Term: Hashable, Identifiable {

        let name: String
        let romanization: String

        var id: String {
                return name + romanization
        }
}
