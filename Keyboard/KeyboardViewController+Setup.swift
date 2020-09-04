import UIKit

extension KeyboardViewController {
        
        func setupKeyboard() {
                DispatchQueue.main.async {
                        self.setupKeyboardLayout()
                        
                        // FIXME: - crash on iPad floating if no check
                        if self.traitCollection.userInterfaceIdiom == .pad &&
                                (self.traitCollection.horizontalSizeClass == .compact || self.view.frame.width < 500) {
                                self.view.setNeedsLayout()
                        } else {
                                self.view.layoutIfNeeded()
                        }
                }
        }
        private func setupKeyboardLayout() {
                switch keyboardLayout {
                case .candidateBoard:
                        setupCandidateBoard()
                case .settingsView:
                        setupSettingsView()
                case .numberPad, .decimalPad:
                        setupNumberPad()
                default:
                        setup(layout: keyboardLayout)
                }
        }
        
        
        // MARK: - Normal Layouts
        
        private func setup(layout: KeyboardLayout) {
                keyboardStackView.removeAllArrangedSubviews()
                toolBar.tintColor = isDarkAppearance ? .darkButtonText : .lightButtonText
                toolBar.update()
                keyboardStackView.addArrangedSubview(toolBar)
                let keysRows: [UIStackView] = makeKeysRows(for: layout.keys(for: self))
                keyboardStackView.addMultipleArrangedSubviews(keysRows)
                toolBar.yueEngSwitch.selectedSegmentIndex = keyboardLayout.isEnglish ? 1 : 0
        }
        
        
        // MARK: - NumberPad & DecimalPad
        
        private func setupNumberPad() {
                keyboardStackView.removeAllArrangedSubviews()
                let digits: [[Int]] = [[1, 2, 3],
                                       [4, 5, 6],
                                       [7, 8, 9]]
                let keysRows: [UIStackView] = digits.map { makeDigitsRow(for: $0) }
                keyboardStackView.addMultipleArrangedSubviews(keysRows)
                
                let bottomStackView: UIStackView = UIStackView()
                bottomStackView.distribution = .fillProportionally
                if keyboardLayout == .numberPad {
                        bottomStackView.addArrangedSubview(NumberPadEmptyKey())
                } else {
                        bottomStackView.addArrangedSubview(PeriodButton(viewController: self))
                }
                bottomStackView.addArrangedSubview(NumberButton(digit: 0, viewController: self))
                bottomStackView.addArrangedSubview(BackspaceButton(viewController: self))
                
                keyboardStackView.addArrangedSubview(bottomStackView)
        }
        private func makeDigitsRow(for digits: [Int]) -> UIStackView {
                let stackView: UIStackView = UIStackView()
                stackView.distribution = .fillProportionally
                stackView.addMultipleArrangedSubviews(digits.map { NumberButton(digit: $0, viewController: self) })
                return stackView
        }
        
        
        // MARK: - CandidateBoard
        
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
        
        
        // MARK: - SettingsView
        
        private func setupSettingsView() {
                let height: CGFloat = view.frame.height
                keyboardStackView.removeAllArrangedSubviews()
                
                // FIXME: - Unable to simultaneously satisfy constraints
                settingsView.heightAnchor.constraint(equalToConstant: height + 50).isActive = true
                
                let upArrowButton: ToolButton = ToolButton(imageName: "chevron.up", topInset: 10, bottomInset: 10, leftInset: 12)
                settingsView.addSubview(upArrowButton)
                upArrowButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(
                        [upArrowButton.topAnchor.constraint(equalTo: settingsView.topAnchor),
                         upArrowButton.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor),
                         upArrowButton.trailingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 70),
                         upArrowButton.heightAnchor.constraint(equalToConstant: 50)]
                )
                upArrowButton.tintColor = isDarkAppearance ? .white : .black
                upArrowButton.addTarget(self, action: #selector(dismissSettingsView), for: .allTouchEvents)
                
                settingsView.addSubview(settingsTableView)
                settingsTableView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(
                        [settingsTableView.topAnchor.constraint(equalTo: upArrowButton.bottomAnchor),
                         settingsTableView.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor),
                         settingsTableView.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor),
                         settingsTableView.bottomAnchor.constraint(equalTo: settingsView.bottomAnchor)]
                )
                
                keyboardStackView.addArrangedSubview(settingsView)
        }
        @objc private func dismissSettingsView() {
                keyboardLayout = askedKeyboardLayout
        }
        
        
        // MARK: - Make Keys
        
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
