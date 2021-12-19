import UIKit

extension KeyboardViewController {

        func setupKeyboard() {
                switch keyboardIdiom {
                case .candidateBoard:
                        loadCandidateBoard()
                case .settingsView:
                        loadSettingsView()
                case .numberPad, .decimalPad:
                        loadNumberPad()
                case .emoji:
                        loadEmojiKeyboard()
                default:
                        loadKeys()
                }
        }

        func updateBottomStackView(with newEvent: KeyboardEvent) {
                let bottomEvents: [KeyboardEvent] = needsInputModeSwitchKey ?
                        [.transform(.cantoneseNumeric), .globe, .space, newEvent, .newLine] :
                        [.transform(.cantoneseNumeric), newEvent, .space, .newLine]
                let bottomViews: [KeyView] = bottomEvents.map { [unowned self] in
                        return makeKey(for: $0, controller: self)
                }
                bottomStackView.removeArrangedSubviews()
                bottomStackView.addArrangedSubviews(bottomViews)
        }

        // MARK: - Normal Layouts

        private func loadKeys() {
                keyboardStackView.removeArrangedSubviews()
                toolBar.tintColor = isDarkAppearance ? .white : .black
                toolBar.yueEngSwitch.update(isDarkAppearance: isDarkAppearance, switched: keyboardIdiom.isEnglishMode)
                if !UIPasteboard.general.hasStrings {
                        toolBar.pasteButton.tintColor = .systemGray
                }
                keyboardStackView.addArrangedSubview(toolBar)
                let events: [[KeyboardEvent]] = keyboardIdiom.events(for: keyboardLayout, needsInputModeSwitchKey: needsInputModeSwitchKey)
                let keysRows: [UIStackView] = makeKeysRows(for: events.dropLast())
                keyboardStackView.addArrangedSubviews(keysRows)
                guard let bottomEvents: [KeyboardEvent] = events.last else { return }
                let bottomViews: [KeyView] = bottomEvents.map { [unowned self] in
                        if $0 == .text(.cantoneseComma) && !inputText.isEmpty {
                                return KeyView(event: .text(.separator), controller: self)
                        }
                        return makeKey(for: $0, controller: self)
                }
                bottomStackView.removeArrangedSubviews()
                bottomStackView.addArrangedSubviews(bottomViews)
                keyboardStackView.addArrangedSubview(bottomStackView)
        }


        // MARK: - NumberPad & DecimalPad

        private func loadNumberPad() {
                keyboardStackView.removeArrangedSubviews()
                let digits: [[Int]] = [[1, 2, 3],
                                       [4, 5, 6],
                                       [7, 8, 9]]
                let keysRows: [UIStackView] = digits.map { makeDigitsRow(for: $0) }
                keyboardStackView.addArrangedSubviews(keysRows)

                let bottomStackView: UIStackView = UIStackView()
                bottomStackView.distribution = .fillProportionally
                if keyboardIdiom == .numberPad {
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
                stackView.addArrangedSubviews(digits.map { NumberButton(digit: $0, controller: self) })
                return stackView
        }


        // MARK: - Emoji Keyboard

        private func loadEmojiKeyboard() {
                let height: CGFloat = view.frame.height
                keyboardStackView.removeArrangedSubviews()
                emojiBoard.addSubview(emojiCollectionView)
                emojiCollectionView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        emojiBoard.heightAnchor.constraint(equalToConstant: height),
                        emojiCollectionView.bottomAnchor.constraint(equalTo: emojiBoard.indicatorsStackView.topAnchor),
                        emojiCollectionView.leadingAnchor.constraint(equalTo: emojiBoard.leadingAnchor),
                        emojiCollectionView.trailingAnchor.constraint(equalTo: emojiBoard.trailingAnchor),
                        emojiCollectionView.topAnchor.constraint(equalTo: emojiBoard.topAnchor)
                ])
                (emojiCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
                keyboardStackView.addArrangedSubview(emojiBoard)
                let buttonTintColor: UIColor = isDarkAppearance ? .white : .black
                emojiBoard.backButton.tintColor = buttonTintColor
                emojiBoard.backspaceKey.tintColor = buttonTintColor
                emojiBoard.backButton.addTarget(self, action: #selector(handleSwitchBack), for: .touchUpInside)
                emojiBoard.backspaceKey.addTarget(self, action: #selector(handleBackspace), for: .touchDown)
                _ = emojiBoard.indicatorsStackView.arrangedSubviews.map({ ($0 as? Indicator)?.addTarget(self, action: #selector(handleIndicator(_:)), for: .touchDown) })
        }
        @objc private func handleSwitchBack() {
                triggerHapticFeedback()
                AudioFeedback.perform(.modify)
                keyboardIdiom = .cantonese(.lowercased)
        }
        @objc private func handleBackspace() {
                triggerHapticFeedback()
                AudioFeedback.perform(.delete)
                textDocumentProxy.deleteBackward()
        }
        @objc private func handleIndicator(_ sender: Indicator) {
                triggerHapticFeedback()
                AudioFeedback.perform(.modify)
                _ = emojiBoard.indicatorsStackView.arrangedSubviews.filter({ $0.tintColor != .systemGray }).map({ $0.tintColor = .systemGray })
                let indexPath: IndexPath = {
                        if sender.index != 0 {
                                return IndexPath(row: 15, section: sender.index)
                        } else if frequentEmojis.isEmpty {
                                return IndexPath(row: 0, section: 1)
                        } else {
                                return IndexPath(row: 0, section: 0)
                        }
                }()
                emojiCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                emojiBoard.indicatorsStackView.arrangedSubviews[sender.index].tintColor = isDarkAppearance ? .white : .black
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
                keyboardStackView.removeArrangedSubviews()
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
                keyboardIdiom = .cantonese(.lowercased)
        }
        
        
        // MARK: - SettingsView

        private func loadSettingsView() {
                let height: CGFloat = view.frame.height
                keyboardStackView.removeArrangedSubviews()
                let extended: CGFloat = traitCollection.verticalSizeClass == .compact ? height : height + 128
                let upArrow: ToolButton = .chevron(.up, leftInset: 16, rightInset: 16)
                settingsView.addSubview(upArrow)
                upArrow.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        // FIXME: - Unable to simultaneously satisfy constraints
                        settingsView.heightAnchor.constraint(equalToConstant: extended),
                        upArrow.topAnchor.constraint(equalTo: settingsView.topAnchor),
                        upArrow.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor),
                        upArrow.widthAnchor.constraint(equalToConstant: 64),
                        upArrow.heightAnchor.constraint(equalToConstant: 40)
                ])
                upArrow.tintColor = isDarkAppearance ? .white : .black
                upArrow.addTarget(self, action: #selector(dismissSettingsView), for: .touchUpInside)
                upArrow.accessibilityLabel = NSLocalizedString("Switch back to Keyboard", comment: .empty)
                settingsView.addSubview(settingsTableView)
                settingsTableView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate(
                        [settingsTableView.topAnchor.constraint(equalTo: upArrow.bottomAnchor),
                         settingsTableView.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor),
                         settingsTableView.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor),
                         settingsTableView.bottomAnchor.constraint(equalTo: settingsView.bottomAnchor)]
                )
                keyboardStackView.addArrangedSubview(settingsView)
        }
        @objc private func dismissSettingsView() {
                keyboardIdiom = .cantonese(.lowercased)
        }


        // MARK: - Make Keys

        private func makeKeysRows(for eventsRows: [[KeyboardEvent]]) -> [UIStackView] {
                let keysRows: [UIStackView] = eventsRows.map { [unowned self] in makeRow(for: $0, controller: self) }
                return keysRows
        }
        private func makeRow(for events: [KeyboardEvent], controller: KeyboardViewController) -> UIStackView {
                let stackView: UIStackView = UIStackView()
                stackView.distribution = .fillProportionally
                let keys: [KeyView] = events.map { makeKey(for: $0, controller: controller) }
                stackView.addArrangedSubviews(keys)
                return stackView
        }
        private func makeKey(for event: KeyboardEvent, controller: KeyboardViewController) -> KeyView {
                let key: KeyView = KeyView(event: event, controller: controller)
                if event == .globe {
                        let virtual = UIButton()
                        key.addSubview(virtual)
                        virtual.translatesAutoresizingMaskIntoConstraints = false
                        NSLayoutConstraint.activate([
                                virtual.topAnchor.constraint(equalTo: key.topAnchor),
                                virtual.bottomAnchor.constraint(equalTo: key.bottomAnchor),
                                virtual.leadingAnchor.constraint(equalTo: key.leadingAnchor),
                                virtual.trailingAnchor.constraint(equalTo: key.trailingAnchor)
                        ])
                        virtual.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
                }
                return key
        }
}
