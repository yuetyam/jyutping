import UIKit

final class CandidateBoard: UIView {

        let upArrowButton: ToolButton = .chevron(.up, topInset: 18, bottomInset: 18)

        init() {
                super.init(frame: .zero)
                addSubview(upArrowButton)
                upArrowButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        upArrowButton.topAnchor.constraint(equalTo: topAnchor),
                        upArrowButton.trailingAnchor.constraint(equalTo: trailingAnchor),
                        upArrowButton.bottomAnchor.constraint(equalTo: topAnchor, constant: 60),
                        upArrowButton.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -45)
                ])
                upArrowButton.accessibilityLabel = NSLocalizedString("Switch back to Keyboard", comment: .empty)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) { fatalError() }
}
