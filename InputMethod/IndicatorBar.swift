import SwiftUI

@available(macOS 26.0, *)
struct GlassIndicatorBar: View {
        @EnvironmentObject private var context: InputContext
        @Environment(\.colorScheme) private var colorScheme
        var body: some View {
                if let texts = context.indicatorTexts {
                        ZStack {
                                Color.clear.glassEffect(.regular, in: RoundedRectangle(cornerRadius: 8))
                                HStack(spacing: 2) {
                                        ZStack {
                                                RoundedRectangle(cornerRadius: 6).fill(colorScheme.isDark ? Color.white : Color.black)
                                                Text(texts.short)
                                                        .lineLimit(1)
                                                        .minimumScaleFactor(0.1)
                                                        .foregroundStyle(colorScheme.isDark ? Color.black : Color.white)
                                                        .padding(2)
                                        }
                                        .frame(width: 26, height: 26)
                                        Text(texts.long)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.1)
                                                .padding(2)
                                }
                                .font(.candidate)
                                .frame(height: 26)
                                .padding(2)
                                .background(Color.clear, in: RoundedRectangle(cornerRadius: 8))
                        }
                        .padding(8)
                        .fixedSize()
                }
        }
}

struct IndicatorBar: View {
        @EnvironmentObject private var context: InputContext
        @Environment(\.colorScheme) private var colorScheme
        var body: some View {
                if let texts = context.indicatorTexts {
                        HStack(spacing: 2) {
                                ZStack {
                                        RoundedRectangle(cornerRadius: 6).fill(colorScheme.isDark ? Color.white : Color.black)
                                        Text(texts.short)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.1)
                                                .foregroundStyle(colorScheme.isDark ? Color.black : Color.white)
                                                .padding(2)
                                }
                                .frame(width: 26, height: 26)
                                Text(texts.long)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.1)
                                        .padding(2)
                        }
                        .font(.candidate)
                        .frame(height: 26)
                        .padding(2)
                        .background(VisualEffectView())
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(radius: 2)
                        .padding(8)
                        .fixedSize()
                }
        }
}
