enum KeyboardEvent: Equatable {
        case text(String),
             space,
             backspace,
             newLine, // return, enter
             shift,
             shiftDown,
             switchInputMethod,
             switchTo(KeyboardLayout),

             shadowKey(String),
             shadowBackspace,
             none
}
