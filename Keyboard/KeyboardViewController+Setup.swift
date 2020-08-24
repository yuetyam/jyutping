import UIKit

extension KeyboardViewController {
        
        func setupKeyboard() {
                DispatchQueue.main.async {
                        self.setupKeyboards()
                }
        }
        
        private func setupKeyboards() {
                keyboardStackView.removeAllArrangedSubviews()
                switch keyboardLayout {
                case .wordsBoard:
                        setupWordsBoard()
                case .settingsView:
                        setupSettingsView()
                default:
                        setup(layout: keyboardLayout)
                }
        }
        
        private func setup(layout: KeyboardLayout) {
                toolBar.tintColor = isDarkAppearance ? .darkButtonText : .lightButtonText
                keyboardStackView.addArrangedSubview(toolBar)
                let keysRows: [UIStackView] = makeKeysRows(for: layout.keys(for: self))
                keyboardStackView.addMultipleArrangedSubviews(keysRows)
        }
        
        private func setupWordsBoard() {
                wordsBoard.addSubview(collectionView)
                collectionView.translatesAutoresizingMaskIntoConstraints = false
                collectionView.bottomAnchor.constraint(equalTo: wordsBoard.bottomAnchor).isActive = true
                collectionView.leadingAnchor.constraint(equalTo: wordsBoard.leadingAnchor).isActive = true
                collectionView.trailingAnchor.constraint(equalTo: wordsBoard.upArrowButton.leadingAnchor).isActive = true
                collectionView.topAnchor.constraint(equalTo: wordsBoard.topAnchor).isActive = true
                let collectionViewFlowLayout = UICollectionViewFlowLayout()
                collectionViewFlowLayout.scrollDirection = .vertical
                collectionView.collectionViewLayout = collectionViewFlowLayout
                
                let tintColor: UIColor = isDarkAppearance ? .darkButtonText : .lightButtonText
                wordsBoard.upArrowButton.tintColor = tintColor
                wordsBoard.upArrowButton.addTarget(self, action: #selector(handleUpArrowEvent), for: .allTouchEvents)
                
                keyboardStackView.addArrangedSubview(wordsBoard)
        }
        private func setupSettingsView() {
                let audioFeedbackTextLabel: UILabel = UILabel()
                settingsView.addSubview(audioFeedbackTextLabel)
                audioFeedbackTextLabel.translatesAutoresizingMaskIntoConstraints = false
                audioFeedbackTextLabel.centerXAnchor.constraint(equalTo: settingsView.centerXAnchor, constant: -30).isActive = true
                audioFeedbackTextLabel.centerYAnchor.constraint(equalTo: settingsView.centerYAnchor, constant: -30).isActive = true
                audioFeedbackTextLabel.text = NSLocalizedString("Audio feedback on click", comment: "")
                
                let audioFeedbackSwitch: UISwitch = UISwitch()
                settingsView.addSubview(audioFeedbackSwitch)
                audioFeedbackSwitch.translatesAutoresizingMaskIntoConstraints = false
                audioFeedbackSwitch.leadingAnchor.constraint(equalTo: audioFeedbackTextLabel.trailingAnchor, constant: 16).isActive = true
                audioFeedbackSwitch.centerYAnchor.constraint(equalTo: settingsView.centerYAnchor, constant: -30).isActive = true
                audioFeedbackSwitch.isOn = UserDefaults.standard.bool(forKey: "audio_feedback")
                audioFeedbackSwitch.addTarget(self, action: #selector(handleAudioFeedbackSwitch), for: .allTouchEvents)
                
                let bgColor: UIColor = isDarkAppearance ?
                        UIColor(displayP3Red: 35.0 / 255, green: 35.0 / 255, blue: 35.0 / 255, alpha: 1) :
                        UIColor(displayP3Red: 208.0 / 255, green: 211.0 / 255, blue: 216.0 / 255, alpha: 1)
                audioFeedbackSwitch.backgroundColor = bgColor
                audioFeedbackSwitch.layer.cornerRadius = 15
                
                let userdbResetButton = UIButton()
                settingsView.addSubview(userdbResetButton)
                userdbResetButton.translatesAutoresizingMaskIntoConstraints = false
                userdbResetButton.topAnchor.constraint(equalTo: audioFeedbackTextLabel.bottomAnchor, constant: 60).isActive = true
                userdbResetButton.leadingAnchor.constraint(equalTo: audioFeedbackTextLabel.leadingAnchor).isActive = true
                userdbResetButton.trailingAnchor.constraint(equalTo: audioFeedbackSwitch.trailingAnchor).isActive = true
                userdbResetButton.setTitle(NSLocalizedString("Clear user's phrases", comment: ""), for: .normal)
                userdbResetButton.setTitleColor(.systemBlue, for: .normal)
                userdbResetButton.setTitleColor(.systemGreen, for: .highlighted)
                userdbResetButton.backgroundColor = isDarkAppearance ? .black : .white
                userdbResetButton.layer.cornerRadius = 8
                userdbResetButton.layer.cornerCurve = .continuous
                userdbResetButton.addTarget(self, action: #selector(resetUserDB(_:)), for: .touchUpInside)
                
                settingsView.upArrowButton.tintColor = isDarkAppearance ? .darkButtonText : .lightButtonText
                settingsView.upArrowButton.addTarget(self, action: #selector(handleUpArrowEvent), for: .allTouchEvents)
                
                keyboardStackView.addArrangedSubview(settingsView)
        }
        @objc private func handleUpArrowEvent() {
                keyboardLayout = .jyutping
                toolBar.update()
                collectionView.setContentOffset(.zero, animated: false)
        }
        @objc private func handleAudioFeedbackSwitch() {
                if UserDefaults.standard.bool(forKey: "audio_feedback") {
                        UserDefaults.standard.set(false, forKey: "audio_feedback")
                } else {
                        UserDefaults.standard.set(true, forKey: "audio_feedback")
                }
        }
        @objc private func resetUserDB(_ sender: UIButton) {
                candidateQueue.async {
                        self.userPhraseManager.deleteAll()
                }
                let progressLayer: CAShapeLayer = CAShapeLayer()
                progressLayer.path = CGPath(rect: CGRect(x: 10, y: 0, width: sender.frame.width - 20, height: sender.frame.height), transform: nil)
                progressLayer.fillColor = UIColor.clear.cgColor
                progressLayer.strokeColor = UIColor.systemBlue.cgColor
                progressLayer.strokeEnd = 0.0
                progressLayer.lineWidth = 2
                sender.layer.addSublayer(progressLayer)
                let animation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
                animation.fromValue = 0.0
                animation.toValue = 0.4
                animation.duration = 1
                progressLayer.add(animation, forKey: nil)
        }
        
        private func makeKeysRows(for eventsRows: [[KeyboardEvent]], distribution: UIStackView.Distribution = .fillProportionally) -> [UIStackView] {
                let keysRows: [UIStackView] = eventsRows.map { makeKeysRow(for: $0, distribution: distribution) }
                return keysRows
        }
        private func makeKeysRow(for events: [KeyboardEvent], distribution: UIStackView.Distribution) -> UIStackView {
                let stackView: UIStackView = UIStackView()
                stackView.axis = .horizontal
                stackView.distribution = distribution
                stackView.addMultipleArrangedSubviews(events.map { makeKey(for: $0, distribution: distribution) })
                return stackView
        }
        private func makeKey(for event: KeyboardEvent, distribution: UIStackView.Distribution) -> UIView {
                let keyView: KeyButton = KeyButton(keyboardEvent: event, viewController: self)
                if event == .switchInputMethod {
                        keyView.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
                }
                return keyView
        }
}
