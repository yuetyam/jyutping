extension Collection where Element: Collection {

        /// Count of (Element of the Element)
        public var subelementCount: Int {
                return self.map(\.count).reduce(0, +)
        }
}

extension Collection {
        public var isNotEmpty: Bool {
                return !(self.isEmpty)
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
