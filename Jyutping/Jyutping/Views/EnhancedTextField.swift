import SwiftUI

struct EnhancedTextField: UIViewRepresentable {
        
        private let placeholder: String
        @Binding private var text: String
        
        private let font: UIFont?
        private let keyboardAppearance: UIKeyboardAppearance?
        private let keyboardType: UIKeyboardType?
        private let returnKey: UIReturnKeyType?
        private let autocorrection: UITextAutocorrectionType?
        private let autocapitalization: UITextAutocapitalizationType?

        init(placeholder: String,
             text: Binding<String>,
             font: UIFont? = nil,
             keyboardAppearance: UIKeyboardAppearance? = nil,
             keyboardType: UIKeyboardType? = nil,
             returnKey: UIReturnKeyType? = nil,
             autocorrection: UITextAutocorrectionType? = nil,
             autocapitalization: UITextAutocapitalizationType? = nil) {
                self.placeholder = placeholder
                self._text = text
                self.font = font
                self.keyboardAppearance = keyboardAppearance
                self.keyboardType = keyboardType
                self.returnKey = returnKey
                self.autocorrection = autocorrection
                self.autocapitalization = autocapitalization
        }
        
        func makeUIView(context: Context) -> UITextField {
                let textField = UITextField(frame: .zero)
                textField.placeholder = placeholder
                textField.font = font
                if let keyboardAppearance = keyboardAppearance {
                        textField.keyboardAppearance = keyboardAppearance
                }
                if let keyboardType = keyboardType {
                        textField.keyboardType = keyboardType
                }
                if let returnKeyType = returnKey {
                        textField.returnKeyType = returnKeyType
                }
                if let autocorrectionType = autocorrection {
                        textField.autocorrectionType = autocorrectionType
                }
                if let autocapitalizationType = autocapitalization {
                        textField.autocapitalizationType = autocapitalizationType
                }
                textField.clearButtonMode = .always
                textField.delegate = context.coordinator
                textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
                textField.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
                return textField
        }
        func updateUIView(_ uiView: UITextField, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
                Coordinator(self)
        }
        final class Coordinator: NSObject, UITextFieldDelegate {
                private let parent: EnhancedTextField
                init(_ parent: EnhancedTextField) {
                        self.parent = parent
                }
                func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                        parent.text = textField.text ?? parent.placeholder
                        return textField.resignFirstResponder()
                }
        }
}
