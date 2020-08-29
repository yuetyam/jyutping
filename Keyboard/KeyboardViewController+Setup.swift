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
                case .candidateBoard:
                        setupCandidateBoard()
                case .settingsView:
                        setupSettingsView()
                default:
                        setup(layout: keyboardLayout)
                }
        }
        
        private func setup(layout: KeyboardLayout) {
                toolBar.tintColor = isDarkAppearance ? .darkButtonText : .lightButtonText
                toolBar.update()
                keyboardStackView.addArrangedSubview(toolBar)
                let keysRows: [UIStackView] = makeKeysRows(for: layout.keys(for: self))
                keyboardStackView.addMultipleArrangedSubviews(keysRows)
        }
        
        var candidateBoardcollectionViewConstraints: [NSLayoutConstraint] {
                [collectionView.bottomAnchor.constraint(equalTo: candidateBoard.bottomAnchor),
                 collectionView.leadingAnchor.constraint(equalTo: candidateBoard.leadingAnchor),
                 collectionView.trailingAnchor.constraint(equalTo: candidateBoard.upArrowButton.leadingAnchor),
                 collectionView.topAnchor.constraint(equalTo: candidateBoard.topAnchor)]
        }
        private func setupCandidateBoard() {
                collectionView.removeFromSuperview()
                NSLayoutConstraint.deactivate(toolBar.collectionViewConstraints)
                
                candidateBoard.addSubview(collectionView)
                collectionView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(candidateBoardcollectionViewConstraints)
                (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .vertical
                
                candidateBoard.upArrowButton.tintColor = isDarkAppearance ? .darkButtonText : .lightButtonText
                candidateBoard.upArrowButton.addTarget(self, action: #selector(dismissCandidateBoard), for: .allTouchEvents)
                
                keyboardStackView.addArrangedSubview(candidateBoard)
        }
        @objc private func dismissCandidateBoard() {
                collectionView.removeFromSuperview()
                NSLayoutConstraint.deactivate(candidateBoardcollectionViewConstraints)
                toolBar.reinit()
                keyboardLayout = .jyutping
        }
        
        private func setupSettingsView() {
                settingsView.upArrowButton.tintColor = isDarkAppearance ? .darkButtonText : .lightButtonText
                settingsView.upArrowButton.addTarget(self, action: #selector(dismissSettingsView), for: .allTouchEvents)
                
                let bgColor: UIColor = isDarkAppearance ?
                        UIColor(displayP3Red: 35.0 / 255, green: 35.0 / 255, blue: 35.0 / 255, alpha: 1) :
                        UIColor(displayP3Red: 208.0 / 255, green: 211.0 / 255, blue: 216.0 / 255, alpha: 1)
                settingsView.audioFeedbackSwitch.backgroundColor = bgColor
                settingsView.audioFeedbackSwitch.isOn = UserDefaults.standard.bool(forKey: "audio_feedback")
                settingsView.audioFeedbackSwitch.addTarget(self, action: #selector(handleAudioFeedbackSwitch), for: .allTouchEvents)
                
                settingsView.lexiconResetButton.backgroundColor = isDarkAppearance ? .black : .white
                settingsView.lexiconResetButton.addTarget(self, action: #selector(resetLexicon(sender:)), for: .touchUpInside)
                
                keyboardStackView.addArrangedSubview(settingsView)
        }
        @objc private func dismissSettingsView() {
                keyboardLayout = .jyutping
        }
        @objc private func handleAudioFeedbackSwitch() {
                if UserDefaults.standard.bool(forKey: "audio_feedback") {
                        UserDefaults.standard.set(false, forKey: "audio_feedback")
                } else {
                        UserDefaults.standard.set(true, forKey: "audio_feedback")
                }
        }
        @objc private func resetLexicon(sender: UIButton) {
                imeQueue.async {
                        self.lexiconManager.deleteAll()
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
                animation.timingFunction = CAMediaTimingFunction(name: .default)
                progressLayer.add(animation, forKey: nil)
        }
        
        private func makeKeysRows(for eventsRows: [[KeyboardEvent]]) -> [UIStackView] {
                let keysRows: [UIStackView] = eventsRows.map { makeKeysRow(for: $0) }
                return keysRows
        }
        private func makeKeysRow(for events: [KeyboardEvent]) -> UIStackView {
                let stackView: UIStackView = UIStackView()
                stackView.axis = .horizontal
                stackView.distribution = .fillProportionally
                stackView.addMultipleArrangedSubviews(events.map { makeKey(for: $0) })
                return stackView
        }
        private func makeKey(for event: KeyboardEvent) -> UIView {
                let keyView: KeyButton = KeyButton(keyboardEvent: event, viewController: self)
                if event == .switchInputMethod {
                        keyView.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
                }
                return keyView
        }
}
