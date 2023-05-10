import SwiftUI
import UniformTypeIdentifiers

struct EditingPanel: View {

        @EnvironmentObject private var context: KeyboardViewController

        var body: some View {
                HStack(spacing: 0) {
                        VStack(spacing: 0) {
                                HStack(spacing: 0) {
                                        ZStack {
                                                Color.interactiveClear
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
                                        Divider()
                                        ZStack {
                                                Color.interactiveClear
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
                                Divider()
                                HStack(spacing: 0) {
                                        ZStack {
                                                Color.interactiveClear
                                                Image(systemName: "arrow.backward")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                                context.operate(.moveCursorBackward)
                                        }
                                        Divider()
                                        ZStack {
                                                Color.interactiveClear
                                                Image(systemName: "arrow.forward")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                                context.operate(.moveCursorForward)
                                        }
                                }
                                .frame(maxHeight: .infinity)
                                Divider()
                                HStack(spacing: 0) {
                                        ZStack {
                                                Color.interactiveClear
                                                Image(systemName: "arrow.backward.to.line")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                                context.operate(.jumpToBeginning)
                                        }
                                        Divider()
                                        ZStack {
                                                Color.interactiveClear
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
                        Divider()
                        VStack(spacing: 0) {
                                ZStack {
                                        Color.interactiveClear
                                        Text(verbatim: "返回")
                                }
                                .frame(maxHeight: .infinity)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                        context.updateKeyboardType(to: .cantonese(.lowercased))
                                }
                                Divider()
                                ZStack {
                                        Color.interactiveClear
                                        Image(systemName: "delete.backward")
                                }
                                .frame(maxHeight: .infinity)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                        context.operate(.backspace)
                                }
                                Divider()
                                ZStack {
                                        Color.interactiveClear
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
                                Divider()
                                ZStack {
                                        Color.interactiveClear
                                        Text(verbatim: "換行")
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
