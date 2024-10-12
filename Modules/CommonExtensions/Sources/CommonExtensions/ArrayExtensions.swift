extension Array where Element: Hashable {

        /// Returns a new Array with the unique elements of this Array, in the order of the first occurrence of each unique element.
        /// - Returns: A new Array with only the unique elements of this Array.
        /// - Complexity: O(*n*), where *n* is the length of the Array.
        public func uniqued() -> [Element] {
                var set: Set<Element> = Set<Element>()
                return filter { set.insert($0).inserted }
        }

        /// Returns a new Array with the unique elements of this Array, in the order of the first occurrence of each unique element.
        /// - Returns: A new Array with only the unique elements of this Array.
        /// - Complexity: O(*n*), where *n* is the length of the Array.
        public func distinct() -> [Element] { uniqued() }
}

extension Array {

        /// Safely access element by index
        /// - Parameter index: Index
        /// - Returns: An Element if index is compatible, otherwise nil.
        public func fetch(_ index: Int) -> Element? {
                let isSafe: Bool = index >= 0 && index < self.count
                guard isSafe else { return nil }
                return self[index]
        }

        /// Split array into sub-array
        /// - Parameter size: The capacity of every sub-array
        /// - Returns: An array of sub-array
        public func chunked(size: Int) -> [[Element]] {
                return stride(from: 0, to: count, by: size).map {
                        Array(self[$0 ..< Swift.min($0 + size, count)])
                }
        }
}

extension Array where Element: Equatable {
        public func notContains(_ element: Element) -> Bool {
                return !(self.contains(element))
        }
}
