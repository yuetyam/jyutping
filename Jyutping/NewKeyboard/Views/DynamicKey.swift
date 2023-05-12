import SwiftUI

struct CommaKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .light
                case .dark:
                        return .dark
                @unknown default:
                        return .light
                }
        }

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 3)
                        if context.keyboardType.isABCMode {
                                if context.needsInputModeSwitchKey {
                                        Text(verbatim: ".")
                                } else {
                                        Text(verbatim: ",")
                                }
                        } else {
                                if context.inputStage.isBuffering {
                                        Text(verbatim: "'")
                                        VStack(spacing: 0) {
                                                Text(verbatim: " ").padding(.top, 12)
                                                Spacer()
                                                Text(verbatim: "分隔").font(.keyFooter).foregroundColor(.secondary).padding(.bottom, 12)
                                        }
                                        .frame(width: context.widthUnit, height: context.heightUnit)
                                } else {
                                        Text(verbatim: "，")
                                }
                        }
                }
                .frame(width: context.widthUnit, height: context.heightUnit)
                .contentShape(Rectangle())
                .onTapGesture {
                        if context.keyboardType.isABCMode {
                                if context.needsInputModeSwitchKey {
                                        context.operate(.punctuation("."))
                                } else {
                                        context.operate(.punctuation(","))
                                }
                        } else {
                                if context.inputStage.isBuffering {
                                        context.operate(.input("'"))
                                } else {
                                        context.operate(.punctuation("，"))
                                }
                        }
                }
        }
}

struct PeriodKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .light
                case .dark:
                        return .dark
                @unknown default:
                        return .light
                }
        }

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 3)
                        if context.keyboardType.isABCMode {
                                Text(verbatim: ".")
                        } else {
                                if context.inputStage.isBuffering {
                                        Text(verbatim: "'")
                                        VStack(spacing: 0) {
                                                Text(verbatim: " ").padding(.top, 12)
                                                Spacer()
                                                Text(verbatim: "分隔").font(.keyFooter).foregroundColor(.secondary).padding(.bottom, 12)
                                        }
                                        .frame(width: context.widthUnit, height: context.heightUnit)
                                } else {
                                        Text(verbatim: "。")
                                }
                        }
                }
                .frame(width: context.widthUnit, height: context.heightUnit)
                .contentShape(Rectangle())
                .onTapGesture {
                        if context.keyboardType.isABCMode {
                                context.operate(.punctuation("."))
                        } else {
                                if context.inputStage.isBuffering {
                                        context.operate(.input("'"))
                                } else {
                                        context.operate(.punctuation("。"))
                                }
                        }
                }
        }
}

struct ReturnKey: View {

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

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 3)
                        Text(verbatim: context.returnKeyText)
                }
                .frame(width: context.widthUnit * 2, height: context.heightUnit)
                .contentShape(Rectangle())
                .onTapGesture {
                        context.operate(.return)
                }
        }
}

struct SpaceKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .light
                case .dark:
                        return .dark
                @unknown default:
                        return .light
                }
        }

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 3)
                        Text(verbatim: context.spaceText)
                }
                .frame(width: context.widthUnit * 4.5, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(TapGesture(count: 2).onEnded {
                        context.operate(.doubleSpace)
                })
                .simultaneousGesture(TapGesture().onEnded {
                        context.operate(.space)
                })
        }
}

struct BackspaceKey: View {

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

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 3)
                        Image(systemName: "delete.backward")
                }
                .frame(width: context.widthUnit * 1.25, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(DragGesture(minimumDistance: 44, coordinateSpace: .local)
                        .onEnded { value in
                                let horizontalTranslation = value.translation.width
                                guard horizontalTranslation < -44 else { return }
                                context.operate(.clear)
                         }
                )
                .simultaneousGesture(TapGesture().onEnded {
                        context.operate(.backspace)
                })
        }
}

struct ShiftKey: View {

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

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 3)
                        switch context.keyboardType {
                        case .abc(.capsLocked), .cantonese(.capsLocked), .saamPing(.capsLocked):
                                Image(systemName: "capslock.fill")
                        case .abc(.uppercased), .cantonese(.uppercased), .saamPing(.uppercased):
                                Image(systemName: "shift.fill")
                        default:
                                Image(systemName: "shift")
                        }
                }
                .frame(width: context.widthUnit * 1.25, height: context.heightUnit)
                .contentShape(Rectangle())
                .gesture(TapGesture(count: 2).onEnded {
                        context.operate(.doubleShift)
                })
                .simultaneousGesture(TapGesture().onEnded {
                        context.operate(.shift)
                })
        }
}

struct NumericKey: View {

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

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 3)
                        Text(verbatim: "123")
                }
                .frame(width: context.widthUnit * 1.5, height: context.heightUnit)
                .contentShape(Rectangle())
                .onTapGesture {
                        context.operate(.transform(.cantoneseNumeric))
                }
        }
}

struct LetterKey: View {

        @EnvironmentObject private var context: KeyboardViewController
        @Environment(\.colorScheme) private var colorScheme

        let key: KeyUnit

        private var keyColor: Color {
                switch colorScheme {
                case .light:
                        return .light
                case .dark:
                        return .dark
                @unknown default:
                        return .light
                }
        }

        var body: some View {
                ZStack {
                        Color.interactiveClear
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .fill(keyColor)
                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                .padding(.vertical, 6)
                                .padding(.horizontal, 3)
                        KeyElementView(element: key.primary).font(.title2)
                }
                .frame(width: context.widthUnit, height: context.heightUnit)
                .contentShape(Rectangle())
                .onTapGesture {
                        let text: String = key.primary.center
                        context.operate(.input(text))
                }
        }
}
