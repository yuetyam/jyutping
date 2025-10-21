import SwiftUI
import CommonExtensions

struct CompactOnsetGridView: View {
        var body: some View {
                Grid(horizontalSpacing: 8, verticalSpacing: 12) {
                        GridRow {
                                OnsetElementCell(onset: "b", ipa: "[ p ]", word: "跛", syllable: "bai1")
                                OnsetElementCell(onset: "p", ipa: "[ pʰ ]", word: "批", syllable: "pai1")
                                OnsetElementCell(onset: "m", ipa: "[ m ]", word: "咪", syllable: "mai1")
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
                                OnsetElementCell(onset: "z", ipa: "t͡s~t͡ʃ", word: "擠", syllable: "zai1")
                                OnsetElementCell(onset: "c", ipa: "t͡sʰ~t͡ʃʰ", word: "妻", syllable: "cai1")
                                OnsetElementCell(onset: "s", ipa: "s~ʃ", word: "犀", syllable: "sai1")
                                OnsetElementCell(onset: "j", ipa: "[ j ]", word: "曳", syllable: "jai6")
                        }
                }
        }
}

private struct OnsetElementCell: View {

        #if os(iOS)
        @Environment(\.colorScheme) private var colorScheme
        #endif

        let onset: String
        let ipa: String
        let word: String
        let syllable: String

        var body: some View {
                HStack(spacing: 8) {
                        VStack(spacing: 2) {
                                Text(verbatim: onset)
                                        .font(.title2)
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
                .frame(height: 80)
                .frame(minWidth: 64, idealWidth: 90, maxWidth: 100)
                #if os(macOS)
                .stack()
                #else
                .stack(colorScheme: colorScheme)
                #endif
        }
}

struct OnsetGridView: View {
        private let columnHeaders: [String] = ["塞音、擦音", "塞音、擦音", "鼻音", "擦音", "近音"]
        var body: some View {
                Grid(horizontalSpacing: 8, verticalSpacing: 12) {
                        GridRow {
                                Spacer().frame(width: 75, height: 40) // top-left empty cell
                                ForEach(columnHeaders.indices, id: \.self) { index in
                                        ColumnHeaderCell(headerText: columnHeaders[index])
                                }
                        }
                        GridRow {
                                RowHeaderCell(headerText: "脣音")
                                OnsetElementCell(onset: "b", ipa: "[ p ]", word: "跛", syllable: "bai1")
                                OnsetElementCell(onset: "p", ipa: "[ pʰ ]", word: "批", syllable: "pai1")
                                OnsetElementCell(onset: "m", ipa: "[ m ]", word: "咪", syllable: "mai1")
                                OnsetElementCell(onset: "f", ipa: "[ f ]", word: "輝", syllable: "fai1")
                                PlaceholderCell()
                        }
                        GridRow {
                                RowHeaderCell(headerText: "齦音")
                                OnsetElementCell(onset: "d", ipa: "[ t ]", word: "低", syllable: "dai1")
                                OnsetElementCell(onset: "t", ipa: "[ tʰ ]", word: "梯", syllable: "tai1")
                                OnsetElementCell(onset: "n", ipa: "[ n ]", word: "泥", syllable: "nai4")
                                PlaceholderCell()
                                OnsetElementCell(onset: "l", ipa: "[ l ]", word: "犁", syllable: "lai4")
                        }
                        GridRow {
                                RowHeaderCell(headerText: "軟腭音、喉音")
                                OnsetElementCell(onset: "g", ipa: "[ k ]", word: "雞", syllable: "gai1")
                                OnsetElementCell(onset: "k", ipa: "[ kʰ ]", word: "稽", syllable: "kai1")
                                OnsetElementCell(onset: "ng", ipa: "[ ŋ ]", word: "魏", syllable: "ngai6")
                                OnsetElementCell(onset: "h", ipa: "[ h ]", word: "系", syllable: "hai6")
                                PlaceholderCell()
                        }
                        GridRow {
                                RowHeaderCell(headerText: "脣化軟顎音")
                                OnsetElementCell(onset: "gw", ipa: "[ kʷ ]", word: "龜", syllable: "gwai1")
                                OnsetElementCell(onset: "kw", ipa: "[ kʷʰ ]", word: "虧", syllable: "kwai1")
                                PlaceholderCell()
                                PlaceholderCell()
                                OnsetElementCell(onset: "w", ipa: "[ w ]", word: "威", syllable: "wai1")
                        }
                        GridRow {
                                RowHeaderCell(headerText: "噝音、硬顎音")
                                OnsetElementCell(onset: "z", ipa: "t͡s~t͡ʃ", word: "擠", syllable: "zai1")
                                OnsetElementCell(onset: "c", ipa: "t͡sʰ~t͡ʃʰ", word: "妻", syllable: "cai1")
                                PlaceholderCell()
                                OnsetElementCell(onset: "s", ipa: "s~ʃ", word: "犀", syllable: "sai1")
                                OnsetElementCell(onset: "j", ipa: "[ j ]", word: "曳", syllable: "jai6")
                        }
                }
        }
}

private struct ColumnHeaderCell: View {
        let headerText: String
        var body: some View {
                Text(verbatim: headerText)
                        .font(.copilot)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(height: 40, alignment: .bottom)
                        .frame(minWidth: 64, idealWidth: 90, maxWidth: 100)
        }
}
private struct RowHeaderCell: View {
        let headerText: String
        var body: some View {
                Text(verbatim: headerText)
                        .font(.copilot)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(width: 75, height: 80, alignment: .trailing)
        }
}
private struct PlaceholderCell: View {
        var body: some View {
                Spacer()
                        .frame(height: 80)
                        .frame(minWidth: 64, idealWidth: 90, maxWidth: 100)
        }
}
