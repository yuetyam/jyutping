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
