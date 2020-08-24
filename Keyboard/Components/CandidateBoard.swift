import UIKit

final class CandidateBoard: UIView {
        
        var height: CGFloat = 270 {
                didSet {
                        heightAnchor.constraint(equalToConstant: height).isActive = true
                }
        }
        
        let upArrowButton: ToolButton = ToolButton(imageName: "chevron.up")
        
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
                upArrowButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
                upArrowButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
                upArrowButton.bottomAnchor.constraint(equalTo: topAnchor, constant: 60).isActive = true
                upArrowButton.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -45).isActive = true
        }
}
