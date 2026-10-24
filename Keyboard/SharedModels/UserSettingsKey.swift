/// Keys used to persist the keyboard extension's preferences in standard user defaults.
///
/// Keep the stored strings stable when renaming constants so existing preferences remain readable.
struct UserSettingsKey {

        /// Ordered language-code array used to override the keyboard's localization preferences.
        static let AppleLanguages: String = "AppleLanguages"

        /// Integer raw value of the preferred `KeyboardDisplayLanguage`.
        static let KeyboardDisplayLanguage: String = "KeyboardDisplayLanguage"

        /// Integer raw value of the preferred traditional `CharacterStandard`.
        static let TraditionalCharacterStandard: String = "TraditionalCharacterStandard"

        /// Character script selection: traditional or simplified.
        static let CharacterScriptVariant: String = "CharacterScriptVariant"

        /// Sound feedback, on or off.
        static let AudioFeedback: String = "AudioFeedback"

        /// Integer raw value of the selected `HapticFeedback` mode.
        static let HapticFeedback: String = "HapticFeedback"

        /// Integer raw value of the startup `PreferredInputMode`.
        static let PreferredInputMethodMode: String = "PreferredInputMethodMode"

        /// Integer raw value of the last `InputMethodMode`, restored when the startup preference is previous mode.
        static let LatestInputMethodMode: String = "LatestInputMethodMode"

        /// Integer raw value of the selected `JyutpingSpellingMode`.
        static let JyutpingSpellingMode: String = "JyutpingSpellingMode"

        /// Integer raw value of the selected `KeyboardLayout`.
        static let KeyboardLayout: String = "KeyboardLayout"

        /// Integer raw value of the selected `NumericLayout`.
        static let NumericLayout: String = "NumericLayout"

        /// Integer raw value of the selected `StrokeLayout`.
        static let StrokeLayout: String = "StrokeLayout"

        /// Top-number-row, show or hide.
        static let NumberRow: String = "NumberRow"

        /// Lowercase key-labels, on or off.
        static let KeyCase: String = "KeyCase"

        /// Key text preview, on or off.
        static let KeyTextPreview: String = "KeyPreview"

        /// Integer offset in points applied to the keyboard's key height.
        static let KeyHeightOffset: String = "KeyHeightOffset"

        /// Integer raw value of the selected `InputKeyStyle`.
        static let InputKeyStyle: String = "InputKeyStyle"

        /// Integer raw value of the selected `AppearanceStyle`.
        static let AppearanceStyle: String = "AppearanceStyle"

        /// Integer raw value of the candidate annotation placement, represented by `CommentStyle`.
        static let CommentStyle: String = "CommentStyle"
        
        /// Integer raw value of `CommentScene`, controlling when candidate annotations appear.
        static let CommentScene: String = "CommentDisplayScene"

        /// Integer raw value of the annotation tone-number format, represented by `CommentToneStyle`.
        static let CommentToneStyle: String = "CommentToneStyle"

        /// Integer raw value of the selected `CangjieVariant`.
        static let CangjieVariant: String = "CangjieVariant"

        /// Emoji suggestions, on or off.
        static let EmojiSuggestions: String = "EmojiSuggestions"

        /// English suggestions, on or off.
        static let EnglishSuggestions: String = "EnglishSuggestions"

        /// Compatible input mode, on or off.
        static let SchemeRules: String = "SchemeRules"

        /// System text replacement, on or off.
        static let SystemLexicon: String = "SystemLexicon"

        /// InputMemory, on or off.
        static let UserLexiconInputMemory: String = "UserLexiconInputMemory"

        // @available(*, deprecated)
        // static let PasteButtonStyle: String = "PasteButtonStyle"
}
