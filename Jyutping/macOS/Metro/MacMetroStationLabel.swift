#if os(macOS)

import SwiftUI
import AppDataSource

struct MacMetroStationLabel: View {
        let station: Metro.Station
        var body: some View {
                HStack {
                        TextRomanizationView(text: station.name, romanization: station.romanization)
                        Spacer()
                        Speaker(station.romanization)
                }
        }
}

#endif
