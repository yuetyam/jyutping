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
