import UIKit

extension UIStackView {
        
        /// Use `addArrangedSubview` to add subviews to the end of the `arrangedSubviews` array.
        /// - Parameter subviews: The views to be added to the array of views arranged by the stack.
        func addMultipleArrangedSubviews(_ subviews: [UIView]) {
                _ = subviews.map { addArrangedSubview($0) }
        }
        
        /// Remove all arranged subviews from the stack.
        func removeAllArrangedSubviews() {
                _ = arrangedSubviews.map {
                        removeArrangedSubview($0)
                        NSLayoutConstraint.deactivate($0.constraints)
                        $0.removeFromSuperview()
                }
        }
}
