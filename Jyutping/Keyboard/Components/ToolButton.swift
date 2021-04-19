import UIKit

final class ToolButton: UIButton {
        init(imageName: String, topInset: CGFloat = 0, bottomInset: CGFloat = 0, leftInset: CGFloat = 0, rightInset: CGFloat = 0) {
                super.init(frame: .zero)
                backgroundColor = .interactiveClear
                let buttonImageView: UIImageView = UIImageView()
                addSubview(buttonImageView)
                buttonImageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        buttonImageView.topAnchor.constraint(equalTo: topAnchor, constant: topInset),
                        buttonImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomInset),
                        buttonImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftInset),
                        buttonImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -rightInset)
                ])
                buttonImageView.contentMode = .scaleAspectFit
                buttonImageView.image = UIImage(systemName: imageName)
        }
        required init?(coder: NSCoder) { fatalError("ToolButton.init(coder:) error") }
}
