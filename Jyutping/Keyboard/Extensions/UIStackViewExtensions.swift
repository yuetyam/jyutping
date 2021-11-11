import UIKit

extension UIStackView {
        
        /// Use `addArrangedSubview` to add subviews to the end of the `arrangedSubviews` array.
        /// - Parameter views: The views to be added to the array of views arranged by the stack.
        func addArrangedSubviews(_ views: [UIView]) {
                _ = views.map { addArrangedSubview($0) }
        }
        
        /// Remove all arranged subviews from the stack.
        func removeArrangedSubviews() {
                _ = arrangedSubviews.map {
                        removeArrangedSubview($0)
                        $0.removeFromSuperview()
                }
                _ = subviews.map { $0.removeFromSuperview() }
        }
}
