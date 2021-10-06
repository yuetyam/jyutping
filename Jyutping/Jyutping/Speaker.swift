import AVFoundation

struct Speaker {

        private static let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
        static func speak(_ text: String) {
                let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
                utterance.voice = AVSpeechSynthesisVoice(language: "zh-HK")
                synthesizer.speak(utterance)
        }

        static let isLanguagesEnabled: Bool = Locale.preferredLanguages.contains("zh-Hant-HK")
}
