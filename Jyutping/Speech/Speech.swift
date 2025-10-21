import AVFoundation
import CommonExtensions

struct Speech {

        nonisolated(unsafe) private static let synthesizer: AVSpeechSynthesizer = AVSpeechSynthesizer()
        private static let voice: AVSpeechSynthesisVoice? = preferredCantoneseVoice()

        static func speak(_ text: String, isRomanization: Bool = true) {
                guard let voice else {
                        speakFeedback()
                        return
                }
                let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
                utterance.voice = voice
                utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.85
                synthesizer.speak(utterance)
        }
        static func speak(text: String, ipa: String) {
                let pronunciationKey = NSAttributedString.Key(rawValue: AVSpeechSynthesisIPANotationAttribute)
                let attributedString = NSMutableAttributedString(string: text, attributes: [pronunciationKey: ipa])
                let utterance = AVSpeechUtterance(attributedString: attributedString)
                utterance.voice = voice
                synthesizer.speak(utterance)
        }
        static func stop() {
                synthesizer.stopSpeaking(at: .immediate)
        }
        static var isSpeaking: Bool {
                return synthesizer.isSpeaking
        }
        static var voiceIdentifier: String? {
                return voice?.identifier
        }

        private static func speakFeedback() {
                if let mandarinTaiwanVoice = preferredVoice(of: .mandarinTaiwan) {
                        let text: String = "此設備缺少粵語語音，請添加後再試。"
                        let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
                        utterance.voice = mandarinTaiwanVoice
                        synthesizer.speak(utterance)
                } else if let mandarinPekingVoice = preferredVoice(of: .mandarinPeking) {
                        let text: String = "此设备缺少粤语语音，请添加后再试。"
                        let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
                        utterance.voice = mandarinPekingVoice
                        synthesizer.speak(utterance)
                } else {
                        let text: String = "This device does not contain a Cantonese voice, please add one and try again."
                        let utterance: AVSpeechUtterance = AVSpeechUtterance(string: text)
                        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") ?? AVSpeechSynthesisVoice(language: "en-GB") ?? AVSpeechSynthesisVoice(language: nil)
                        synthesizer.speak(utterance)
                }
        }

        private static func preferredCantoneseVoice() -> AVSpeechSynthesisVoice? {
                let languageCode: String = SpeechLanguage.chineseHongKong.code
                let alternativeLanguageCode: String = SpeechLanguage.cantoneseHongKong.code
                let voices = AVSpeechSynthesisVoice.speechVoices().filter({ $0.language == languageCode || $0.language == alternativeLanguageCode })
                guard voices.isNotEmpty else { return AVSpeechSynthesisVoice(language: languageCode) }
                let preferredVoices = voices.sorted { (lhs, rhs) -> Bool in
                        if #available(iOS 26.0, macOS 26.0, *) {
                                // Premium Cantonese voices are broken in iOS 26
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
                        } else if #available(iOS 18.0, macOS 15.0, *) {
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
                        } else if #available(iOS 17.0, macOS 14.0, *) {
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
                        } else {
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
                        }
                }
                return preferredVoices.first ?? AVSpeechSynthesisVoice(language: languageCode)
        }
        private static func preferredVoice(of language: SpeechLanguage) -> AVSpeechSynthesisVoice? {
                let languageCode: String = language.code
                let voices = AVSpeechSynthesisVoice.speechVoices().filter({ $0.language == languageCode })
                guard voices.isNotEmpty else { return AVSpeechSynthesisVoice(language: languageCode) }
                let preferredVoices = voices.sorted { (lhs, rhs) -> Bool in
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
                }
                return preferredVoices.first ?? AVSpeechSynthesisVoice(language: languageCode)
        }
}

private enum SpeechLanguage: Int {

        case cantoneseHongKong
        case chineseHongKong
        case mandarinTaiwan
        case mandarinPeking

        var code: String {
                switch self {
                case .cantoneseHongKong: "yue-HK"
                case .chineseHongKong: "zh-HK"
                case .mandarinTaiwan: "zh-TW"
                case .mandarinPeking: "zh-CN"
                }
        }
}
