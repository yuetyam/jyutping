import SwiftUI

struct TenKeySymbolsBar: View {

        @EnvironmentObject private var context: KeyboardViewController

        @Environment(\.colorScheme) private var colorScheme
        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .lightEmphatic
                case .dark:
                        return .darkEmphatic
                @unknown default:
                        return .lightEmphatic
                }
        }

        @Namespace private var topID

        private let symbols: [String] = ["+", "-", "*", "/", "=", ":", "%", "#", "@"]

        var body: some View {
                ZStack {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                        ScrollViewReader { proxy in
                                ScrollView(.vertical) {
                                        LazyVStack(spacing: 0) {
                                                EmptyView().id(topID)
                                                ForEach(0..<symbols.count, id: \.self) { index in
                                                        let symbol: String = symbols[index]
                                                        ScrollViewButton {
                                                                AudioFeedback.inputed()
                                                                context.triggerHapticFeedback()
                                                                context.operate(.input(symbol))
                                                                withAnimation {
                                                                        proxy.scrollTo(topID)
                                                                }
                                                        } label: {
                                                                ZStack {
                                                                        Color.interactiveClear
                                                                        Text(verbatim: symbol)
                                                                }
                                                                .frame(height: context.heightUnit * 3.0 / 4.0 - 1.0)
                                                                .frame(maxWidth: .infinity)
                                                        }
                                                        Divider()
                                                }
                                        }
                                }
                        }
                }
                .padding(3)
                .frame(width: context.widthUnit * 2, height: context.heightUnit * 3)
        }
}
