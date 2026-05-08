#if os(iOS)

import SwiftUI
import AppDataSource

struct IOSMetroStationLabel: View {
        let station: Metro.Station
        let line: Metro.Line
        let indicatingColor: Color
        var body: some View {
                HStack {
                        StationIndicatorView(indicator: line.indicator, label: station.label, color: indicatingColor).padding(.top, 2)
                        TextRomanizationView(text: station.name, romanization: station.romanization)
                        Spacer()
                        Speaker(station.romanization)
                }
        }
}

private struct StationIndicatorView: View {
        let indicator: String
        let label: String
        let color: Color
        var body: some View {
                HStack(spacing: 2) {
                        Text(verbatim: indicator)
                                .font(.callout)
                                .monospacedDigit()
                                .lineLimit(1)
                                .minimumScaleFactor(0.2)
                        color.frame(width: 2).frame(maxHeight: .infinity)
                        Text(verbatim: label)
                                .font(.callout)
                                .monospacedDigit()
                                .lineLimit(1)
                                .minimumScaleFactor(0.2)
                }
                .padding(.horizontal, 2)
                .frame(width: 50, height: 25)
                .overlay {
                        Capsule().stroke(color, lineWidth: 2)
                }
        }
}

#endif
