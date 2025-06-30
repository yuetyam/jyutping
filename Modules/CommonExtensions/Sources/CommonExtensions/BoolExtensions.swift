extension Bool {
        /// Not true
        public var negative: Bool {
                return !self
        }

        /// Performs the given action if the value is `true`.
        /// - Parameter action: The action to perform.
        public func then(_ action: () -> Void) {
                guard self else { return }
                action()
        }
}
