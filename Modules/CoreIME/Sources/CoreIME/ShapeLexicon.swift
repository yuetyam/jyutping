/// For Cangjie/Quick/Stroke Reverse Lookup
struct ShapeLexicon: Hashable, Comparable {

        /// Cantonese word
        let text: String

        /// User input
        let input: String

        /// Complexity, the length of the Cangjie/Quick/Stroke code.
        let complex: Int

        /// Rank; order. Smaller is preferred.
        let number: Int

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
                if lhs.complex == rhs.complex {
                        return lhs.number < rhs.number
                } else {
                        return lhs.complex < rhs.complex
                }
        }
}
