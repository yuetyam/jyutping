extension Candidate {

        static let specialMarks: [String: String] = {

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
                        "YouTube",
                        "Canton",
                        "Cantonese",
                        "Cantonia"
                ]

                let keys: [String] = values.map({ $0.lowercased() })
                let dict: [String: String] = Dictionary(uniqueKeysWithValues: zip(keys, values))
                return dict
        }()
}

