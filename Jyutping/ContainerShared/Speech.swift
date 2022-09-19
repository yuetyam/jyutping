import AVFoundation

struct Speech {

        private static let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
        private static let voice: AVSpeechSynthesisVoice? = {
                if let iOS16Premium = AVSpeechSynthesisVoice(identifier: "com.apple.voice.premium.zh-HK.Sinji") {
                        return iOS16Premium
                } else if let oldIOSEnhanced = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Sin-Ji-premium") {
                        return oldIOSEnhanced
                } else if let iOS16Enhanced = AVSpeechSynthesisVoice(identifier: "com.apple.voice.enhanced.zh-HK.Sinji") {
                        return iOS16Enhanced
                } else if let possibleOldIOSEnhanced = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Sin-Ji-enhanced") {
                        // Not sure this identifier valid or not
                        return possibleOldIOSEnhanced
                } else {
                        return AVSpeechSynthesisVoice(language: "zh-HK")
                }
        }()

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
        static let isEnhancedVoiceAvailable: Bool = {
                guard let voiceQuality = voice?.quality else { return false }
                switch voiceQuality {
                case .default:
                        return false
                case .enhanced:
                        return true
                case .premium:
                        return true
                @unknown default:
                        return true
                }
        }()
}
