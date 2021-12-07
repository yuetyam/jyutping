import SwiftUI
import AVFoundation

struct TonesTable: View {

        @Environment(\.horizontalSizeClass) var horizontalSize

        private var width: CGFloat {
                guard UITraitCollection.current.userInterfaceIdiom == .pad else {
                        if #available(iOS 15.0, *) {
                                return (UIScreen.main.bounds.width - 64) / 4.0
                        } else {
                                return (UIScreen.main.bounds.width - 32) / 4.0
                        }
                }
                if horizontalSize == .compact {
                        return 80
                } else {
                        return 120
                }
        }

        var body: some View {
                List {
                        Section {
                                ForEach(part_0.components(separatedBy: .newlines), id: \.self) {
                                        ToneCell($0, width: width)
                                }
                        }

                        /*
                        Section {
                                ForEach(part_0.components(separatedBy: .newlines), id: \.self) {
                                        ToneCell($0, width: width)
                                }
                        } header: {
                                Text("例一")
                        }

                        Section {
                                ForEach(part_1.components(separatedBy: .newlines), id: \.self) {
                                        ToneCell($0, width: width)
                                }
                        } header: {
                                Text("例二")
                        }
                        */

                        if #available(iOS 15.0, *) {
                                if !(Speaker.isLanguagesEnabled) {
                                        Section {
                                                Text("爲保證發音質素，推薦到 **設定** → **一般** → **語言與地區** 度添加 **繁體中文(香港)** 語言").padding(.vertical, 4)
                                                Text("爲提高發音質素，推薦到 **設定** → **輔助功能** → **旁白** → **語音** 度添加 **繁體中文(香港)** 語音").padding(.vertical, 4)
                                        } header: {
                                                Text("本應用程式使用系統提供个語音朗讀功能")
                                        }
                                }
                        }
                }
                .navigationBarTitle("Jyutping Tones", displayMode: .inline)
        }

private let part_0: String = """
例字,調值,聲調,粵拼
芬 fan1,55/53,陰平,1
粉 fan2,35,陰上,2
訓 fan3,33,陰去,3
焚 fan4,11/21,陽平,4
奮 fan5,13/23,陽上,5
份 fan6,22,陽去,6
忽 fat1,5,高陰入,1
沷 fat3,3,低陰入,3
罰 fat6,2,陽入,6
"""

private let part_1: String = """
例字,調值,聲調,粵拼
威 wai1,55/53,陰平,1
委 wai2,35,陰上,2
餵 wai3,33,陰去,3
圍 wai4,11/21,陽平,4
偉 wai5,13/23,陽上,5
惠 wai6,22,陽去,6
鬱 wat1,5,高陰入,1
挖 waat3,3,低陰入,3
核 wat6,2,陽入,6
"""

}


struct TonesTable_Previews: PreviewProvider {
        static var previews: some View {
                TonesTable()
        }
}


private struct ToneCell: View {

        init(_ content: String, width: CGFloat) {
                let parts: [String] = content.components(separatedBy: ",")
                self.components = parts
                self.width = width
                self.syllable = String(parts[0].dropFirst(2))
        }

        private let components: [String]
        private let width: CGFloat
        private let syllable: String

        var body: some View {
                Button(action: {
                        if !syllable.isEmpty {
                                Speaker.speak(syllable)
                        }
                }) {
                        if #available(iOS 15.0, *) {
                                HStack {
                                        HStack(spacing: 8) {
                                                Text(verbatim: components[0])
                                                if !syllable.isEmpty {
                                                        Image.speaker.foregroundColor(.blue)
                                                }
                                        }
                                        .frame(width: width + 16, alignment: .leading)
                                        Text(verbatim: components[1]).frame(width: width - 10, alignment: .leading)
                                        Text(verbatim: components[2]).frame(width: width - 8, alignment: .leading)
                                        Text(verbatim: components[3])
                                        Spacer()
                                }
                                .foregroundColor(.primary)
                                .textSelection(.enabled)
                        } else {
                                HStack {
                                        HStack(spacing: 8) {
                                                Text(verbatim: components[0])
                                                if !syllable.isEmpty {
                                                        Image.speaker.foregroundColor(.blue)
                                                }
                                        }
                                        .frame(width: width + 16, alignment: .leading)
                                        Text(verbatim: components[1]).frame(width: width - 10, alignment: .leading)
                                        Text(verbatim: components[2]).frame(width: width - 8, alignment: .leading)
                                        Text(verbatim: components[3])
                                        Spacer()
                                }
                                .foregroundColor(.primary)
                        }
                }
        }
}
