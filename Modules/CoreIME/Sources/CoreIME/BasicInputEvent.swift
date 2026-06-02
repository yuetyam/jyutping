import CommonExtensions

public struct BasicInputEvent: Hashable, Sendable {

        public let key: VirtualInputKey
        public let `case`: KeyboardCase

        /// Is not lowercased
        public var isCapitalized: Bool { self.case.isCapitalized }

        public init(key: VirtualInputKey, `case`: KeyboardCase) {
                self.key = key
                self.case = `case`
        }

        public init(key: VirtualInputKey, isCapitalized: Bool) {
                self.key = key
                self.case = isCapitalized ? .uppercased : .lowercased
        }
}

extension Array where Element == BasicInputEvent {
        public func previewMarkNormalized() -> String {
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
