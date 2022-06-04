import Foundation
import SQLite3

/// Core IME Engine
public struct Lychee {

        /// SQLite3 database
        private(set) static var database: OpaquePointer? = {
                guard let path: String = Bundle.module.path(forResource: "lexicon", ofType: "sqlite3") else { return nil }
                var db: OpaquePointer?
                if sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK {
                        return db
                } else {
                        return nil
                }
        }()

        /// Connect SQLite3 database
        public static func connect() {
                guard let path: String = Bundle.module.path(forResource: "lexicon", ofType: "sqlite3") else { return }
                var db: OpaquePointer?
                if sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK {
                        database = db
                }
        }

        /// Close SQLite3 database
        public static func close() {
                sqlite3_close_v2(database)
        }
}


extension Lychee {

        public static func searchEmojis(for text: String) -> [Candidate] {
                // TODO: emoji search
                switch text {
                case "fai":
                        return [Candidate(emoji: "🫁", cantonese: "肺", romanization: "fai3", input: text)]
                case "hoenggong":
                        return [Candidate(emoji: "🇭🇰", cantonese: "香港", romanization: "hoeng1 gong2", input: text)]
                case "gaamgaai":
                        return [Candidate(emoji: "😅", cantonese: "尷尬", romanization: "gaam3 gaai3", input: text)]
                default:
                        return []
                }
        }
}


extension Lychee {


        /// Search special mark for text
        /// - Parameter text: Input text
        /// - Returns: Candidate, type == .specialMark
        public static func searchMark(for text: String) -> Candidate? {
                let key: String = text.lowercased()
                guard let markText = specialMarks[key] else { return nil }
                return Candidate(mark: markText)
        }

        private static let specialMarks: [String: String] = {
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

