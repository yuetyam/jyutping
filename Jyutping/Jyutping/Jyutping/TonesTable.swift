import SwiftUI
import AVFoundation

struct TonesTable: View {

        private let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
        private func speak(_ text: String) {
                let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
                utterance.voice = AVSpeechSynthesisVoice(language: "zh-HK")
                synthesizer.speak(utterance)
        }

        private let width: CGFloat = {
                if UITraitCollection.current.userInterfaceIdiom == .pad {
                        return 120
                } else {
                        if #available(iOS 15.0, *) {
                                return (UIScreen.main.bounds.width - 64) / 4.0
                        } else {
                                return (UIScreen.main.bounds.width - 32) / 4.0
                        }
                }
        }()

        var body: some View {
                List(content.components(separatedBy: .newlines), id: \.self) {
                        ToneCell($0, width: width, speak: speak(_:))
                }
                .navigationBarTitle("Jyutping Tones", displayMode: .inline)
        }

private let content: String = """
例字,調值,聲調,粵拼
芬 fan1,55/53,陰平,1
粉 fan2,35,陰上,2
訓 fan3,33,陰去,3
焚 fan4,11/21,陽平,4
奮 fan5,23,陽上,5
份 fan6,22,陽去,6
忽 fat1,5,高陰入,1
沷 fat3,3,低陰入,3
佛 fat6,2,陽入,6
"""
}


struct TonesTable_Previews: PreviewProvider {
        static var previews: some View {
                TonesTable()
        }
}


private struct ToneCell: View {

        init(_ content: String, width: CGFloat, speak: @escaping (String) -> Void) {
                let parts: [String] = content.components(separatedBy: ",")
                self.components = parts
                self.width = width
                self.syllable = String(parts[0].dropFirst(2))
                self.speak = speak
        }

        private let components: [String]
        private let width: CGFloat
        private let syllable: String
        private let speak: (String) -> Void

        var body: some View {
                Button(action: {
                        if !syllable.isEmpty {
                                speak(syllable)
                        }
                }) {
                        if #available(iOS 15.0, *) {
                                HStack {
                                        HStack(spacing: 8) {
                                                Text(verbatim: components[0])
                                                if !syllable.isEmpty {
                                                        Image(systemName: "speaker.wave.2").foregroundColor(.blue)
                                                }
                                        }
                                        .frame(width: width + 20, alignment: .leading)
                                        Text(verbatim: components[1]).frame(width: width - 8, alignment: .leading)
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
                                                        Image(systemName: "speaker.2").foregroundColor(.blue)
                                                }
                                        }
                                        .frame(width: width + 20, alignment: .leading)
                                        Text(verbatim: components[1]).frame(width: width - 8, alignment: .leading)
                                        Text(verbatim: components[2]).frame(width: width - 8, alignment: .leading)
                                        Text(verbatim: components[3])
                                        Spacer()
                                }
                                .foregroundColor(.primary)
                        }
                }
        }
}
