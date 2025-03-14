extension Sequence where Element == Int {

        /// Sum numbers up
        /// - Returns: Summed
        var summation: Int {
                return self.reduce(0, +)
        }
}
