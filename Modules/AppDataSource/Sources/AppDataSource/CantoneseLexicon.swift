import Foundation
import SQLite3

public struct Pronunciation: Hashable {

        public let romanization: String
        public let homophones: [String]
        public let interpretation: String?
        public let collocations: [String]

        public init(romanization: String, homophones: [String] = [], interpretation: String? = nil, collocations: [String] = []) {
                self.romanization = romanization
                self.homophones = homophones
                self.interpretation = interpretation
                self.collocations = collocations
        }
}

public struct CantoneseLexicon: Hashable {

        public let text: String
        public let pronunciations: [Pronunciation]
        public let note: String?

        public init(text: String, pronunciations: [Pronunciation] = [], note: String? = nil) {
                self.text = text
                self.pronunciations = pronunciations
                self.note = note
        }

        /// Search CantoneseLexicon for the given text.
        ///
        /// Also convert simplified characters to traditional characters.
        ///
        /// - Parameter text: Cantonese text.
        /// - Returns: Text (converted) and the corresponding CantoneseLexicon.
        public static func search(text: String) -> CantoneseLexicon {
                let textCount: Int = text.count
                lazy var fallback: CantoneseLexicon = CantoneseLexicon(text: text)
                guard textCount > 0 else { return fallback }
                let matched = DataMaster.fetchRomanizations(for: text)
                guard matched.isEmpty else {
                        let pronunciations = matched.map { romanization -> Pronunciation in
                                guard textCount == 1 else { return Pronunciation(romanization: romanization) }
                                let homophones = DataMaster.fetchHomophones(for: romanization).filter({ $0 != text })
                                let collocations = DataMaster.fetchCollocations(word: text, romanization: romanization)
                                return Pronunciation(romanization: romanization, homophones: homophones, collocations: collocations)
                        }
                        return CantoneseLexicon(text: text, pronunciations: pronunciations)
                }
                let traditionalText: String = text.convertedS2T()
                let tryMatched = DataMaster.fetchRomanizations(for: traditionalText)
                guard tryMatched.isEmpty else {
                        let pronunciations = tryMatched.map { romanization -> Pronunciation in
                                guard textCount == 1 else { return Pronunciation(romanization: romanization) }
                                let homophones = DataMaster.fetchHomophones(for: romanization).filter({ $0 != traditionalText })
                                let collocations = DataMaster.fetchCollocations(word: text, romanization: romanization)
                                return Pronunciation(romanization: romanization, homophones: homophones, collocations: collocations)
                        }
                        return CantoneseLexicon(text: traditionalText, pronunciations: pronunciations)
                }
                guard textCount != 1 else { return fallback }
                lazy var chars: String = text
                lazy var fetches: [String] = []
                lazy var newText: String = ""
                while chars.isNotEmpty {
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
                let romanization: String = fetches.joined(separator: " ")
                let pronunciation = Pronunciation(romanization: romanization)
                return CantoneseLexicon(text: newText, pronunciations: [pronunciation])
        }

        private static func fetchLeading(for word: String) -> (romanization: String?, charCount: Int) {
                var chars: String = word
                var romanization: String? = nil
                var matchedCount: Int = 0
                while romanization == nil && !chars.isEmpty {
                        romanization = DataMaster.fetchRomanizations(for: chars).first
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

        /// Fetch Jyutping romanizations for text
        /// - Parameter text: Cantonese text
        /// - Returns: An Array of Jyutping
        static func fetchRomanizations(for text: String) -> [String] {
                var romanizations: [String] = []
                let query = "SELECT romanization FROM jyutpingtable WHERE word = '\(text)';"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK else { return romanizations }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let romanization: String = String(cString: sqlite3_column_text(statement, 0))
                        romanizations.append(romanization)
                }
                return romanizations
        }

        /// Fetch homophone characters
        /// - Parameter romanization: Jyutping romanization syllable
        /// - Returns: Homophone characters
        static func fetchHomophones(for romanization: String) -> [String] {
                var homophones: [String] = []
                let query = "SELECT word FROM jyutpingtable WHERE romanization = '\(romanization)' LIMIT 11;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, query, -1, &statement, nil) == SQLITE_OK else { return homophones }
                while sqlite3_step(statement) == SQLITE_ROW {
                        let homophone: String = String(cString: sqlite3_column_text(statement, 0))
                        homophones.append(homophone)
                }
                return homophones
        }

        /// Fetch collocation words
        /// - Parameters:
        ///   - word: Cantonese character
        ///   - romanization: Jyutping
        /// - Returns: Collocation words
        static func fetchCollocations(word: String, romanization: String) -> [String] {
                let command: String = "SELECT collocation FROM collocationtable WHERE word = '\(word)' AND romanization = '\(romanization)' LIMIT 1;"
                var statement: OpaquePointer? = nil
                defer { sqlite3_finalize(statement) }
                guard sqlite3_prepare_v2(database, command, -1, &statement, nil) == SQLITE_OK else { return [] }
                guard sqlite3_step(statement) == SQLITE_ROW else { return [] }
                let text: String = String(cString: sqlite3_column_text(statement, 0))
                guard text != "X" else { return [] }
                let collocations: [String] = text.split(separator: ";").map({ $0.trimmingCharacters(in: .whitespaces) })
                return collocations
        }
}
