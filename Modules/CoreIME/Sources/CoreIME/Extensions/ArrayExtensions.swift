extension Array where Element: Hashable {

        /// Returns a new Array with the unique elements of this Array, in the order of the first occurrence of each unique element.
        /// - Returns: A new Array with only the unique elements of this Array.
        /// - Complexity: O(*n*), where *n* is the length of the Array.
        func uniqued() -> [Element] {
                var set: Set<Element> = Set<Element>()
                return filter { set.insert($0).inserted }
        }

        /// Safely access element by index
        /// - Parameter index: Index
        /// - Returns: An Element if index is compatible, otherwise nil.
        func fetch(_ index: Int) -> Element? {
                let isSafe: Bool = index >= 0 && index < self.count
                guard isSafe else { return nil }
                return self[index]
        }
}
