/// For Cangjie/Quick/Stroke Reverse Lookup
struct ShapeLexicon: Hashable, Comparable {

        /// Cantonese word
        let text: String

        /// User input
        let input: String

        /// Complexity, the count of Cangjie/Quick/Stroke code
        let complex: Int

        /// Rank. Smaller is preferred.
        let order: Int

        // Equatable
        static func ==(lhs: ShapeLexicon, rhs: ShapeLexicon) -> Bool {
                return lhs.text == rhs.text
        }

        // Hashable
        func hash(into hasher: inout Hasher) {
                hasher.combine(text)
        }

        // Comparable
        static func < (lhs: ShapeLexicon, rhs: ShapeLexicon) -> Bool {
                guard lhs.complex == rhs.complex else { return lhs.complex < rhs.complex }
                return lhs.order < rhs.order
        }
}
