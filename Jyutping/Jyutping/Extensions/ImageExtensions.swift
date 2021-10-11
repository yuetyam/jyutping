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
}
