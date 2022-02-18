import AVFoundation

struct Speech {

        private static let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
        private static let enhancedVoice: AVSpeechSynthesisVoice? = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Sin-Ji-premium")
        private static let voice: AVSpeechSynthesisVoice? = enhancedVoice ?? AVSpeechSynthesisVoice(language: "zh-HK")

        static func speak(_ text: String) {
                let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
                utterance.voice = voice
                DispatchQueue.main.async {
                        synthesizer.speak(utterance)
                }
        }
        static func stop() {
                DispatchQueue.main.async {
                        synthesizer.stopSpeaking(at: .immediate)
                }
        }
        static var isSpeaking: Bool {
                return synthesizer.isSpeaking
        }

        static let isLanguagesEnabled: Bool = Locale.preferredLanguages.contains("zh-Hant-HK")
        static let isEnhancedVoiceAvailable: Bool = enhancedVoice != nil
}
