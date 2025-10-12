extension Sequence where Element: Numeric {
        /// Computes the sum of all elements in the sequence.
        /// - Returns: The sum of all elements. Returns the additive identity (e.g., `0`) if the sequence is empty.
        public var summation: Element {
                return reduce(.zero, +)
        }
}
