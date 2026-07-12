extension Sequence where Element: Numeric {
        /// Computes the sum of all elements in the sequence.
        /// - Returns: The sum of all elements. Returns the additive identity (e.g., `0`) if the sequence is empty.
        public var summation: Element {
                return reduce(.zero, +)
        }
}

extension BinaryInteger {
        /// Convert to Int64
        /// - Returns: Converted Int64 value
        public func toInt64() -> Int64 {
                return Int64(self)
        }
}

extension RandomAccessCollection where Element == Int {

        /// Combines the elements as base-100 digits using wrapping arithmetic.
        ///
        /// For example, `[20, 21, 22]` produces `202122`. An empty collection produces `0`.
        /// If the result exceeds the range of `Int` (aka. `Int64`), arithmetic wraps instead of trapping.
        /// - Returns: The base-100 representation of the collection.
        public func radix100Overflowed() -> Int {
                return reduce(0, { $0 &* 100 &+ $1 })
        }

        /// Combines the elements as decimal digits using wrapping arithmetic.
        ///
        /// For example, `[2, 3, 4]` produces `234`. An empty collection produces `0`.
        /// If the result exceeds the range of `Int` (aka. `Int64`), arithmetic wraps instead of trapping.
        /// - Returns: The decimal representation of the collection.
        public func decimalOverflowed() -> Int {
                return reduce(0, { $0 &* 10 &+ $1 })
        }
}
