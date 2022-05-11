extension Candidate {

        static let trademarks: [String: String] = {

                let values: [String] = [
                        "iOS",
                        "iPadOS",
                        "macOS",
                        "watchOS",
                        "tvOS",
                        "iPhone",
                        "iPad",
                        "iPod",
                        "iMac",
                        "MacBook",
                        "HomePod",
                        "AirPods",
                        "AirTag",
                        "iCloud",
                        "FaceTime",
                        "iMessage",
                        "SwiftUI",
                        "GitHub",
                        "PayPal",
                        "WhatsApp",
                        "YouTube"
                ]

                let keys: [String] = values.map({ $0.lowercased() })
                let combined = zip(keys, values)
                let dict: [String: String] = Dictionary(uniqueKeysWithValues: combined)
                return dict
        }()
}

