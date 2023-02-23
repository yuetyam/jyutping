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
                guard isVoiceAvailable else {
                        speakFeedback()
                        return
                }
                let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
                utterance.voice = voice
                utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.9
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

        /// Does current device contains a Cantonese voice
        static let isVoiceAvailable: Bool = voiceStatus != .unavailable

        static let voiceStatus: VoiceStatus = {
                guard let voiceQuality = voice?.quality else { return .unavailable }
                if #available(iOS 16.0, macOS 13.0, *) {
                        switch voiceQuality {
                        case .default:
                                return .regular
                        case .enhanced:
                                return .enhanced
                        case .premium:
                                return .premium
                        @unknown default:
                                return .regular
                        }
                } else {
                        switch voiceQuality {
                        case .default:
                                return .regular
                        case .enhanced:
                                return .enhanced
                        default:
                                return .regular
                        }
                }
        }()

        /// Does System Preferred Languages contains `zh-Hant-HK`
        static var isLanguageTraditionalChineseHongKongEnabled: Bool {
                return Locale.preferredLanguages.contains("zh-Hant-HK")
        }

        private static func speakFeedback() {
                if let mandarinTaiwanVoice = mandarinTaiwanVoice {
                        let text: String = "此設備缺少粵語語音，請添加後再試。"
                        let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
                        utterance.voice = mandarinTaiwanVoice
                        DispatchQueue.main.async {
                                synthesizer.speak(utterance)
                        }
                } else if let mandarinPekingVoice = mandarinPekingVoice {
                        let text: String = "此设备缺少粤语语音，请添加后再试。"
                        let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
                        utterance.voice = mandarinPekingVoice
                        DispatchQueue.main.async {
                                synthesizer.speak(utterance)
                        }
                } else if let cantoneseVoice = voice {
                        let text: String = "此設備缺少粵語語音，請添加後再試。"
                        let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
                        utterance.voice = cantoneseVoice
                        DispatchQueue.main.async {
                                synthesizer.speak(utterance)
                        }
                } else if let englishVoice = englishVoice {
                        let text: String = "This device does not contain a Cantonese voice, please add it and try again."
                        let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
                        utterance.voice = englishVoice
                        DispatchQueue.main.async {
                                synthesizer.speak(utterance)
                        }
                } else {
                        let text: String = "No Voice"
                        let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
                        utterance.voice = currentDefaultVoice
                        DispatchQueue.main.async {
                                synthesizer.speak(utterance)
                        }
                }
        }

        private static let mandarinTaiwanVoice: AVSpeechSynthesisVoice? = {
                if let premium = AVSpeechSynthesisVoice(identifier: "com.apple.voice.premium.zh-TW.Meijia") {
                        return premium
                } else if let enhanced = AVSpeechSynthesisVoice(identifier: "com.apple.voice.enhanced.zh-TW.Meijia") {
                        return enhanced
                } else {
                        return AVSpeechSynthesisVoice(language: "zh-TW")
                }
        }()
        private static let mandarinPekingVoice: AVSpeechSynthesisVoice? = {
                if let premium = AVSpeechSynthesisVoice(identifier: "com.apple.voice.premium.zh-CN.Tingting") {
                        return premium
                } else if let enhanced = AVSpeechSynthesisVoice(identifier: "com.apple.voice.enhanced.zh-CN.Tingting") {
                        return enhanced
                } else {
                        return AVSpeechSynthesisVoice(language: "zh-CN")
                }
        }()
        private static let englishVoice: AVSpeechSynthesisVoice? = AVSpeechSynthesisVoice(language: "en-US") ?? AVSpeechSynthesisVoice(language: "en-GB") ?? AVSpeechSynthesisVoice(language: "en-AU")
        private static let currentDefaultVoice: AVSpeechSynthesisVoice? = AVSpeechSynthesisVoice(language: nil)
}

enum VoiceStatus: Int {
        case unavailable
        case regular
        case enhanced
        case premium
}
