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
        let lexiconResetButton = UIButton()
        
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
                
                addSubview(lexiconResetButton)
                lexiconResetButton.translatesAutoresizingMaskIntoConstraints = false
                lexiconResetButton.topAnchor.constraint(equalTo: audioFeedbackTextLabel.bottomAnchor, constant: 60).isActive = true
                lexiconResetButton.leadingAnchor.constraint(equalTo: audioFeedbackTextLabel.leadingAnchor).isActive = true
                lexiconResetButton.trailingAnchor.constraint(equalTo: audioFeedbackSwitch.trailingAnchor).isActive = true
                lexiconResetButton.setTitle(NSLocalizedString("Clear user lexicon", comment: ""), for: .normal)
                lexiconResetButton.setTitleColor(.systemBlue, for: .normal)
                lexiconResetButton.setTitleColor(.systemGreen, for: .highlighted)
                lexiconResetButton.layer.cornerRadius = 8
                lexiconResetButton.layer.cornerCurve = .continuous
        }
}
