extension Optional {

        /// Whether the optional contains no value.
        public var isNil: Bool { self == nil }

        /// Whether the optional contains a value.
        public var isNotNil: Bool { self != nil }
}
