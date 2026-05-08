#if os(macOS)

import SwiftUI
import CommonExtensions
import AppDataSource

struct MacMetroStationLabel: View {
        let station: Metro.Station
        let line: Metro.Line
        let indicatingColor: Color
        var body: some View {
                HStack {
                        MacStationIndicatorView(indicator: line.indicator, label: station.label, color: indicatingColor).padding(.top, 4).padding(.trailing, 4)
                        TextRomanizationView(text: station.name, romanization: station.romanization)
                        Spacer()
                        Speaker(station.romanization)
                }
        }
}

private struct MacStationIndicatorView: View {
        let indicator: String
        let label: String
        let color: Color
        var body: some View {
                HStack(spacing: 2) {
                        Text(verbatim: indicator)
                                .font(.title3)
                                .monospacedDigit()
                                .lineLimit(1)
                                .minimumScaleFactor(0.2)
                        color.frame(width: 2).frame(maxHeight: .infinity)
                        Text(verbatim: label)
                                .font(.title3)
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
