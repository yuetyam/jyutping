import SwiftUI

struct IndicatorBar: View {
        @EnvironmentObject private var context: AppContext
        @Environment(\.colorScheme) private var colorScheme
        var body: some View {
                if let texts = context.indicatorTexts {
                        HStack(spacing: 2) {
                                ZStack {
                                        Color.clear
                                        Text(texts.short)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.1)
                                                .foregroundStyle(colorScheme.isDark ? Color.black : Color.white)
                                                .padding(2)
                                }
                                .frame(width: 26, height: 26)
                                .background(colorScheme.isDark ? Color.white : Color.black, in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                                Text(texts.long)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.1)
                                        .padding(2)
                        }
                        .font(.candidate)
                        .frame(height: 26)
                        .padding(2)
                        .background(VisualEffectView())
                        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .shadow(radius: 2)
                        .padding(.horizontal, 8)
                        .padding(.top, 8)
                        .fixedSize()
                }
        }
}
