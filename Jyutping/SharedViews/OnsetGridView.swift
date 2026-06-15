import SwiftUI
import CommonExtensions

struct CompactOnsetGridView: View {
        var body: some View {
                Grid(horizontalSpacing: 4, verticalSpacing: 10) {
                        GridRow {
                                OnsetElementCell(onset: "b", ipa: "[ p ]", word: "跛", syllable: "bai1")
                                OnsetElementCell(onset: "p", ipa: "[ pʰ ]", word: "批", syllable: "pai1")
                                OnsetElementCell(onset: "m", ipa: "[ m ]", word: "銤", syllable: "mai1")
                                OnsetElementCell(onset: "f", ipa: "[ f ]", word: "輝", syllable: "fai1")
                        }
                        GridRow {
                                OnsetElementCell(onset: "d", ipa: "[ t ]", word: "低", syllable: "dai1")
                                OnsetElementCell(onset: "t", ipa: "[ tʰ ]", word: "梯", syllable: "tai1")
                                OnsetElementCell(onset: "n", ipa: "[ n ]", word: "泥", syllable: "nai4")
                                OnsetElementCell(onset: "l", ipa: "[ l ]", word: "犁", syllable: "lai4")
                        }
                        GridRow {
                                OnsetElementCell(onset: "g", ipa: "[ k ]", word: "雞", syllable: "gai1")
                                OnsetElementCell(onset: "k", ipa: "[ kʰ ]", word: "稽", syllable: "kai1")
                                OnsetElementCell(onset: "ng", ipa: "[ ŋ ]", word: "魏", syllable: "ngai6")
                                OnsetElementCell(onset: "h", ipa: "[ h ]", word: "系", syllable: "hai6")
                        }
                        GridRow {
                                OnsetElementCell(onset: "gw", ipa: "[ kʷ ]", word: "龜", syllable: "gwai1")
                                OnsetElementCell(onset: "kw", ipa: "[ kʷʰ ]", word: "虧", syllable: "kwai1")
                                OnsetElementCell(onset: "w", ipa: "[ w ]", word: "威", syllable: "wai1")
                                OnsetElementCell(onset: "∅", ipa: "[ ʔ ]", word: "翳", syllable: "ai3")
                        }
                        GridRow {
                                OnsetElementCell(onset: "z", ipa: "t͡s~t͡ʃ", word: "劑", syllable: "zai1")
                                OnsetElementCell(onset: "c", ipa: "t͡sʰ~t͡ʃʰ", word: "妻", syllable: "cai1")
                                OnsetElementCell(onset: "s", ipa: "s~ʃ", word: "犀", syllable: "sai1")
                                OnsetElementCell(onset: "j", ipa: "[ j ]", word: "曳", syllable: "jai6")
                        }
                }
        }
}

private struct OnsetElementCell: View {

        @Environment(\.horizontalSizeClass) private var horizontalSize

        #if os(iOS)
        @Environment(\.colorScheme) private var colorScheme
        #endif

        init(onset: String, ipa: String, word: String, syllable: String, poa: String = String.empty, moa: String = String.empty) {
                self.onset = onset
                self.ipa = ipa
                self.word = word
                self.syllable = syllable
                self.poa = poa
                self.moa = moa
        }
        private let onset: String
        private let ipa: String
        private let word: String
        private let syllable: String
        /// Place of articulation. 調音部位
        private let poa: String
        /// Manner of articulation. 調音方法
        private let moa: String

        var body: some View {
                let isCompact = (horizontalSize == .compact)
                ZStack {
                        ZStack(alignment: .topLeading) {
                                Color.clear
                                Text(verbatim: poa)
                                        .font(.caption2)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .opacity(isCompact ? 0 : 0.4)
                        }
                        .padding(2)
                        ZStack(alignment: .bottomLeading) {
                                Color.clear
                                Text(verbatim: moa)
                                        .font(.caption2)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .opacity(isCompact ? 0 : 0.4)
                        }
                        .padding(2)
                        HStack(spacing: 8) {
                                VStack(spacing: 2) {
                                        Text(verbatim: onset)
                                                #if os(macOS)
                                                .font(.title)
                                                #else
                                                .font(isCompact ? .title3 : .title2)
                                                #endif
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                        Text(verbatim: ipa)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                }
                                VStack(spacing: 2) {
                                        VStack(spacing: 0) {
                                                Text(verbatim: syllable)
                                                        .font(.footnote)
                                                        .lineLimit(1)
                                                        .minimumScaleFactor(0.5)
                                                Text(verbatim: word)
                                                        .font(.master)
                                                        .lineLimit(1)
                                                        .minimumScaleFactor(0.5)
                                        }
                                        Speaker(syllable)
                                }
                        }
                }
                .frame(height: 88)
                .frame(minWidth: 64, idealWidth: 94, maxWidth: 100)
                #if os(macOS)
                .stack(cornerRadius: 8)
                #else
                .stack(colorScheme: colorScheme, cornerRadius: 8)
                #endif
        }
}
private struct PlaceholderCell: View {
        var body: some View {
                Spacer()
                        .frame(height: 88)
                        .frame(minWidth: 64, idealWidth: 94, maxWidth: 100)
        }
}

struct OnsetGridView: View {
        var body: some View {
                Grid(horizontalSpacing: 8, verticalSpacing: 12) {
                        GridRow {
                                OnsetElementCell(onset: "b", ipa: "[ p ]", word: "跛", syllable: "bai1", poa: "雙脣音", moa: "爆發音")
                                OnsetElementCell(onset: "p", ipa: "[ pʰ ]", word: "批", syllable: "pai1", poa: "雙脣音", moa: "爆發音")
                                OnsetElementCell(onset: "m", ipa: "[ m ]", word: "銤", syllable: "mai1", poa: "雙脣音", moa: "鼻音")
                                OnsetElementCell(onset: "f", ipa: "[ f ]", word: "輝", syllable: "fai1", poa: "脣齒音", moa: "擦音")
                                PlaceholderCell()
                        }
                        GridRow {
                                OnsetElementCell(onset: "d", ipa: "[ t ]", word: "低", syllable: "dai1", poa: "齒齦音", moa: "爆發音")
                                OnsetElementCell(onset: "t", ipa: "[ tʰ ]", word: "梯", syllable: "tai1", poa: "齒齦音", moa: "爆發音")
                                OnsetElementCell(onset: "n", ipa: "[ n ]", word: "泥", syllable: "nai4", poa: "齒齦音", moa: "鼻音")
                                PlaceholderCell()
                                OnsetElementCell(onset: "l", ipa: "[ l ]", word: "犁", syllable: "lai4", poa: "齒齦音", moa: "邊近音")
                        }
                        GridRow {
                                OnsetElementCell(onset: "g", ipa: "[ k ]", word: "雞", syllable: "gai1", poa: "軟腭音", moa: "爆發音")
                                OnsetElementCell(onset: "k", ipa: "[ kʰ ]", word: "稽", syllable: "kai1", poa: "軟腭音", moa: "爆發音")
                                OnsetElementCell(onset: "ng", ipa: "[ ŋ ]", word: "魏", syllable: "ngai6", poa: "軟腭音", moa: "鼻音")
                                OnsetElementCell(onset: "h", ipa: "[ h ]", word: "系", syllable: "hai6", poa: "喉音", moa: "擦音")
                                PlaceholderCell()
                        }
                        GridRow {
                                OnsetElementCell(onset: "gw", ipa: "[ kʷ ]", word: "龜", syllable: "gwai1", poa: "脣化軟顎音", moa: "爆發音")
                                OnsetElementCell(onset: "kw", ipa: "[ kʷʰ ]", word: "虧", syllable: "kwai1", poa: "脣化軟顎音", moa: "爆發音")
                                PlaceholderCell()
                                PlaceholderCell()
                                OnsetElementCell(onset: "w", ipa: "[ w ]", word: "威", syllable: "wai1", poa: "脣化軟顎音", moa: "近音")
                        }
                        GridRow {
                                OnsetElementCell(onset: "z", ipa: "t͡s~t͡ʃ", word: "劑", syllable: "zai1", poa: "齒齦音", moa: "塞擦音")
                                OnsetElementCell(onset: "c", ipa: "t͡sʰ~t͡ʃʰ", word: "妻", syllable: "cai1", poa: "齒齦音", moa: "塞擦音")
                                PlaceholderCell()
                                OnsetElementCell(onset: "s", ipa: "s~ʃ", word: "犀", syllable: "sai1", poa: "齒齦音", moa: "擦音")
                                OnsetElementCell(onset: "j", ipa: "[ j ]", word: "曳", syllable: "jai6", poa: "硬顎音", moa: "近音")
                        }
                }
        }
}
