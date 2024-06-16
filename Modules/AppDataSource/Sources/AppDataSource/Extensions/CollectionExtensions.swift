extension Collection where Element: Collection {

        /// Count of (Element of the Element)
        var subelementCount: Int {
                return self.map(\.count).reduce(0, +)
        }
}

extension Collection {
        var isNotEmpty: Bool {
                return !(self.isEmpty)
        }
}
