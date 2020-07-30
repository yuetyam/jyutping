import UIKit

final class ArrowButton: UIButton {
        convenience init(imageName: String, topInset: CGFloat = 4, leftInset: CGFloat = 10, bottomInset: CGFloat = 8, rightInset: CGFloat = 10) {
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
