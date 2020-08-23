enum KeyboardEvent: Equatable {
        case
        none,
        text(String),
        backspace,
        newLine, // return, enter
        space,
        shift,
        shiftDown,
        switchInputMethod,
        switchTo(KeyboardLayout),
        
        keyALeft,
        keyLRight,
        keyZLeft,
        keyBackspaceLeft
}
