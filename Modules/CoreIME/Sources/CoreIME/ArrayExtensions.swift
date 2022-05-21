extension Array where Element: Hashable {

        /// Returns a new Array with the unique elements of this Array, in the order of the first occurrence of each unique element.
        /// - Returns: A new Array with only the unique elements of this Array.
        /// - Complexity: O(*n*), where *n* is the length of the Array.
        func uniqued() -> [Element] {
                var set: Set<Element> = Set<Element>()
                return filter { set.insert($0).inserted }
        }
}
