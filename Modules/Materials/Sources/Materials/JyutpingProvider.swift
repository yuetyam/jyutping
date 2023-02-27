import Foundation
import SQLite3

public struct JyutpingProvider {

        public struct Response: Hashable {

                public let text: String
                public let romanizations: [String]

                public init(text: String, romanizations: [String] = []) {
                        self.text = text
                        self.romanizations = romanizations
                }
        }

        /// Search Romanization for word
        /// - Parameter text: word
        /// - Returns: Array of Romanization matched the input word
        public static func lookup(text: String) -> [String] {
                guard DataMaster.isDatabaseReady else { return [] }
                guard !text.isEmpty else { return [] }
                let matched = DataMaster.matchRomanization(for: text)
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
                guard DataMaster.isDatabaseReady else { return Response(text: text) }
                lazy var fallback: Response = Response(text: text)
                guard !text.isEmpty else { return fallback }
                let matched = DataMaster.matchRomanization(for: text)
                guard matched.isEmpty else { return Response(text: text, romanizations: matched) }
                let traditionalText: String = text.convertedS2T()
                let tryMatched = DataMaster.matchRomanization(for: traditionalText)
                guard tryMatched.isEmpty else {
                        return Response(text: traditionalText, romanizations: tryMatched)
                }
                guard text.count != 1 else { return fallback }

                lazy var chars: String = text
                lazy var fetches: [String] = []
                lazy var newText: String = ""
                while !chars.isEmpty {
                        let leading = fetchLeading(for: chars)
                        lazy var traditionalChars: String = chars.convertedS2T()
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
                        romanization = DataMaster.matchRomanization(for: chars).first
                        matchedCount = chars.count
                        chars = String(chars.dropLast())
                }
                guard let matched: String = romanization else {
                        return (nil, 0)
                }
                return (matched, matchedCount)
        }
}

private extension DataMaster {

        /// Match Jyutping for text
        /// - Parameter text: Word
        /// - Returns: An Array of Jyutping
        static func matchRomanization(for text: String) -> [String] {
                var romanizations: [String] = []
                let queryString = "SELECT romanization FROM jyutpingtable WHERE word = '\(text)';"
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
}
