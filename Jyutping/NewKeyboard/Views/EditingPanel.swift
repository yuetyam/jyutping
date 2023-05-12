import SwiftUI

struct EditingPanel: View {

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
                HStack(spacing: 0) {
                        VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                        ZStack {
                                                Color.interactiveClear
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .fill(keyColor)
                                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                        .padding(.vertical, 6)
                                                        .padding(.horizontal, 3)
                                                VStack(spacing: 4) {
                                                        Image(systemName: "clipboard")
                                                        Text(verbatim: "清空剪帖板").font(.caption2)
                                                }
                                        }
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                                context.operate(.clearClipboard)
                                        }
                                        ZStack {
                                                Color.interactiveClear
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .fill(keyColor)
                                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                        .padding(.vertical, 6)
                                                        .padding(.horizontal, 3)
                                                VStack(spacing: 4) {
                                                        Image(systemName: "doc.on.clipboard")
                                                        Text(verbatim: "帖上").font(.caption2)
                                                }
                                                .opacity(UIPasteboard.general.hasStrings ? 1 : 0.5)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                                context.operate(.paste)
                                        }
                                }
                                .frame(maxHeight: .infinity)
                                HStack(spacing: 0) {
                                        ZStack {
                                                Color.interactiveClear
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .fill(keyColor)
                                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                        .padding(.vertical, 6)
                                                        .padding(.horizontal, 3)
                                                Image(systemName: "arrow.backward")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                                context.operate(.moveCursorBackward)
                                        }
                                        ZStack {
                                                Color.interactiveClear
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .fill(keyColor)
                                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                        .padding(.vertical, 6)
                                                        .padding(.horizontal, 3)
                                                Image(systemName: "arrow.forward")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                                context.operate(.moveCursorForward)
                                        }
                                }
                                .frame(maxHeight: .infinity)
                                HStack(spacing: 0) {
                                        ZStack {
                                                Color.interactiveClear
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .fill(keyColor)
                                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                        .padding(.vertical, 6)
                                                        .padding(.horizontal, 3)
                                                Image(systemName: "arrow.backward.to.line")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                                context.operate(.jumpToBeginning)
                                        }
                                        ZStack {
                                                Color.interactiveClear
                                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                        .fill(keyColor)
                                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                        .padding(.vertical, 6)
                                                        .padding(.horizontal, 3)
                                                Image(systemName: "arrow.forward.to.line")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                                context.operate(.jumpToEnd)
                                        }
                                }
                                .frame(maxHeight: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        VStack(spacing: 0) {
                                ZStack {
                                        Color.interactiveClear
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(keyColor)
                                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                .padding(.vertical, 6)
                                                .padding(.horizontal, 3)
                                        VStack(spacing: 4) {
                                                Image(systemName: "chevron.up").font(.title3)
                                                Text(verbatim: "返回").font(.caption2)
                                        }
                                }
                                .frame(maxHeight: .infinity)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                        context.updateKeyboardType(to: .cantonese(.lowercased))
                                }
                                ZStack {
                                        Color.interactiveClear
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(keyColor)
                                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                .padding(.vertical, 6)
                                                .padding(.horizontal, 3)
                                        Image(systemName: "delete.backward")
                                }
                                .frame(maxHeight: .infinity)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                        context.operate(.backspace)
                                }
                                ZStack {
                                        Color.interactiveClear
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(keyColor)
                                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                .padding(.vertical, 6)
                                                .padding(.horizontal, 3)
                                        VStack(spacing: 4) {
                                                Image(systemName: "clear")
                                                Text(verbatim: "清空").font(.caption2)
                                        }
                                }
                                .frame(maxHeight: .infinity)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                        context.operate(.clearText)
                                }
                                ZStack {
                                        Color.interactiveClear
                                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .fill(keyColor)
                                                .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                                .padding(.vertical, 6)
                                                .padding(.horizontal, 3)
                                        Text(verbatim: context.returnKeyText)
                                }
                                .frame(maxHeight: .infinity)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                        context.operate(.return)
                                }
                        }
                        .frame(width: 100)
                }
        }
}
