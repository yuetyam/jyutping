extension Collection where Element: Collection {

        /// Count of (Element of the Element)
        public var subelementCount: Int {
                return self.map(\.count).reduce(0, +)
        }
}
