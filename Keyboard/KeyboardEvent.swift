enum KeyboardEvent: Equatable {
        case
        none,
        text(String),
        backspace,
        newLine, // return, enter
        space,
        shift,
        shiftDown,
        
        // Represent  UIInputViewController().dismissKeyboard()
        // https://developer.apple.com/documentation/uikit/uiinputviewcontroller/1618196-dismisskeyboard
        dismissInputMethod,
        
        switchInputMethod,
        switchTo(KeyboardLayout)
}
