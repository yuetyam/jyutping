import Foundation
import SQLite3

public struct Response: Hashable {

        public let text: String
        public let romanizations: [String]

        public init(text: String, romanizations: [String] = []) {
                self.text = text
                self.romanizations = romanizations
        }
}

public struct Lookup {

        private static let database: OpaquePointer? = {
                guard let path: String = Bundle.module.path(forResource: "lookup", ofType: "sqlite3") else { return nil }
                var db: OpaquePointer?
                if sqlite3_open_v2(path, &db, SQLITE_OPEN_READONLY, nil) == SQLITE_OK {
                        return db
                } else {
                        return nil
                }
        }()

        /// Search Romanization for word
        /// - Parameter text: word
        /// - Returns: Array of Romanization matched the input word
        public static func look(for text: String) -> [String] {
                guard !text.isEmpty else { return [] }
                let matched = match(for: text)
                guard matched.isEmpty else { return matched }
                guard text.count != 1 else { return [] }

                var chars: String = text
                var fetches: [String] = []
                while !chars.isEmpty {
                        let leading = fetchLeading(for: chars)
                        if let romanization: String = leading.romanization {
                                fetches.append(romanization)
                                let length: Int = max(1, leading.charCount)
                                chars = String(chars.dropFirst(length))
                        } else {
                                fetches.append("?")
                                chars = String(chars.dropFirst())
                        }
                }
                guard !fetches.isEmpty else { return [] }
                let suggestion: String = fetches.joined(separator: " ")
                return [suggestion]
        }

        /// Search Romanization for the given text.
        ///
        /// Also convert simplified characters to traditional characters.
        ///
        /// - Parameter text: Word to search
        /// - Returns: Text (converted) & Array of Romanization
        public static func search(for text: String) -> Response {
                lazy var fallback: Response = Response(text: text)
                guard !text.isEmpty else { return fallback }
                let matched = match(for: text)
                guard matched.isEmpty else { return Response(text: text, romanizations: matched) }
                let traditionalText: String = convert(from: text)
                let tryMatched = match(for: traditionalText)
                guard tryMatched.isEmpty else {
                        return Response(text: traditionalText, romanizations: tryMatched)
                }
                guard text.count != 1 else { return fallback }

                lazy var chars: String = text
                lazy var fetches: [String] = []
                lazy var newText: String = ""
                while !chars.isEmpty {
                        let leading = fetchLeading(for: chars)
                        lazy var traditionalChars: String = convert(from: chars)
                        lazy var tryLeading = fetchLeading(for: traditionalChars)
                        if let romanization: String = leading.romanization {
                                fetches.append(romanization)
                                let length: Int = max(1, leading.charCount)
                                newText += chars.dropLast(chars.count - length)
                                chars = String(chars.dropFirst(length))
                        } else if let tryRomanization: String = tryLeading.romanization {
                                fetches.append(tryRomanization)
                                let length: Int = max(1, tryLeading.charCount)
                                newText += traditionalChars.dropLast(traditionalChars.count - length)
                                chars = String(chars.dropFirst(length))
                        } else {
                                if let first = chars.first {
                                        newText += String(first)
                                }
                                fetches.append("?")
                                chars = String(chars.dropFirst())
                        }
                }
                guard !fetches.isEmpty else { return fallback }
                let suggestion: String = fetches.joined(separator: " ")
                return Response(text: newText, romanizations: [suggestion])
        }

        private static func fetchLeading(for word: String) -> (romanization: String?, charCount: Int) {
                var chars: String = word
                var romanization: String? = nil
                var matchedCount: Int = 0
                while romanization == nil && !chars.isEmpty {
                        romanization = match(for: chars).first
                        matchedCount = chars.count
                        chars = String(chars.dropLast())
                }
                guard let matched: String = romanization else {
                        return (nil, 0)
                }
                return (matched, matchedCount)
        }

        private static func match(for text: String) -> [String] {
                var romanizations: [String] = []
                let queryString = "SELECT romanization FROM lookuptable WHERE word = '\(text)';"
                var queryStatement: OpaquePointer? = nil
                defer {
                        sqlite3_finalize(queryStatement)
                }
                if sqlite3_prepare_v2(database, queryString, -1, &queryStatement, nil) == SQLITE_OK {
                        while sqlite3_step(queryStatement) == SQLITE_ROW {
                                let romanization: String = String(cString: sqlite3_column_text(queryStatement, 0))
                                romanizations.append(romanization)
                        }
                }
                return romanizations
        }

        /// Convert simplified characters to traditional
        /// - Parameter text: Simplified characters
        /// - Returns: Traditional characters
        private static func convert(from text: String) -> String {
                let transformed: String? = text.applyingTransform(StringTransform("Simplified-Traditional"), reverse: false)
                return transformed ?? text
        }
}
