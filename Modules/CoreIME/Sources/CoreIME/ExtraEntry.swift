import CommonExtensions

struct ExtraEntry: Hashable {

        /// Cantonese
        let word: String

        /// Jyutping
        let romanization: String

        /// Length of the letter-only romanization (no tones & no spaces)
        let complex: Int

        /// Conjoined code of the letter-only romanization (no tones & no spaces)
        let spell: Int

        /// Conjoined keypad code of the letter-only romanization (no tones & no spaces)
        let nineKey: Int

        // Equatable
        static func ==(lhs: ExtraEntry, rhs: ExtraEntry) -> Bool {
                return lhs.word == rhs.word && lhs.romanization == rhs.romanization
        }

        // Hashable
        func hash(into hasher: inout Hasher) {
                hasher.combine(word)
                hasher.combine(romanization)
        }
}

extension ExtraEntry {
        static func search<T: RandomAccessCollection<VirtualInputKey>>(keys: T) -> [Lexicon] {
                let spell: Int = keys.conjoinedCode
                let letterCount: Int = keys.count
                lazy var input: String = keys.map(\.text).joined()
                return entries.filter({ $0.spell == spell && $0.complex == letterCount })
                        .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: input, mark: $0.romanization.strippedTones()) })
        }
        static func nineKeySearch<T: RandomAccessCollection<Combo>>(combos: T) -> [Lexicon] {
                let code: Int = combos.decimalCombinedCode
                let letterCount: Int = combos.count
                return entries.filter({ $0.nineKey == code && $0.complex == letterCount })
                        .map({ Lexicon(text: $0.word, romanization: $0.romanization, input: $0.romanization.latinLetterOnly(), mark: $0.romanization.strippedTones()) })
        }
}

private extension ExtraEntry {
        static let entries: Set<ExtraEntry> = [
                ExtraEntry(word: "啤", romanization: "bi1", complex: 2, spell: 2128, nineKey: 24),
                ExtraEntry(word: "啤女", romanization: "bi4 neoi2", complex: 6, spell: 212833243428, nineKey: 246364),
                ExtraEntry(word: "啤仔", romanization: "bi1 zai2", complex: 5, spell: 2128452028, nineKey: 24924),
                ExtraEntry(word: "啤啤", romanization: "bi4 bi1", complex: 4, spell: 21282128, nineKey: 2424),
                ExtraEntry(word: "啤啤車", romanization: "bi4 bi1 ce1", complex: 6, spell: 212821282224, nineKey: 242423),
                ExtraEntry(word: "啤啤牀", romanization: "bi4 bi1 cong4", complex: 8, spell: 2128212822343326, nineKey: 24242664),
                ExtraEntry(word: "啤啤女", romanization: "bi4 bi1 neoi2", complex: 8, spell: 2128212833243428, nineKey: 24246364),
                ExtraEntry(word: "啤啤衫", romanization: "bi4 bi1 saam1", complex: 8, spell: 2128212838202032, nineKey: 24247226),
                ExtraEntry(word: "啤啤仔", romanization: "bi4 bi1 zai2", complex: 7, spell: 21282128452028, nineKey: 2424924),
                ExtraEntry(word: "生啤啤", romanization: "saang1 bi4 bi1", complex: 9, spell: 382020332621282128, nineKey: 722642424),
                ExtraEntry(word: "欸", romanization: "e6", complex: 1, spell: 24, nineKey: 3),
                ExtraEntry(word: "誒", romanization: "e6", complex: 1, spell: 24, nineKey: 3),
                ExtraEntry(word: "欸", romanization: "ei6", complex: 2, spell: 2428, nineKey: 34),
                ExtraEntry(word: "誒", romanization: "ei6", complex: 2, spell: 2428, nineKey: 34),
                ExtraEntry(word: "䊦", romanization: "et3", complex: 2, spell: 2439, nineKey: 38),
                ExtraEntry(word: "𬖋", romanization: "et3", complex: 2, spell: 2439, nineKey: 38),
                ExtraEntry(word: "覅", romanization: "fiu3", complex: 3, spell: 252840, nineKey: 348),
                ExtraEntry(word: "𡠍", romanization: "fiu3", complex: 3, spell: 252840, nineKey: 348),
                ExtraEntry(word: "𧟰", romanization: "fiu3", complex: 3, spell: 252840, nineKey: 348),
                ExtraEntry(word: "𳄮", romanization: "he3", complex: 2, spell: 2724, nineKey: 43),
                ExtraEntry(word: "𠺪", romanization: "he3", complex: 2, spell: 2724, nineKey: 43),
                ExtraEntry(word: "嗗", romanization: "gut6", complex: 3, spell: 264039, nineKey: 488),
                ExtraEntry(word: "摑", romanization: "gwaak3", complex: 5, spell: 2642202030, nineKey: 49225),
                ExtraEntry(word: "嚕", romanization: "lu1", complex: 2, spell: 3140, nineKey: 58),
                ExtraEntry(word: "𠁣", romanization: "ngi1", complex: 3, spell: 332628, nineKey: 644),
                ExtraEntry(word: "𠃛", romanization: "nget1", complex: 4, spell: 33262439, nineKey: 6438),
                ExtraEntry(word: "𠸊", romanization: "tap1", complex: 3, spell: 392035, nineKey: 827),
                ExtraEntry(word: "扤", romanization: "at1", complex: 2, spell: 2039, nineKey: 28),
                ExtraEntry(word: "扤實", romanization: "at1 sat6", complex: 5, spell: 2039382039, nineKey: 28728),
                ExtraEntry(word: "扤死貓", romanization: "at1 sei2 maau1", complex: 9, spell: 203938242832202040, nineKey: 287346228),
                ExtraEntry(word: "嗒", romanization: "dep1", complex: 3, spell: 232435, nineKey: 337),
                ExtraEntry(word: "嗒嘢", romanization: "dep1 je5", complex: 5, spell: 2324352924, nineKey: 33753),
                ExtraEntry(word: "嗒糖", romanization: "dep1 tong4", complex: 7, spell: 23243539343326, nineKey: 3378664),
                ExtraEntry(word: "嗒落有味", romanization: "dep1 lok6 jau5 mei6", complex: 12, spell: 6338101551689960828, nineKey: 337565528634),
                ExtraEntry(word: "嘰咭", romanization: "gi1 gat6", complex: 5, spell: 2628262039, nineKey: 44428),
                ExtraEntry(word: "嘰嘰咭咭", romanization: "gi1 gi1 gat6 gat6", complex: 10, spell: 7835884188329710423, nineKey: 4444428428),
                ExtraEntry(word: "嘰哩咕嚕", romanization: "gi1 li1 gu1 lu1", complex: 8, spell: 2628312826403140, nineKey: 44544858),
                ExtraEntry(word: "喲", romanization: "jo1", complex: 2, spell: 2934, nineKey: 56),
                ExtraEntry(word: "哎喲", romanization: "aai1 jo1", complex: 5, spell: 2020282934, nineKey: 22456),
                ExtraEntry(word: "哎喲", romanization: "ai1 jo1", complex: 4, spell: 20282934, nineKey: 2456),
                ExtraEntry(word: "𠸉", romanization: "kak1", complex: 3, spell: 302030, nineKey: 525),
                ExtraEntry(word: "嘞𠸉", romanization: "lak1 kak1", complex: 6, spell: 312030302030, nineKey: 525525),
                ExtraEntry(word: "嘞嘞𠸉𠸉", romanization: "lak1 lak1 kak1 kak1", complex: 12, spell: 3636023504964717390, nineKey: 525525525525),
                ExtraEntry(word: "哩", romanization: "li1", complex: 2, spell: 3128, nineKey: 54),
                ExtraEntry(word: "哩個", romanization: "li1 go3", complex: 4, spell: 31282634, nineKey: 5446),
                ExtraEntry(word: "花哩綠", romanization: "faa1 li1 luk1", complex: 8, spell: 2520203128314030, nineKey: 32254585),
                ExtraEntry(word: "𡃈", romanization: "kwak1", complex: 4, spell: 30422030, nineKey: 5925),
                ExtraEntry(word: "𡃈", romanization: "kwaak1", complex: 5, spell: 3042202030, nineKey: 59225),
                ExtraEntry(word: "𡁸", romanization: "kwaak1", complex: 5, spell: 3042202030, nineKey: 59225),
                ExtraEntry(word: "𠽤嚦𡃈嘞", romanization: "kik1 lik1 kwak1 lak1", complex: 13, spell: 7661401431458112094, nineKey: 5455455925525),
                ExtraEntry(word: "𠽤嚦𡃈嘞", romanization: "kik1 lik1 kwaak1 laak1", complex: 15, spell: 4686176365263980782, nineKey: 545545592255225),
                ExtraEntry(word: "𠵇", romanization: "keu4", complex: 3, spell: 302440, nineKey: 538),
                ExtraEntry(word: "𠺫", romanization: "leu1", complex: 3, spell: 312440, nineKey: 538),
                ExtraEntry(word: "𠵇𠺫", romanization: "keu4 leu1", complex: 6, spell: 302440312440, nineKey: 538538),
                ExtraEntry(word: "𠮩𠹌", romanization: "liu1 lang1", complex: 7, spell: 31284031203326, nineKey: 5485264),
                ExtraEntry(word: "啤", romanization: "pe1", complex: 2, spell: 3524, nineKey: 73),
                ExtraEntry(word: "啤牌", romanization: "pe1 paai2", complex: 6, spell: 352435202028, nineKey: 737224),
                ExtraEntry(word: "𢚖", romanization: "ti4", complex: 2, spell: 3928, nineKey: 84),
                ExtraEntry(word: "發𢚖騰", romanization: "faat3 ti4 tang4", complex: 10, spell: 6755295319129651710, nineKey: 3228848264),
                ExtraEntry(word: "啫", romanization: "zoe1", complex: 3, spell: 453424, nineKey: 963),
                ExtraEntry(word: "啫啫", romanization: "zoe1 zoe1", complex: 6, spell: 453424453424, nineKey: 963963),
                ExtraEntry(word: "啫啫煲", romanization: "zoe1 zoe1 bou1", complex: 9, spell: 453424453424213440, nineKey: 963963268),
        ]
}
