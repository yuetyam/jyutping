import AVFoundation

struct Speech {

        private static let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
        private static let voice: AVSpeechSynthesisVoice? = preferredCantoneseVoice()

        static func speak(_ text: String) {
                guard isVoiceAvailable else {
                        speakFeedback()
                        return
                }
                let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
                utterance.voice = voice
                utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.85
                DispatchQueue.main.async {
                        synthesizer.speak(utterance)
                }
        }

        static func speak(text: String, ipa: String) {
                let pronunciationKey = NSAttributedString.Key(rawValue: AVSpeechSynthesisIPANotationAttribute)
                let attributedString = NSMutableAttributedString(string: text, attributes: [pronunciationKey: ipa])
                let utterance = AVSpeechUtterance(attributedString: attributedString)
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

        /// Does current device contain any Cantonese voice
        static let isVoiceAvailable: Bool = voiceStatus != .unavailable

        /// Does System Preferred Languages contain `zh-Hant-HK`
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
                        let text: String = "This device does not contain a Cantonese voice, please add one and try again."
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

        private static let mandarinTaiwanVoice: AVSpeechSynthesisVoice? = preferredVoice(of: .mandarinTaiwan)
        private static let mandarinPekingVoice: AVSpeechSynthesisVoice? = preferredVoice(of: .mandarinPeking)
        private static let englishVoice: AVSpeechSynthesisVoice? = AVSpeechSynthesisVoice(language: "en-US") ?? AVSpeechSynthesisVoice(language: "en-GB") ?? AVSpeechSynthesisVoice(language: "en-AU")
        private static let currentDefaultVoice: AVSpeechSynthesisVoice? = AVSpeechSynthesisVoice(language: nil)

        private static func preferredCantoneseVoice() -> AVSpeechSynthesisVoice? {
                let languageCode: String = SpeechLanguage.chineseHongKong.code
                let voices = AVSpeechSynthesisVoice.speechVoices().filter({ $0.language == languageCode })
                guard !(voices.isEmpty) else { return AVSpeechSynthesisVoice(language: languageCode) }
                let preferredVoices = voices.sorted { (lhs, rhs) -> Bool in
                        if #available(iOS 17.0, macOS 14.0, *) {
                                // Premium Cantonese voices are broken in iOS 17
                                switch (lhs.quality, rhs.quality) {
                                case (.premium, _):
                                        return false
                                case (_, .premium):
                                        return true
                                case (.enhanced, .default):
                                        return true
                                case (_, _):
                                        return false
                                }
                        } else if #available(iOS 16.0, macOS 13.0, *) {
                                switch (lhs.quality, rhs.quality) {
                                case (.premium, .enhanced):
                                        return true
                                case (.premium, .default):
                                        return true
                                case (.enhanced, .default):
                                        return true
                                case (_, _):
                                        return false
                                }
                        } else {
                                switch (lhs.quality, rhs.quality) {
                                case (.enhanced, .default):
                                        return true
                                case (_, _):
                                        return false
                                }
                        }
                }
                return preferredVoices.first ?? AVSpeechSynthesisVoice(language: languageCode)
        }
        private static func preferredVoice(of language: SpeechLanguage) -> AVSpeechSynthesisVoice? {
                let languageCode: String = language.code
                let voices = AVSpeechSynthesisVoice.speechVoices().filter({ $0.language == languageCode })
                guard !(voices.isEmpty) else { return AVSpeechSynthesisVoice(language: languageCode) }
                let preferredVoices = voices.sorted { (lhs, rhs) -> Bool in
                        if #available(iOS 16.0, macOS 13.0, *) {
                                switch (lhs.quality, rhs.quality) {
                                case (.premium, .enhanced):
                                        return true
                                case (.premium, .default):
                                        return true
                                case (.enhanced, .default):
                                        return true
                                case (_, _):
                                        return false
                                }
                        } else {
                                switch (lhs.quality, rhs.quality) {
                                case (.enhanced, .default):
                                        return true
                                case (_, _):
                                        return false
                                }
                        }
                }
                return preferredVoices.first ?? AVSpeechSynthesisVoice(language: languageCode)
        }

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
}

enum VoiceStatus: Int {
        case unavailable
        case regular
        case enhanced
        case premium
}

enum SpeechLanguage: Int, Hashable {

        case chineseHongKong
        case mandarinTaiwan
        case mandarinPeking

        var code: String {
                switch self {
                case .chineseHongKong:
                        return "zh-HK"
                case .mandarinTaiwan:
                        return "zh-TW"
                case .mandarinPeking:
                        return "zh-CN"
                }
        }
}
