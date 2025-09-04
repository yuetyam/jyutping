import SwiftUI

struct TonesInputView: View {
        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                VStack {
                                        HStack {
                                                Text("TonesInputView.TonesInput.Heading")
                                                Spacer()
                                        }
                                        Divider()
                                        HStack {
                                                Text("TonesInputView.TonesInput.Body").font(.body.monospaced())
                                                Spacer()
                                        }
                                        Divider()
                                        HStack {
                                                Text("TonesInputView.TonesInput.Examples")
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack(spacing: 2) {
                                        HStack(spacing: 16) {
                                                Text(verbatim: "例字")
                                                ZStack(alignment: .leading) {
                                                        Text(verbatim: "faat3").hidden()
                                                        Text(verbatim: "粵拼")
                                                }
                                                ZStack(alignment: .leading) {
                                                        Text(verbatim: "高陰入").hidden()
                                                        Text(verbatim: "聲調")
                                                }
                                                ZStack(alignment: .leading) {
                                                        Text(verbatim: "55/53").hidden()
                                                        Text(verbatim: "調值")
                                                }
                                                Spacer()
                                        }
                                        .padding(.horizontal, 8)
                                        VStack(spacing: 4) {
                                                ToneLabel(word: "芬", syllable: "fan1", name: "陰平", value: "55/53")
                                                ToneLabel(word: "粉", syllable: "fan2", name: "陰上", value: "35")
                                                ToneLabel(word: "糞", syllable: "fan3", name: "陰去", value: "33")
                                                ToneLabel(word: "焚", syllable: "fan4", name: "陽平", value: "21/11")
                                                ToneLabel(word: "憤", syllable: "fan5", name: "陽上", value: "13/23")
                                                ToneLabel(word: "份", syllable: "fan6", name: "陽去", value: "22")
                                                ToneLabel(word: "弗", syllable: "fat1", name: "高陰入", value: "5")
                                                ToneLabel(word: "法", syllable: "faat3", name: "低陰入", value: "3")
                                                ToneLabel(word: "佛", syllable: "fat6", name: "陽入", value: "2")
                                        }
                                        .block()
                                }
                        }
                        .textSelection(.enabled)
                        .padding(8)
                }
                .navigationTitle("PreferencesView.NavigationTitle.TonesInput")
        }
}

private struct ToneLabel: View {
        let word: String
        let syllable: String
        let name: String
        let value: String
        var body: some View {
                HStack(spacing: 16) {
                        ZStack(alignment: .leading) {
                                Text(verbatim: "例字").hidden()
                                Text(verbatim: word)
                        }
                        ZStack(alignment: .leading) {
                                Text(verbatim: "faat3").hidden()
                                Text(verbatim: syllable)
                        }
                        ZStack(alignment: .leading) {
                                Text(verbatim: "高陰入").hidden()
                                Text(verbatim: name)
                        }
                        ZStack(alignment: .leading) {
                                Text(verbatim: "55/53").hidden()
                                Text(verbatim: value)
                        }
                        Spacer()
                }
        }
}
