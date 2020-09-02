import UIKit

extension KeyboardViewController {
        
        func setupKeyboard() {
                DispatchQueue.main.async {
                        self.setupKeyboards()
                        self.view.layoutIfNeeded()
                }
        }
        private func setupKeyboards() {
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
                keyboardStackView.removeAllArrangedSubviews()
                toolBar.tintColor = isDarkAppearance ? .darkButtonText : .lightButtonText
                toolBar.update()
                keyboardStackView.addArrangedSubview(toolBar)
                let keysRows: [UIStackView] = makeKeysRows(for: layout.keys(for: self))
                keyboardStackView.addMultipleArrangedSubviews(keysRows)
        }
        
        var candidateBoardCollectionViewConstraints: [NSLayoutConstraint] {
                [collectionView.bottomAnchor.constraint(equalTo: candidateBoard.bottomAnchor),
                 collectionView.leadingAnchor.constraint(equalTo: candidateBoard.leadingAnchor),
                 collectionView.trailingAnchor.constraint(equalTo: candidateBoard.upArrowButton.leadingAnchor),
                 collectionView.topAnchor.constraint(equalTo: candidateBoard.topAnchor)]
        }
        private func setupCandidateBoard() {
                candidateBoard.height = view.bounds.height
                keyboardStackView.removeAllArrangedSubviews()
                collectionView.removeFromSuperview()
                NSLayoutConstraint.deactivate(toolBar.collectionViewConstraints)
                
                candidateBoard.addSubview(collectionView)
                collectionView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(candidateBoardCollectionViewConstraints)
                (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .vertical
                
                candidateBoard.upArrowButton.tintColor = isDarkAppearance ? .darkButtonText : .lightButtonText
                candidateBoard.upArrowButton.addTarget(self, action: #selector(dismissCandidateBoard), for: .allTouchEvents)
                
                keyboardStackView.addArrangedSubview(candidateBoard)
        }
        @objc private func dismissCandidateBoard() {
                collectionView.removeFromSuperview()
                NSLayoutConstraint.deactivate(candidateBoardCollectionViewConstraints)
                toolBar.reinit()
                keyboardLayout = .jyutping
        }
        
        private func setupSettingsView() {
                settingsView.heightAnchor.constraint(equalToConstant: view.bounds.height + 50).isActive = true
                settingsView.addSubview(settingsTableView)
                settingsTableView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(
                        [settingsTableView.bottomAnchor.constraint(equalTo: settingsView.bottomAnchor),
                         settingsTableView.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor),
                         settingsTableView.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor),
                         settingsTableView.heightAnchor.constraint(equalToConstant: view.bounds.height)]
                )
                let upArrowButton: ToolButton = ToolButton(imageName: "chevron.up", topInset: 10, bottomInset: 10, leftInset: 12)
                settingsView.addSubview(upArrowButton)
                upArrowButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(
                        [upArrowButton.bottomAnchor.constraint(equalTo: settingsTableView.topAnchor),
                         upArrowButton.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor),
                         upArrowButton.trailingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 70),
                         upArrowButton.heightAnchor.constraint(equalToConstant: 50)]
                )
                upArrowButton.tintColor = isDarkAppearance ? .white : .black
                upArrowButton.addTarget(self, action: #selector(dismissSettingsView), for: .allTouchEvents)
                keyboardStackView.removeAllArrangedSubviews()
                keyboardStackView.addArrangedSubview(settingsView)
        }
        @objc private func dismissSettingsView() {
                keyboardLayout = .jyutping
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
