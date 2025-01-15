import SwiftUI

@available(iOS 16.0, *)
@available(macOS 13.0, *)
struct OnsetGridView: View {
        private let columnHeaders: [String] = ["塞音、擦音", "塞音、擦音", "鼻音", "擦音", "近音"]
        var body: some View {
                Grid(horizontalSpacing: 8, verticalSpacing: 12) {
                        GridRow {
                                Color.clear.frame(width: 90, height: 40) // top-left empty cell
                                ForEach(columnHeaders.indices, id: \.self) { index in
                                        ColumnHeaderCell(headerText: columnHeaders[index])
                                }
                        }
                        GridRow {
                                RowHeaderCell(headerText: "脣音")
                                OnsetElementCell(onset: "b", ipa: "[ p ]", word: "巴", syllable: "baa1")
                                OnsetElementCell(onset: "p", ipa: "[ pʰ ]", word: "趴", syllable: "paa1")
                                OnsetElementCell(onset: "m", ipa: "[ m ]", word: "媽", syllable: "maa1")
                                OnsetElementCell(onset: "f", ipa: "[ f ]", word: "花", syllable: "faa1")
                                PlaceholderCell()
                        }
                        GridRow {
                                RowHeaderCell(headerText: "齦音")
                                OnsetElementCell(onset: "d", ipa: "[ t ]", word: "打", syllable: "daa2")
                                OnsetElementCell(onset: "t", ipa: "[ tʰ ]", word: "他", syllable: "taa1")
                                OnsetElementCell(onset: "n", ipa: "[ n ]", word: "拿", syllable: "naa4")
                                PlaceholderCell()
                                OnsetElementCell(onset: "l", ipa: "[ l ]", word: "啦", syllable: "laa1")
                        }
                        GridRow {
                                RowHeaderCell(headerText: "軟腭音、喉音")
                                OnsetElementCell(onset: "g", ipa: "[ k ]", word: "家", syllable: "gaa1")
                                OnsetElementCell(onset: "k", ipa: "[ kʰ ]", word: "卡", syllable: "kaa1")
                                OnsetElementCell(onset: "ng", ipa: "[ ŋ ]", word: "牙", syllable: "ngaa4")
                                OnsetElementCell(onset: "h", ipa: "[ h ]", word: "蝦", syllable: "haa1")
                                PlaceholderCell()
                        }
                        GridRow {
                                RowHeaderCell(headerText: "脣化軟顎音")
                                OnsetElementCell(onset: "gw", ipa: "[ kʷ ]", word: "瓜", syllable: "gwaa1")
                                OnsetElementCell(onset: "kw", ipa: "[ kʷʰ ]", word: "夸", syllable: "kwaa1")
                                PlaceholderCell()
                                PlaceholderCell()
                                OnsetElementCell(onset: "w", ipa: "[ w ]", word: "蛙", syllable: "waa1")
                        }
                        GridRow {
                                RowHeaderCell(headerText: "噝音、硬顎音")
                                OnsetElementCell(onset: "z", ipa: "t͡s~t͡ʃ", word: "渣", syllable: "zaa1")
                                OnsetElementCell(onset: "c", ipa: "t͡sʰ~t͡ʃʰ", word: "叉", syllable: "caa1")
                                PlaceholderCell()
                                OnsetElementCell(onset: "s", ipa: "s~ʃ", word: "沙", syllable: "saa1")
                                OnsetElementCell(onset: "j", ipa: "[ j ]", word: "也", syllable: "jaa5")
                        }
                }
        }
}

#Preview {
        if #available(iOS 16.0, macOS 13.0, *) {
                OnsetGridView()
        }
}

@available(iOS 16.0, *)
@available(macOS 13.0, *)
private struct OnsetElementCell: View {
        let onset: String
        let ipa: String
        let word: String
        let syllable: String
        var body: some View {
                HStack(spacing: 8) {
                        VStack(spacing: 2) {
                                Text(verbatim: onset).font(.title2)
                                Text(verbatim: ipa)
                        }
                        VStack(spacing: 2) {
                                VStack(spacing: 0) {
                                        Text(verbatim: syllable).font(.footnote)
                                        Text(verbatim: word).font(.master)
                                }
                                Speaker(syllable)
                        }
                }
                .frame(width: 90, height: 80)
                .background(.background, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
}

private struct ColumnHeaderCell: View {
        let headerText: String
        var body: some View {
                Text(verbatim: headerText).font(.copilot).frame(width: 90, height: 40, alignment: .bottom)
        }
}
private struct RowHeaderCell: View {
        let headerText: String
        var body: some View {
                Text(verbatim: headerText).font(.copilot).frame(width: 90, height: 80, alignment: .trailing)
        }
}
private struct PlaceholderCell: View {
        var body: some View {
                Color.clear.frame(width: 90, height: 80)
        }
}
