import Foundation
import Testing
@testable import CoreIME

@Suite("CoreIME string extensions")
struct StringExtensionsTests {

        @Test("compatible syllables use their mapped spellings", arguments: [
                ("", ""),
                ("nei", "nei"),
                ("ng", "ng"),
                ("yu", "yu"),
                ("aa", "a"),
                ("baa", "ba"),
                ("caa", "cha"),
                ("daa", "da"),
                ("faa", "fa"),
                ("gaa", "ga"),
                ("gwaa", "gwa"),
                ("haa", "ha"),
                ("jaa", "ya"),
                ("kaa", "ka"),
                ("kwaa", "kwa"),
                ("laa", "la"),
                ("maa", "ma"),
                ("naa", "na"),
                ("ngaa", "nga"),
                ("paa", "pa"),
                ("saa", "sha"),
                ("taa", "ta"),
                ("waa", "wa"),
                ("zaa", "zha"),
                ("caai", "chaai"),
                ("caam", "chaam"),
                ("jat", "yat"),
                ("jyu", "yu"),
                ("jyun", "yuen"),
                ("jyut", "yuet"),
                ("joeng", "yeung"),
                ("hoeng", "heung"),
                ("goeng", "geung"),
                ("zi", "zhi"),
                ("ci", "chi"),
                ("si", "shi"),
                ("zyu", "zhue"),
                ("cyun", "chuen"),
                ("syut", "shuet"),
                ("zoeng", "zheung"),
                ("coeng", "cheung"),
                ("soeng", "sheung"),
                ("zoe", "zhoe")
        ])
        func compatibleTransformation(input: String, expected: String) {
                #expect(input.compatibleTransformed == expected)
        }

        @Test("aliases and unmapped inputs remain unchanged", arguments: ["jo", "ca", "ja", "car", "cee", "cha", "zheng", "j", "z", "c", "s", "oeng", "nyu", "zyuoeng", "unknown", "JYU", "jyu1", "nei5 hou2"])
        func compatibleUnmappedInputs(input: String) {
                #expect(input.compatibleTransformed == input)
        }

        @Test("compatible mapping follows display spelling rules for regular source syllables")
        func compatibleSourceSyllables() throws {
                let resources = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().appending(path: "Preparing/Sources/Preparing/Resources")
                let core = try String(contentsOf: resources.appending(path: "syllable-core.txt"), encoding: .utf8)
                let lexicon = try String(contentsOf: resources.appending(path: "jyutping.txt"), encoding: .utf8)
                var syllables = Set(core.split(separator: "\n").compactMap({ line -> String? in
                        let columns = line.split(separator: "\t")
                        guard columns.count == 2 else { return nil }
                        return String(columns[1])
                }))
                for line in lexicon.split(separator: "\n") {
                        let columns = line.split(separator: "\t")
                        guard columns.count > 1 else { continue }
                        for syllable in columns[1].split(separator: " ") {
                                syllables.insert(syllable.filter({ $0 >= "a" && $0 <= "z" }))
                        }
                }
                syllables.remove("jo")
                #expect(syllables.isEmpty == false)
                for syllable in syllables {
                        let legacy = legacyCompatibleSpelling(syllable)
                        let expected = legacy.hasSuffix("aa") ? String(legacy.dropLast()) : legacy
                        #expect(syllable.compatibleTransformed == expected, "Syllable: \(syllable)")
                        #expect(syllable.compatibleTransformed.hasSuffix("aa") == false, "Syllable: \(syllable)")
                }
        }

        private func legacyCompatibleSpelling(_ syllable: String) -> String {
                if syllable == "jyu" { return "yu" }
                if syllable.hasPrefix("jyu") { return "yue" + syllable.dropFirst(3) }
                var modified = syllable.hasSuffix("oeng") ? (syllable.dropLast(4) + "eung") : syllable
                if syllable.hasPrefix("j") { return "y" + modified.dropFirst() }
                modified = modified.replacingOccurrences(of: "^(.+)yu", with: "$1ue", options: .regularExpression)
                if let initial = modified.first, "zcs".contains(initial) {
                        return String(initial) + "h" + modified.dropFirst()
                }
                return modified
        }

        @Test("tone conversion maps single and paired tone letters")
        func toneConversion() {
                #expect("gwongv".toneConverted() == "gwong1")
                #expect("gwongx".toneConverted() == "gwong2")
                #expect("gwongq".toneConverted() == "gwong3")
                #expect("gwongvv".toneConverted() == "gwong4")
                #expect("gwongxx".toneConverted() == "gwong5")
                #expect("gwongqq".toneConverted() == "gwong6")
                #expect("vxqvvxxqq".toneConverted() == "123456")
                #expect("vvvxxxqqq".toneConverted() == "415263")
                #expect("abc".toneConverted() == "abc")
                #expect("".toneConverted() == "")
        }

        @Test("mark formatting spaces nonletters")
        func markFormatting() {
                #expect("gwong2".markFormatted() == "gwong2 ")
                #expect("ngo5'aa3".markFormatted() == "ngo5 ' aa3 ")
                #expect("AaZz".markFormatted() == "AaZz")
                #expect("".markFormatted() == "")
        }
}
