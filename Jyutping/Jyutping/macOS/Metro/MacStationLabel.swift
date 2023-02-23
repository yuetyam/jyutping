#if os(macOS)

import SwiftUI
import Materials

struct MacStationLabel: View {

        let station: Metro.Station
        let placeholder: Metro.Station

        var body: some View {
                HStack(spacing: 24) {
                        ZStack(alignment: .leading) {
                                Text(verbatim: placeholder.name).hidden()
                                Text(verbatim: station.name)
                        }
                        ZStack(alignment: .leading) {
                                Text(verbatim: placeholder.romanization).font(.fixedWidth).hidden()
                                Text(verbatim: station.romanization).font(.fixedWidth)
                        }
                        Speaker(station.romanization)
                }
        }
}

#endif
