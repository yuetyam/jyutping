#if os(iOS)

import SwiftUI
import AppDataSource

struct IOSMetroStationLabel: View {
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
