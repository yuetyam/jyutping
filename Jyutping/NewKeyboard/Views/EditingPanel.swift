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
                                                Image(systemName: "arrow.backward")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                                context.textDocumentProxy.adjustTextPosition(byCharacterOffset: -1)
                                        }
                                        Divider()
                                        ZStack {
                                                Color.interactiveClear
                                                Image(systemName: "arrow.forward")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                                context.textDocumentProxy.adjustTextPosition(byCharacterOffset: 1)
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
                                                context.textDocumentProxy.adjustTextPosition(byCharacterOffset: -1)
                                        }
                                        Divider()
                                        ZStack {
                                                Color.interactiveClear
                                                Image(systemName: "arrow.forward.to.line")
                                        }
                                        .frame(maxWidth: .infinity)
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                                context.textDocumentProxy.adjustTextPosition(byCharacterOffset: 1)
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
                                        Image(systemName: "doc.on.clipboard")
                                }
                                .frame(maxHeight: .infinity)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                        context.operate(.paste)
                                }
                                .disabled(!(UIPasteboard.general.hasStrings))
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
