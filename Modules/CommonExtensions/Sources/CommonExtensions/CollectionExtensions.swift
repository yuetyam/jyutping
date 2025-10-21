extension Sequence where Element: Hashable {
        /// Returns a new Array with the unique elements of this Array, in the order of the first occurrence of each unique element.
        /// - Returns: A new Array with only the unique elements of this Array.
        /// - Complexity: O(*n*), where *n* is the length of the Array.
        public func distinct() -> [Element] {
                var set: Set<Element> = Set<Element>()
                return filter { set.insert($0).inserted }
        }
}

extension Sequence where Element: Collection {
        /// The number of elements in the flattened sequence of all nested collections. That is, the count of (Element of the Element).
        public var flattenedCount: Int {
                return reduce(0) { $0 + $1.count }
        }
}

extension Collection {
        public var isNotEmpty: Bool {
                return !isEmpty
        }
}

extension Sequence where Element: Equatable {
        public func notContains(_ element: Element) -> Bool {
                return !(contains(element))
        }
}

extension Comparable {
        /// Returns the value clamped to the given minimum and maximum bounds.
        ///
        /// - Parameters:
        ///   - min: The minimum allowable value.
        ///   - max: The maximum allowable value.
        /// - Returns: The value itself if it is between min and max, otherwise the nearest bound.
        ///
        /// - Precondition: min must be less than or equal to max.
        public func clamped(min lowerBound: Self, max upperBound: Self) -> Self {
                precondition(lowerBound <= upperBound, "lowerBound must be less than or equal to upperBound")
                return Swift.min(Swift.max(self, lowerBound), upperBound)
        }
}
