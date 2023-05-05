import SwiftUI

struct KeyView: View {

        @EnvironmentObject private var context: KeyboardViewController

        let event: KeyboardEvent

        var body: some View {
                switch event {
                case .backspace:
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(Color.lightEmphatic)
                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 3)
                                Image(systemName: "delete.backward")
                        }
                        .frame(width: context.widthUnit * 1.25, height: context.heightUnit)
                        .contentShape(Rectangle())
                        .onTapGesture {
                                context.textDocumentProxy.deleteBackward()
                        }
                case .capsLock:
                        EmptyView()
                case .dismiss:
                        EmptyView()
                case .globe:
                        EmptyView()
                case .hidden(let text):
                        Color.interactiveClear
                                .frame(width: context.widthUnit * 0.25, height: context.heightUnit)
                                .onTapGesture {
                                        context.textDocumentProxy.insertText(text)
                                }
                case .input(let key):
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(Color.white)
                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 3)
                                KeyElementView(element: key.primary).font(.title2)
                        }
                        .frame(width: context.widthUnit, height: context.heightUnit)
                        .contentShape(Rectangle())
                        .onTapGesture {
                                let text: String = key.primary.center
                                context.textDocumentProxy.insertText(text)
                        }
                case .newLine:
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(Color.lightEmphatic)
                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 3)
                                Text(verbatim: "換行")
                        }
                        .frame(width: context.widthUnit * 2, height: context.heightUnit)
                        .contentShape(Rectangle())
                        .onTapGesture {
                                context.textDocumentProxy.insertText("\n")
                        }
                case .placeholder:
                        EmptyView()
                case .shift:
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(Color.lightEmphatic)
                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 3)
                                Image(systemName: "shift")
                        }
                        .frame(width: context.widthUnit * 1.25, height: context.heightUnit)
                        .contentShape(Rectangle())
                        .onTapGesture { }
                case .space:
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(Color.white)
                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 3)
                                Text(verbatim: "粵拼")
                        }
                        .frame(width: context.widthUnit * 4.5, height: context.heightUnit)
                        .contentShape(Rectangle())
                        .onTapGesture {
                                context.textDocumentProxy.insertText(" ")
                        }
                case .tab:
                        EmptyView()
                case .transform:
                        ZStack {
                                Color.interactiveClear
                                RoundedRectangle(cornerRadius: 5, style: .continuous)
                                        .fill(Color.lightEmphatic)
                                        .shadow(color: .black.opacity(0.4), radius: 0.5, y: 1)
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 3)
                                Text(verbatim: "123")
                        }
                        .frame(width: context.widthUnit * 1.5, height: context.heightUnit)
                        .contentShape(Rectangle())
                        .onTapGesture {
                                context.textDocumentProxy.insertText("\n")
                        }
                }
        }
}
