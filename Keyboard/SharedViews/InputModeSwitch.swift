import SwiftUI

/// Toggle Cantonese/ABC InputMethodMode
@available(iOS, deprecated: 26.0, message: "Use InputModeSwitch instead")
@available(iOSApplicationExtension, deprecated: 26.0, message: "Use InputModeSwitch instead")
struct LegacyInputModeSwitch: View {

        init(width: CGFloat, isCantoneseMode: Bool, isMutilatedMode: Bool) {
                let isDenseMode: Bool = (width < 59)
                self.isCantoneseMode = isCantoneseMode
                self.isMutilatedMode = isMutilatedMode
                self.width = width
                self.height = 26
                self.partialWidth = isDenseMode ? 34 : 36
                self.characterOffset = isDenseMode ? 6 : 4
        }

        private let isCantoneseMode: Bool
        private let isMutilatedMode: Bool
        private let width: CGFloat
        private let height: CGFloat
        private let partialWidth: CGFloat
        private let characterOffset: CGFloat

        @Environment(\.colorScheme) private var colorScheme

        var body: some View {
                ZStack {
                        Color.clear
                        ZStack(alignment: .leading) {
                                Color.clear
                                Text(verbatim: isMutilatedMode ? "粤" : "粵")
                                        .font(isCantoneseMode ? .staticBody : .mini)
                                        .padding(.trailing, isCantoneseMode ? 0 : characterOffset)
                                        .frame(width: partialWidth, height: height)
                                        .background(isCantoneseMode ? colorScheme.inputKeyColor : Color.clear, in: .capsule)
                        }
                        ZStack(alignment: .trailing) {
                                Color.clear
                                Text(verbatim: "A")
                                        .font(isCantoneseMode ? .mini : .staticBody)
                                        .padding(.leading, isCantoneseMode ? characterOffset : 0)
                                        .frame(width: partialWidth, height: height)
                                        .background(isCantoneseMode ? Color.clear : colorScheme.inputKeyColor, in: .capsule)
                        }
                }
                .frame(width: width, height: height)
                .background(colorScheme.activeInputKeyColor, in: .capsule)
        }
}

/// Toggle Cantonese/ABC InputMethodMode
@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct InputModeSwitch: View {

        init(width: CGFloat, isCantoneseMode: Bool, isMutilatedMode: Bool) {
                let isDenseMode: Bool = (width < 59)
                self.isCantoneseMode = isCantoneseMode
                self.isMutilatedMode = isMutilatedMode
                self.width = width
                self.height = 26
                self.partialWidth = isDenseMode ? 34 : 36
                self.characterOffset = isDenseMode ? 6 : 4
        }

        private let isCantoneseMode: Bool
        private let isMutilatedMode: Bool
        private let width: CGFloat
        private let height: CGFloat
        private let partialWidth: CGFloat
        private let characterOffset: CGFloat

        @Environment(\.colorScheme) private var colorScheme

        var body: some View {
                ZStack {
                        Color.clear
                        ZStack(alignment: .leading) {
                                Color.clear
                                ZStack {
                                        if isCantoneseMode {
                                                Color.clear.glassEffect(.clear, in: .capsule)
                                        } else {
                                                Color.clear
                                        }
                                        Text(verbatim: isMutilatedMode ? "粤" : "粵")
                                                .font(isCantoneseMode ? .staticBody : .mini)
                                                .padding(.trailing, isCantoneseMode ? 0 : characterOffset)
                                }
                                .frame(width: partialWidth, height: height)
                        }
                        ZStack(alignment: .trailing) {
                                Color.clear
                                ZStack {
                                        if isCantoneseMode {
                                                Color.clear
                                        } else {
                                                Color.clear.glassEffect(.clear, in: .capsule)
                                        }
                                        Text(verbatim: "A")
                                                .font(isCantoneseMode ? .mini : .staticBody)
                                                .padding(.leading, isCantoneseMode ? characterOffset : 0)
                                }
                                .frame(width: partialWidth, height: height)
                        }
                }
                .frame(width: width, height: height)
                .background(Material.thin, in: .capsule)
        }
}

private extension Font {
        static let mini: Font = Font.system(size: 13)
}
