import UIKit

extension KeyboardViewController {

        func setupKeyboard() {
                DispatchQueue.main.async { [unowned self] in
                        self.loadKeyboard()
                }
        }
        private func loadKeyboard() {
                switch keyboardLayout {
                case .candidateBoard:
                        loadCandidateBoard()
                case .settingsView:
                        loadSettingsView()
                case .numberPad, .decimalPad:
                        loadNumberPad()
                case .emoji:
                        loadEmojiKeyboard()
                default:
                        load(layout: keyboardLayout)
                }
        }


        // MARK: - Normal Layouts

        private func load(layout: KeyboardLayout) {
                keyboardStackView.removeAllArrangedSubviews()
                toolBar.tintColor = isDarkAppearance ? .white : .black
                toolBar.yueEngSwitch.update(isDarkAppearance: isDarkAppearance, switched: keyboardLayout.isEnglishMode)
                if !UIPasteboard.general.hasStrings {
                        toolBar.pasteButton.tintColor = .systemGray
                }
                keyboardStackView.addArrangedSubview(toolBar)
                let events: [[KeyboardEvent]] = layout.events(needsInputModeSwitchKey: needsInputModeSwitchKey, arrangement: arrangement)
                let keysRows: [UIStackView] = makeKeysRows(for: events)
                keyboardStackView.addMultipleArrangedSubviews(keysRows)
        }


        // MARK: - NumberPad & DecimalPad

        private func loadNumberPad() {
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
                        bottomStackView.addArrangedSubview(PointButton(controller: self))
                }
                bottomStackView.addArrangedSubview(NumberButton(digit: 0, controller: self))
                bottomStackView.addArrangedSubview(BackspaceButton(controller: self))
                
                keyboardStackView.addArrangedSubview(bottomStackView)
        }
        private func makeDigitsRow(for digits: [Int]) -> UIStackView {
                let stackView: UIStackView = UIStackView()
                stackView.distribution = .fillProportionally
                stackView.addMultipleArrangedSubviews(digits.map { NumberButton(digit: $0, controller: self) })
                return stackView
        }


        // MARK: - Emoji Keyboard

        private func loadEmojiKeyboard() {
                let height: CGFloat = view.frame.height
                keyboardStackView.removeAllArrangedSubviews()
                let extended: CGFloat = traitCollection.verticalSizeClass == .compact ? height : height + 50
                emojiBoard.addSubview(emojiCollectionView)
                emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        emojiBoard.heightAnchor.constraint(equalToConstant: extended),
                        emojiCollectionView.bottomAnchor.constraint(equalTo: emojiBoard.indicatorsStackView.topAnchor),
                        emojiCollectionView.leadingAnchor.constraint(equalTo: emojiBoard.leadingAnchor),
                        emojiCollectionView.trailingAnchor.constraint(equalTo: emojiBoard.trailingAnchor),
                        emojiCollectionView.topAnchor.constraint(equalTo: emojiBoard.topAnchor)
                ])
                (emojiCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
                keyboardStackView.addArrangedSubview(emojiBoard)
                emojiBoard.globeKey.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
                _ = emojiBoard.indicatorsStackView.arrangedSubviews.map({ ($0 as? Indicator)?.addTarget(self, action: #selector(handleIndicator(_:)), for: .touchDown) })
        }
        @objc func handleIndicator(_ sender: Indicator) {
                hapticFeedback?.impactOccurred()
                AudioFeedback.perform(.modify)
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
        private func loadCandidateBoard() {
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
                candidateBoard.upArrowButton.addTarget(self, action: #selector(dismissCandidateBoard), for: .touchUpInside)

                keyboardStackView.addArrangedSubview(candidateBoard)
        }
        @objc private func dismissCandidateBoard() {
                candidateCollectionView.removeFromSuperview()
                NSLayoutConstraint.deactivate(candidateBoardCollectionViewConstraints)
                toolBar.reset()
                keyboardLayout = .cantonese(.lowercased)
        }
        
        
        // MARK: - SettingsView

        private func loadSettingsView() {
                let height: CGFloat = view.frame.height
                keyboardStackView.removeAllArrangedSubviews()
                let extended: CGFloat = traitCollection.verticalSizeClass == .compact ? height : height + 120
                let upArrowButton: ToolButton = ToolButton(imageName: "chevron.up", topInset: 6, bottomInset: 6, leftInset: 15, rightInset: 55)
                settingsView.addSubview(upArrowButton)
                upArrowButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        // FIXME: - Unable to simultaneously satisfy constraints
                        settingsView.heightAnchor.constraint(equalToConstant: extended),
                        upArrowButton.topAnchor.constraint(equalTo: settingsView.topAnchor),
                        upArrowButton.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor),
                        upArrowButton.widthAnchor.constraint(equalToConstant: 100),
                        upArrowButton.heightAnchor.constraint(equalToConstant: 44)
                ])
                upArrowButton.tintColor = isDarkAppearance ? .white : .black
                upArrowButton.addTarget(self, action: #selector(dismissSettingsView), for: .touchUpInside)
                upArrowButton.accessibilityLabel = NSLocalizedString("Switch back to Keyboard", comment: "")
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
                let keysRows: [UIStackView] = eventsRows.map { [unowned self] in makeRow(for: $0) }
                return keysRows
        }
        private func makeRow(for events: [KeyboardEvent]) -> UIStackView {
                let stackView: UIStackView = UIStackView()
                stackView.axis = .horizontal
                stackView.distribution = .fillProportionally
                let keys: [KeyView] = events.map { [unowned self] in makeKey(for: $0, controller: self) }
                stackView.addMultipleArrangedSubviews(keys)
                return stackView
        }
        private func makeKey(for event: KeyboardEvent, controller: KeyboardViewController) -> KeyView {
                let key: KeyView = KeyView(event: event, controller: controller)
                if event == .switchInputMethod {
                        let virtual = UIButton()
                        virtual.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
                        key.addSubview(virtual)
                        virtual.translatesAutoresizingMaskIntoConstraints = false
                        NSLayoutConstraint.activate([
                                virtual.topAnchor.constraint(equalTo: key.topAnchor),
                                virtual.bottomAnchor.constraint(equalTo: key.bottomAnchor),
                                virtual.leadingAnchor.constraint(equalTo: key.leadingAnchor),
                                virtual.trailingAnchor.constraint(equalTo: key.trailingAnchor)
                        ])
                }
                return key
        }
}
