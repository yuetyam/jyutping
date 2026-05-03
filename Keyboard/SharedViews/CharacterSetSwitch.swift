import SwiftUI

@available(iOS, deprecated: 26.0, message: "Use CharacterSetSwitch instead")
@available(iOSApplicationExtension, deprecated: 26.0, message: "Use CharacterSetSwitch instead")
struct LegacyCharacterSetSwitch: View {

        init(width: CGFloat, isMutilatedMode: Bool) {
                let isDenseMode: Bool = (width < 47)
                self.isMutilatedMode = isMutilatedMode
                self.width = width
                self.height = 26
                self.partialWidth = isDenseMode ? 26 : 28
                self.characterOffset = isDenseMode ? 5 : 4
        }

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
                                Text(verbatim: "繁")
                                        .font(isMutilatedMode ? .small : .large)
                                        .padding(.trailing, isMutilatedMode ? characterOffset : 0)
                                        .frame(width: partialWidth, height: height)
                                        .background(isMutilatedMode ? Color.clear : colorScheme.inputKeyColor, in: .capsule)
                        }
                        ZStack(alignment: .trailing) {
                                Color.clear
                                Text(verbatim: "简")
                                        .font(isMutilatedMode ? .large : .small)
                                        .padding(.leading, isMutilatedMode ? 0 : characterOffset)
                                        .frame(width: partialWidth, height: height)
                                        .background(isMutilatedMode ? colorScheme.inputKeyColor : Color.clear, in: .capsule)
                        }
                }
                .frame(width: width, height: height)
                .background(colorScheme.activeInputKeyColor, in: .capsule)
        }
}

@available(iOS 26.0, *)
@available(iOSApplicationExtension 26.0, *)
struct CharacterSetSwitch: View {

        init(width: CGFloat, isMutilatedMode: Bool) {
                let isDenseMode: Bool = (width < 47)
                self.isMutilatedMode = isMutilatedMode
                self.width = width
                self.height = 26
                self.partialWidth = isDenseMode ? 26 : 28
                self.characterOffset = isDenseMode ? 5 : 4
        }

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
                                        if isMutilatedMode {
                                                Color.clear
                                        } else {
                                                Color.clear.glassEffect(.clear, in: .capsule)
                                        }
                                        Text(verbatim: "繁")
                                                .font(isMutilatedMode ? .small : .large)
                                                .padding(.trailing, isMutilatedMode ? characterOffset : 0)
                                }
                                .frame(width: partialWidth, height: height)
                        }
                        ZStack(alignment: .trailing) {
                                Color.clear
                                ZStack {
                                        if isMutilatedMode {
                                                Color.clear.glassEffect(.clear, in: .capsule)
                                        } else {
                                                Color.clear
                                        }
                                        Text(verbatim: "简")
                                                .font(isMutilatedMode ? .large : .small)
                                                .padding(.leading, isMutilatedMode ? 0 : characterOffset)
                                }
                                .frame(width: partialWidth, height: height)
                        }
                }
                .frame(width: width, height: height)
                .background(Material.thin, in: .capsule)
        }
}

private extension Font {
        static let large: Font = Font.system(size: 16)
        static let small: Font = Font.system(size: 12)
}
