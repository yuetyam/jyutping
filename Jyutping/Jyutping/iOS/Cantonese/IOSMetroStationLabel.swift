#if os(iOS)

import SwiftUI
import AppDataSource

struct IOSMetroStationLabel: View {

        let station: Metro.Station

        var body: some View {
                HStack {
                        HStack(spacing: 12) {
                                Text(verbatim: station.name)
                                Text(verbatim: station.romanization)
                                        .font(.copilot)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.4)
                        }
                        Spacer()
                        Speaker(station.romanization)
                }
        }
}

#endif
