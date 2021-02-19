import UIKit

extension KeyboardViewController {
        
        func setupKeyboard() {
                DispatchQueue.main.async {
                        self.setupKeyboardLayout()
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
                case .emoji:
                        setupEmojiKeyboard()
                default:
                        setup(layout: keyboardLayout)
                }
        }
        
        
        // MARK: - Normal Layouts
        
        private func setup(layout: KeyboardLayout) {
                keyboardStackView.removeAllArrangedSubviews()
                toolBar.tintColor = isDarkAppearance ? .white : .black
                if !UIPasteboard.general.hasStrings {
                        toolBar.pasteButton.tintColor = .systemGray
                }
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


        // MARK: - Emoji Keyboard

        func setupEmojiKeyboard() {
                let height: CGFloat = view.frame.height
                keyboardStackView.removeAllArrangedSubviews()
                emojiBoard.heightAnchor.constraint(equalToConstant: height + 50).isActive = true
                emojiBoard.addSubview(emojiCollectionView)
                emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        emojiCollectionView.bottomAnchor.constraint(equalTo: emojiBoard.indicatorsStackView.topAnchor),
                        emojiCollectionView.leadingAnchor.constraint(equalTo: emojiBoard.leadingAnchor),
                        emojiCollectionView.trailingAnchor.constraint(equalTo: emojiBoard.trailingAnchor),
                        emojiCollectionView.topAnchor.constraint(equalTo: emojiBoard.topAnchor)
                ])
                (emojiCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
                keyboardStackView.addArrangedSubview(emojiBoard)
                _ = emojiBoard.indicatorsStackView.arrangedSubviews.map({ ($0 as? Indicator)?.addTarget(self, action: #selector(handleIndicator(_:)), for: .touchDown) })
        }
        @objc func handleIndicator(_ sender: Indicator) {
                hapticFeedback?.impactOccurred()
                AudioFeedback.perform(audioFeedback: .modify)
                let indexPath: IndexPath = IndexPath(row: 15, section: sender.index)
                emojiCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }


        // MARK: - CandidateBoard
        
        var candidateBoardCollectionViewConstraints: [NSLayoutConstraint] {
                [candidateCollectionView.bottomAnchor.constraint(equalTo: candidateBoard.bottomAnchor),
                 candidateCollectionView.leadingAnchor.constraint(equalTo: candidateBoard.leadingAnchor),
                 candidateCollectionView.trailingAnchor.constraint(equalTo: candidateBoard.upArrowButton.leadingAnchor),
                 candidateCollectionView.topAnchor.constraint(equalTo: candidateBoard.topAnchor)]
        }
        private func setupCandidateBoard() {
                let height: CGFloat = view.frame.height
                keyboardStackView.removeAllArrangedSubviews()
                candidateCollectionView.removeFromSuperview()
                NSLayoutConstraint.deactivate(toolBar.collectionViewConstraints)
                
                candidateBoard.heightAnchor.constraint(equalToConstant: height).isActive = true
                candidateBoard.addSubview(candidateCollectionView)
                candidateCollectionView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(candidateBoardCollectionViewConstraints)
                (candidateCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .vertical
                
                candidateBoard.upArrowButton.tintColor = isDarkAppearance ? .white : .black
                candidateBoard.upArrowButton.addTarget(self, action: #selector(dismissCandidateBoard), for: .allTouchEvents)
                
                keyboardStackView.addArrangedSubview(candidateBoard)
        }
        @objc private func dismissCandidateBoard() {
                candidateCollectionView.removeFromSuperview()
                NSLayoutConstraint.deactivate(candidateBoardCollectionViewConstraints)
                toolBar.reinit()
                keyboardLayout = .jyutping
        }
        
        
        // MARK: - SettingsView
        
        private func setupSettingsView() {
                let height: CGFloat = view.frame.height
                keyboardStackView.removeAllArrangedSubviews()
                
                let extend: CGFloat = {
                        if traitCollection.userInterfaceIdiom == .phone && traitCollection.verticalSizeClass == .compact {
                                return 50
                        } else {
                                return 120
                        }
                }()
                
                // FIXME: - Unable to simultaneously satisfy constraints
                settingsView.heightAnchor.constraint(equalToConstant: height + extend).isActive = true
                
                let upArrowButton: ToolButton = ToolButton(imageName: "chevron.up", topInset: 6, bottomInset: 6, leftInset: 15, rightInset: 55)
                settingsView.addSubview(upArrowButton)
                upArrowButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(
                        [upArrowButton.topAnchor.constraint(equalTo: settingsView.topAnchor),
                         upArrowButton.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor),
                         upArrowButton.widthAnchor.constraint(equalToConstant: 100),
                         upArrowButton.heightAnchor.constraint(equalToConstant: 44)]
                )
                upArrowButton.tintColor = isDarkAppearance ? .white : .black
                upArrowButton.addTarget(self, action: #selector(dismissSettingsView), for: .touchUpInside)
                
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
