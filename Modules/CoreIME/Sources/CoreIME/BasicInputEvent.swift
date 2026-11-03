import CommonExtensions

/// A single virtual key together with the keyboard case used when it was entered.
public struct BasicInputEvent: Hashable, Sendable {

        /// The virtual key entered by the user.
        public let key: VirtualInputKey

        /// The keyboard case at the time of input, including caps lock.
        public let `case`: KeyboardCase

        /// Whether the keyboard case is uppercased or caps locked.
        public var isCapitalized: Bool { self.case.isCapitalized }

        /// Creates an event preserving the supplied key and keyboard case.
        /// - Parameters:
        ///   - key: The virtual key entered by the user.
        ///   - case: The keyboard case at the time of input.
        public init(key: VirtualInputKey, `case`: KeyboardCase) {
                self.key = key
                self.case = `case`
        }

        /// Creates an event using uppercased or lowercased keyboard case.
        /// - Parameters:
        ///   - key: The virtual key entered by the user.
        ///   - isCapitalized: `true` selects `.uppercased`; `false` selects `.lowercased`.
        public init(key: VirtualInputKey, isCapitalized: Bool) {
                self.key = key
                self.case = isCapitalized ? .uppercased : .lowercased
        }
}

extension Array where Element == BasicInputEvent {
        /// Builds preview text with tone-letter input normalized to tone digits.
        ///
        /// Single `v`, `x`, and `q` keys become `1`, `2`, and `3`;
        /// adjacent matching pairs become `4`, `5`, and `6`.
        /// Other letters retain their event's case.
        /// A space follows each tone digit or non-letter key when more input remains.
        /// - Returns: The normalized preview, or an empty string for an empty array.
        public func normalizedPreviewMark() -> String {
                let inputLength = count
                var result = String()
                result.reserveCapacity(inputLength * 2)
                var index = 0
                while index < inputLength {
                        let event = self[index]
                        let isPaired: Bool = (index + 1 < inputLength) && (event.key == self[index + 1].key)
                        if isPaired {
                                let replacement: VirtualInputKey? = switch event.key {
                                case .letterV: VirtualInputKey.number4
                                case .letterX: VirtualInputKey.number5
                                case .letterQ: VirtualInputKey.number6
                                default: nil
                                }
                                if let replacement {
                                        result.append(replacement.character)
                                        index += 2
                                        if index < inputLength {
                                                result.append(Character.space)
                                        }
                                        continue
                                }
                        }
                        let matched: VirtualInputKey? = switch event.key {
                        case .letterV: VirtualInputKey.number1
                        case .letterX: VirtualInputKey.number2
                        case .letterQ: VirtualInputKey.number3
                        case let key where key.isLetter.negative: key
                        default: nil
                        }
                        index += 1
                        if let matched {
                                result.append(matched.character)
                                if index < inputLength {
                                        result.append(Character.space)
                                }
                        } else {
                                result.append(event.isCapitalized ? event.key.text.uppercased() : event.key.text)
                        }
                }
                return result
        }
}
