import SwiftUI

struct TonesTable: View {

        @Environment(\.horizontalSizeClass) var horizontalSize
        private let inset: CGFloat = {
                if #available(iOS 14.0, *) {
                        return 64
                } else {
                        return 32
                }
        }()
        private var width: CGFloat {
                guard Device.isPad else {
                        return (UIScreen.main.bounds.width - inset) / 4.0
                }
                if horizontalSize == .compact {
                        return 80
                } else {
                        return 120
                }
        }

        private let tonesDescription: VStack = {
                VStack(spacing: 0) {
                        HStack {
                                Text(verbatim: "聲調之「上」應讀上聲 soeng5")
                                Speaker("soeng5")
                                Spacer()
                        }
                        HStack {
                                Text(verbatim: "而非去聲 soeng6")
                                Speaker("soeng6")
                                Spacer()
                        }
                }
        }()

        var body: some View {
                if #available(iOS 15.0, *) {
                        List {
                                Section {
                                        ForEach(dataSource.components(separatedBy: .newlines), id: \.self) {
                                                ToneCell($0, width: width)
                                        }
                                }
                                Section {
                                        tonesDescription
                                }
                        }
                        .textSelection(.enabled)
                        .navigationTitle("Jyutping Tones")
                        .navigationBarTitleDisplayMode(.inline)

                } else if #available(iOS 14.0, *) {
                        List {
                                Section {
                                        ForEach(dataSource.components(separatedBy: .newlines), id: \.self) {
                                                ToneCell($0, width: width)
                                        }
                                }
                                Section {
                                        tonesDescription
                                }
                        }
                        .listStyle(.insetGrouped)
                        .navigationTitle("Jyutping Tones")
                        .navigationBarTitleDisplayMode(.inline)

                } else {
                        List {
                                Section {
                                        ForEach(dataSource.components(separatedBy: .newlines), id: \.self) {
                                                ToneCell($0, width: width)
                                        }
                                }
                                Section {
                                        tonesDescription
                                }
                        }
                        .listStyle(.grouped)
                        .navigationBarTitle("Jyutping Tones", displayMode: .inline)
                }
        }


private let dataSource: String = """
例字,調值,聲調,粵拼
芬 fan1,55/53,陰平,1
粉 fan2,35,陰上,2
訓 fan3,33,陰去,3
焚 fan4,11/21,陽平,4
奮 fan5,13/23,陽上,5
份 fan6,22,陽去,6
忽 fat1,5,高陰入,1
法 faat3,3,低陰入,3
罰 fat6,2,陽入,6
"""

}


struct TonesTable_Previews: PreviewProvider {
        static var previews: some View {
                TonesTable()
        }
}


private struct ToneCell: View {

        init(_ line: String, width: CGFloat) {
                let parts: [String] = line.components(separatedBy: ",")
                self.components = parts
                self.width = width
                self.syllable = String(parts[0].dropFirst(2))
        }

        private let components: [String]
        private let width: CGFloat
        private let syllable: String

        var body: some View {
                HStack {
                        HStack(spacing: 8) {
                                Text(verbatim: components[0])
                                if !syllable.isEmpty {
                                        Speaker(syllable)
                                }
                        }
                        .frame(width: width + 25, alignment: .leading)
                        Text(verbatim: components[1]).frame(width: width - 14, alignment: .leading)
                        Text(verbatim: components[2]).frame(width: width - 14, alignment: .leading)
                        Text(verbatim: components[3])
                        Spacer()
                }
        }
}
