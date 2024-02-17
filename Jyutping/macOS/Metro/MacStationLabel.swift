#if os(macOS)

import SwiftUI
import AppDataSource

struct MacStationLabel: View {
        let station: Metro.Station
        var body: some View {
                HStack {
                        TextPronunciationView(text: station.name, romanization: station.romanization)
                        Spacer()
                        Speaker(station.romanization)
                }
        }
}

#endif
