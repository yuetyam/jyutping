import UIKit

final class SettingsView: UIView {
        
        var height: CGFloat = 270 {
                didSet {
                        heightAnchor.constraint(equalToConstant: height).isActive = true
                }
        }
        
        let upArrowButton: ToolButton = ToolButton(imageName: "chevron.up", leftInset: 14, rightInset: 14)
        let audioFeedbackTextLabel: UILabel = UILabel()
        let audioFeedbackSwitch: UISwitch = UISwitch()
        let userdbResetButton = UIButton()
        
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
                upArrowButton.bottomAnchor.constraint(equalTo: topAnchor, constant: 60).isActive = true
                upArrowButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                upArrowButton.trailingAnchor.constraint(equalTo: leadingAnchor, constant: 67).isActive = true
                
                addSubview(audioFeedbackTextLabel)
                audioFeedbackTextLabel.translatesAutoresizingMaskIntoConstraints = false
                audioFeedbackTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -30).isActive = true
                audioFeedbackTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30).isActive = true
                audioFeedbackTextLabel.text = NSLocalizedString("Audio feedback on click", comment: "")
                
                addSubview(audioFeedbackSwitch)
                audioFeedbackSwitch.translatesAutoresizingMaskIntoConstraints = false
                audioFeedbackSwitch.leadingAnchor.constraint(equalTo: audioFeedbackTextLabel.trailingAnchor, constant: 16).isActive = true
                audioFeedbackSwitch.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -30).isActive = true
                audioFeedbackSwitch.layer.cornerRadius = 15
                audioFeedbackSwitch.layer.cornerCurve = .continuous
                
                addSubview(userdbResetButton)
                userdbResetButton.translatesAutoresizingMaskIntoConstraints = false
                userdbResetButton.topAnchor.constraint(equalTo: audioFeedbackTextLabel.bottomAnchor, constant: 60).isActive = true
                userdbResetButton.leadingAnchor.constraint(equalTo: audioFeedbackTextLabel.leadingAnchor, constant: -4).isActive = true
                userdbResetButton.trailingAnchor.constraint(equalTo: audioFeedbackSwitch.trailingAnchor, constant: 4).isActive = true
                userdbResetButton.setTitle(NSLocalizedString("Clear user phrases", comment: ""), for: .normal)
                userdbResetButton.setTitleColor(.systemBlue, for: .normal)
                userdbResetButton.setTitleColor(.systemGreen, for: .highlighted)
                userdbResetButton.layer.cornerRadius = 8
                userdbResetButton.layer.cornerCurve = .continuous
        }
}
