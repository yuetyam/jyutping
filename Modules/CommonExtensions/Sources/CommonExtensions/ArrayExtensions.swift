extension Array {

        /// Safely access element by index
        /// - Parameter index: Index
        /// - Returns: An Element if index is compatible, otherwise nil.
        public func fetch(_ index: Int) -> Element? {
                guard index >= 0 && index < self.count else { return nil }
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
