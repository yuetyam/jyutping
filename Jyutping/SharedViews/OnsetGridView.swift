import SwiftUI

@available(iOS 16.0, *)
@available(macOS 13.0, *)
struct OnsetGridView: View {

        #if os(iOS)
        @Environment(\.horizontalSizeClass) var horizontalSize
        #endif

        private var horizontalSpacing: CGFloat {
                #if os(iOS)
                return (horizontalSize == .compact) ? 8 : 12
                #else
                return 12
                #endif
        }

        var body: some View {
                Grid(horizontalSpacing: horizontalSpacing, verticalSpacing: 12) {
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
                                OnsetElementCell(onset: "∅", ipa: "[   ]", word: "翳", syllable: "ai3")
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

#Preview {
        if #available(iOS 16.0, macOS 13.0, *) {
                OnsetGridView()
        }
}

@available(iOS 16.0, *)
@available(macOS 13.0, *)
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
                .background(Color.textBackgroundColor, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                #elseif os(iOS)
                .background(Color.textBackgroundColor(colorScheme: colorScheme), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                #else
                .background(.background, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                #endif
        }
}
