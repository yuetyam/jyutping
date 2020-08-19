import SwiftUI

struct  EnhancedTextField: UIViewRepresentable {
        
        let placeholder: String
        @Binding var text: String
        let returnKeyType: UIReturnKeyType
        
        func makeUIView(context: Context) -> UITextField {
                let textField = UITextField(frame: .zero)
                textField.placeholder = placeholder
                textField.delegate = context.coordinator
                textField.returnKeyType = returnKeyType
                textField.clearButtonMode = .always
                return textField
        }
        func updateUIView(_ uiView: UITextField, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
                Coordinator(self)
        }
        final class Coordinator: NSObject, UITextFieldDelegate {
                var parent:  EnhancedTextField
                init(_ view:  EnhancedTextField) {
                        parent = view
                }
                func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                        parent.text = textField.text ?? parent.placeholder
                        return textField.resignFirstResponder()
                }
        }
}
