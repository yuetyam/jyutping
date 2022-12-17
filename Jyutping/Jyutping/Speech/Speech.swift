import AVFoundation

struct Speech {

        private static let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
        private static let voice: AVSpeechSynthesisVoice? = {
                if let iOS16_macOS13_Premium = AVSpeechSynthesisVoice(identifier: "com.apple.voice.premium.zh-HK.Sinji") {
                        return iOS16_macOS13_Premium
                } else if let iOS15Enhanced = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Sin-Ji-premium") {
                        return iOS15Enhanced
                } else if let macOS12Enhanced = AVSpeechSynthesisVoice(identifier: "com.apple.speech.synthesis.voice.sinji.premium") {
                        return macOS12Enhanced
                } else if let iOS16Enhanced = AVSpeechSynthesisVoice(identifier: "com.apple.voice.enhanced.zh-HK.Sinji") {
                        return iOS16Enhanced
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
                if #available(iOS 16.0, macOS 13.0, *) {
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
                } else {
                        switch voiceQuality {
                        case .default:
                                return false
                        case .enhanced:
                                return true
                        default:
                                return true
                        }
                }
        }()
}
