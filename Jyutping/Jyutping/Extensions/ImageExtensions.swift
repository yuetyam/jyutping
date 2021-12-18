import SwiftUI

extension Image {

        /// iOS 14+: speaker.wave.2 , iOS 13: speaker.2
        static let speaker: Image = {
                if #available(iOS 14.0, *) {
                        return Image(systemName: "speaker.wave.2")
                } else {
                        return Image(systemName: "speaker.2")
                }
        }()

        /// iOS 14+: speaker.wave.3.fill , iOS 13: speaker.3.fill
        static let speaking: Image = {
                if #available(iOS 14.0, *) {
                        return Image(systemName: "speaker.wave.3.fill")
                } else {
                        return Image(systemName: "speaker.3.fill")
                }
        }()

        static let safari: Image = Image(systemName: "safari")
}
