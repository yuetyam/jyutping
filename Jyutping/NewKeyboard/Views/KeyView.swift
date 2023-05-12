import SwiftUI

struct KeyView: View {

        @EnvironmentObject private var context: KeyboardViewController

        let event: KeyboardEvent

        var body: some View {
                switch event {
                case .backspace:
                        BackspaceKey().environmentObject(context)
                case .capsLock:
                        EmptyView()
                case .comma:
                        CommaKey().environmentObject(context)
                case .dismiss:
                        EmptyView()
                case .globe:
                        EmptyView()
                case .hidden(let text):
                        Color.interactiveClear
                                .frame(width: context.widthUnit * 0.25, height: context.heightUnit)
                                .onTapGesture {
                                        context.operate(.input(text))
                                }
                case .input(let key):
                        LetterKey(key: key).environmentObject(context)
                case .newLine:
                        ReturnKey().environmentObject(context)
                case .numeric:
                        NumericKey().environmentObject(context)
                case .period:
                        PeriodKey().environmentObject(context)
                case .placeholder:
                        EmptyView()
                case .shift:
                        ShiftKey().environmentObject(context)
                case .space:
                        SpaceKey().environmentObject(context)
                case .tab:
                        EmptyView()
                case .transform(_):
                        NumericKey().environmentObject(context)
                }
        }
}
