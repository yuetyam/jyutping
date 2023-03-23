extension Array where Element == Int {

        /// Sum elements up
        /// - Returns: Summed
        public var summation: Int {
                return self.reduce(0, +)
        }
}
