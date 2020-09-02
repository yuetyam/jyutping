import UIKit

final class ToolButton: UIButton {
        convenience init(imageName: String, topInset: CGFloat = 0, bottomInset: CGFloat = 0, leftInset: CGFloat = 8, rightInset: CGFloat = 8) {
                self.init(frame: .zero)
                let arrowImageView: UIImageView = UIImageView()
                addSubview(arrowImageView)
                arrowImageView.translatesAutoresizingMaskIntoConstraints = false
                arrowImageView.topAnchor.constraint(equalTo: topAnchor, constant: topInset).isActive = true
                arrowImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomInset).isActive = true
                arrowImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftInset).isActive = true
                arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -rightInset).isActive = true
                arrowImageView.contentMode = .scaleAspectFit
                arrowImageView.image = UIImage(systemName: imageName)
                backgroundColor = .clearTappable
        }
}
