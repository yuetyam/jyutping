import UIKit

final class CandidateBoard: UIView {
        
        let upArrowButton: ToolButton = ToolButton(imageName: "chevron.up", topInset: 18, bottomInset: 18)
        
        init() {
                super.init(frame: .zero)
                setupSubViews()
        }
        
        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
        
        private func setupSubViews() {
                addSubview(upArrowButton)
                upArrowButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        upArrowButton.topAnchor.constraint(equalTo: topAnchor),
                        upArrowButton.trailingAnchor.constraint(equalTo: trailingAnchor),
                        upArrowButton.bottomAnchor.constraint(equalTo: topAnchor, constant: 60),
                        upArrowButton.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -45)
                ])
        }
}
