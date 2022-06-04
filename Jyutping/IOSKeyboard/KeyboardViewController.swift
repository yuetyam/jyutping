import UIKit
import CommonExtensions
import CharacterSets
import CoreIME

final class KeyboardViewController: UIInputViewController {

        // MARK: - Subviews

        private(set) lazy var toolBar: ToolBar = ToolBar(controller: self)
        private(set) lazy var settingsView: UIView = UIView()
        private(set) lazy var candidateBoard: CandidateBoard = CandidateBoard()
        private(set) lazy var emojiBoard: EmojiBoard = EmojiBoard()

        private(set) lazy var candidateCollectionView: UICollectionView = {
                let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.backgroundColor = .interactiveClear
                collectionView.register(CandidateCell.self, forCellWithReuseIdentifier: Identifiers.CandidateCell)
                return collectionView
        }()
        private(set) lazy var emojiCollectionView: UICollectionView = {
                let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.backgroundColor = .interactiveClear
                collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: Identifiers.EmojiCell)
                return collectionView
        }()
        private(set) lazy var sidebarCollectionView: UICollectionView = {
                let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.backgroundColor = .interactiveClear
                collectionView.register(SidebarCell.self, forCellWithReuseIdentifier: Identifiers.SidebarCell)
                return collectionView
        }()
        private(set) lazy var settingsTableView: UITableView = {
                let tableView = UITableView(frame: .zero, style: .insetGrouped)
                tableView.delegate = self
                tableView.dataSource = self
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.switchSettingsCell)
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.selectionSettingsCell)
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.clearLexiconSettingsCell)
                return tableView
        }()

        private(set) lazy var keyboardStackView: UIStackView = {
                let stackView = UIStackView(frame: .zero)
                stackView.axis = .vertical
                stackView.distribution = .equalSpacing
                return stackView
        }()
        private(set) lazy var bottomStackView: UIStackView = {
                let stackView = UIStackView(frame: .zero)
                stackView.distribution = .fillProportionally
                return stackView
        }()


        // MARK: - Keyboard Life Cycle

        override func viewDidLoad() {
                super.viewDidLoad()
                view.addSubview(keyboardStackView)
                keyboardStackView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        keyboardStackView.topAnchor.constraint(equalTo: view.topAnchor),
                        keyboardStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
                        keyboardStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
                        keyboardStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
                setupToolBarActions()
        }
        private lazy var shouldKeepBufferTextWhileTextDidChange: Bool = false
        override func textDidChange(_ textInput: UITextInput?) {
                super.textDidChange(textInput)
                let asked: KeyboardIdiom = askedKeyboardIdiom
                if respondingKeyboardIdiom != asked {
                        respondingKeyboardIdiom = asked
                        needsDifferentKeyboard = true
                        if didKeyboardEstablished {
                                keyboardIdiom = asked
                        }
                }
                if shouldKeepBufferTextWhileTextDidChange {
                        shouldKeepBufferTextWhileTextDidChange = false
                } else {
                        if !bufferText.isEmpty && !textDocumentProxy.hasText {
                                // User just tapped the Clear button in the text field
                                bufferText = .empty
                        }
                }
        }

        override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                if userLexicon == nil {
                        userLexicon = UserLexicon()
                }
                Lychee.connect()
                if isHapticFeedbackOn && hapticFeedback == nil {
                        hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                }
        }
        override func viewDidAppear(_ animated: Bool) {
                super.viewDidAppear(animated)
                if needsDifferentKeyboard {
                        keyboardIdiom = respondingKeyboardIdiom
                } else if !didKeyboardEstablished {
                        setupKeyboard()
                        didKeyboardEstablished = true
                }
        }
        override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
                super.traitCollectionDidChange(previousTraitCollection)
                isDarkAppearance = traitCollection.userInterfaceStyle == .dark || textDocumentProxy.keyboardAppearance == .dark
                keyboardInterface = matchInterface()
                if didKeyboardEstablished {
                        setupKeyboard()
                }
        }
        override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
                hapticFeedback = nil
                Lychee.close()
                userLexicon?.close()
                userLexicon = nil
                simplifier?.close()
                simplifier = nil
        }
        override func viewDidDisappear(_ animated: Bool) {
                super.viewDidDisappear(animated)
                keyboardStackView.removeFromSuperview()
        }

        private lazy var didKeyboardEstablished: Bool = false
        private lazy var needsDifferentKeyboard: Bool = false
        private lazy var respondingKeyboardIdiom: KeyboardIdiom = fallbackKeyboardIdiom
        private var askedKeyboardIdiom: KeyboardIdiom {
                switch textDocumentProxy.keyboardType {
                case .numberPad, .asciiCapableNumberPad:
                        return keyboardInterface.isCompact ? .numberPad : .numeric
                case .decimalPad:
                        return keyboardInterface.isCompact ? .decimalPad : .numeric
                case .numbersAndPunctuation:
                        return .numeric
                case .emailAddress, .URL:
                        return .alphabetic(.lowercased)
                default:
                        return fallbackKeyboardIdiom
                }
        }
        lazy var keyboardIdiom: KeyboardIdiom = fallbackKeyboardIdiom {
                didSet {
                        setupKeyboard()
                        guard didKeyboardEstablished else {
                                didKeyboardEstablished = true
                                return
                        }
                        if (!keyboardIdiom.isPingMode) && (!bufferText.isEmpty) {
                                let text: String = bufferText
                                bufferText = .empty
                                textDocumentProxy.insertText(text)
                        }
                }
        }
        var fallbackKeyboardIdiom: KeyboardIdiom {
                switch keyboardLayout {
                case .qwerty:
                        return .cantonese(.lowercased)
                case .saamPing:
                        return .cantonese(.lowercased)
                case .tenKey:
                        return .tenKeyCantonese
                }
        }


        // MARK: - Operations

        func operate(_ operation: Operation) {
                switch operation {
                case .input(let text):
                        defer {
                                AudioFeedback.perform(.input)
                                adjustKeyboardIdiom()
                        }
                        guard keyboardIdiom.isPingMode else {
                                textDocumentProxy.insertText(text)
                                return
                        }
                        switch text {
                        case "gw" where keyboardLayout == .saamPing:
                                let newText: String = bufferText + text
                                bufferText = newText.replacingOccurrences(of: "gwgw", with: "kw")
                        case _ where text.isLetters:
                                bufferText += text
                        case _ where keyboardLayout == .saamPing && (text.first?.isTone ?? false):
                                bufferText += text
                        case _ where bufferText.isEmpty:
                                textDocumentProxy.insertText(text)
                        default:
                                compose(bufferText)
                                bufferText = .empty
                                DispatchQueue.global().asyncAfter(deadline: .now() + 0.04) { [unowned self] in
                                        textDocumentProxy.insertText(text)
                                }
                        }
                case .separator:
                        bufferText += "'"
                        AudioFeedback.perform(.input)
                        adjustKeyboardIdiom()
                case .punctuation(let text):
                        textDocumentProxy.insertText(text)
                        AudioFeedback.perform(.input)
                        adjustKeyboardIdiom()
                case .space:
                        switch keyboardIdiom {
                        case .cantonese where !bufferText.isEmpty:
                                if let firstCandidate: Candidate = candidates.first {
                                        let outputText: String = {
                                                switch firstCandidate.type {
                                                case .cantonese:
                                                        return firstCandidate.text
                                                case .specialMark:
                                                        return firstCandidate.text + String.space
                                                case .emoji:
                                                        return firstCandidate.text
                                                }
                                        }()
                                        compose(outputText)
                                        AudioFeedback.perform(.modify)
                                        aftercareSelected(firstCandidate)
                                } else {
                                        compose(bufferText)
                                        AudioFeedback.perform(.input)
                                        bufferText = .empty
                                }
                        default:
                                textDocumentProxy.insertText(.space)
                                AudioFeedback.perform(.input)
                        }
                        adjustKeyboardIdiom()
                case .doubleSpace:
                        guard bufferText.isEmpty else { return }
                        defer {
                                AudioFeedback.perform(.input)
                        }
                        let hasSpaceAhead: Bool = textDocumentProxy.documentContextBeforeInput?.hasSuffix(.space) ?? false
                        guard doubleSpaceShortcut != 2 && hasSpaceAhead else {
                                textDocumentProxy.insertText(.space)
                                return
                        }
                        textDocumentProxy.deleteBackward()
                        let text: String = {
                                switch (doubleSpaceShortcut, keyboardIdiom.isEnglishMode) {
                                case (0, false), (1, false):
                                        return "。"
                                case (0, true), (1, true):
                                        return ". "
                                case (3, false):
                                        return "、"
                                case (3, true):
                                        return ", "
                                case (4, _):
                                        return .fullWidthSpace
                                default:
                                        return .fullWidthSpace
                                }
                        }()
                        textDocumentProxy.insertText(text)
                case .backspace:
                        if bufferText.isEmpty {
                                textDocumentProxy.deleteBackward()
                        } else {
                                candidateSequence = []
                                bufferText = String(bufferText.dropLast())
                        }
                        AudioFeedback.perform(.delete)
                case .clear:
                        guard !bufferText.isEmpty else { return }
                        bufferText = .empty
                        AudioFeedback.perform(.delete)
                case .return:
                        if bufferText.isEmpty {
                                AudioFeedback.perform(.modify)
                                textDocumentProxy.insertText("\n")
                        } else {
                                let text: String = bufferText
                                bufferText = .empty
                                AudioFeedback.perform(.input)
                                textDocumentProxy.insertText(text)
                        }
                case .shift:
                        AudioFeedback.perform(.modify)
                        switch keyboardIdiom {
                        case .cantonese(.lowercased):
                                keyboardIdiom = .cantonese(.uppercased)
                        case .cantonese(.uppercased),
                             .cantonese(.capsLocked):
                                keyboardIdiom = .cantonese(.lowercased)
                        case .alphabetic(.lowercased):
                                keyboardIdiom = .alphabetic(.uppercased)
                        case .alphabetic(.uppercased),
                             .alphabetic(.capsLocked):
                                keyboardIdiom = .alphabetic(.lowercased)
                        default:
                                break
                        }
                case .doubleShift:
                        AudioFeedback.perform(.modify)
                        keyboardIdiom = keyboardIdiom.isEnglishMode ? .alphabetic(.capsLocked) : .cantonese(.capsLocked)
                case .tab:
                        defer {
                                AudioFeedback.perform(.input)
                                adjustKeyboardIdiom()
                        }
                        if bufferText.isEmpty {
                                textDocumentProxy.insertText("\t")
                        } else {
                                compose(bufferText)
                                bufferText = .empty
                                DispatchQueue.global().asyncAfter(deadline: .now() + 0.04) { [unowned self] in
                                        textDocumentProxy.insertText("\t")
                                }
                        }
                case .transform(let newIdiom):
                        AudioFeedback.perform(.modify)
                        let shouldBeTenKeyKeyboard: Bool = keyboardLayout == .tenKey && newIdiom == .cantonese(.lowercased)
                        keyboardIdiom = shouldBeTenKeyKeyboard ? .tenKeyCantonese : newIdiom
                case .dismiss:
                        AudioFeedback.perform(.modify)
                        guard !(bufferText.isEmpty) else {
                                dismissKeyboard()
                                return
                        }
                        compose(bufferText)
                        bufferText = .empty
                        DispatchQueue.global().asyncAfter(deadline: .now() + 0.04) { [unowned self] in
                                DispatchQueue(label: "im.cantonese.fix.dismiss").sync { [unowned self] in
                                        self.textDocumentProxy.insertText(.zeroWidthSpace)
                                        self.textDocumentProxy.deleteBackward()
                                        self.dismissKeyboard()
                                }
                        }
                case .select(let candidate):
                        let outputText: String = {
                                switch candidate.type {
                                case .cantonese:
                                        return candidate.text
                                case .specialMark:
                                        return candidate.text + String.space
                                case .emoji:
                                        return candidate.text
                                }
                        }()
                        compose(outputText)
                        AudioFeedback.perform(.modify)
                        triggerHapticFeedback()
                        aftercareSelected(candidate)
                        adjustKeyboardIdiom()
                case .tenKey(let combination):
                        defer {
                                AudioFeedback.perform(.input)
                        }
                        guard !combination.isPunctuation else {
                                if bufferText.isEmpty {
                                        textDocumentProxy.insertText("，")
                                } else {
                                        let text: String = bufferText + "，"
                                        bufferText = .empty
                                        textDocumentProxy.insertText(text)
                                }
                                return
                        }
                        guard !possibleTexts.isEmpty else {
                                possibleTexts = combination.letters
                                bufferText = combination.letters.first!
                                return
                        }
                        let newPossibles = combination.letters.map { letter -> [String] in
                                return possibleTexts.map({ $0 + letter })
                        }
                        possibleTexts = newPossibles.flatMap({ $0 })
                        possibleTexts.sort { lhs, rhs in
                                let lhsSyllables = Splitter.peekSplit(lhs)
                                let rhsSyllables = Splitter.peekSplit(rhs)
                                let lhsLength = lhsSyllables.joined().count
                                let rhsLength = rhsSyllables.joined().count
                                if lhsLength == rhsLength {
                                        return lhsSyllables.count < lhsSyllables.count
                                } else {
                                        return lhsLength > rhsLength
                                }
                        }
                        bufferText = possibleTexts.first!
                }
        }
        private lazy var possibleTexts: [String] = []
        private func adjustKeyboardIdiom() {
                switch keyboardIdiom {
                case .alphabetic(.uppercased):
                        keyboardIdiom = .alphabetic(.lowercased)
                case .cantonese(.uppercased):
                        keyboardIdiom = .cantonese(.lowercased)
                case .candidates where bufferText.isEmpty:
                        candidateCollectionView.removeFromSuperview()
                        NSLayoutConstraint.deactivate(candidateBoardCollectionViewConstraints)
                        toolBar.reset()
                        keyboardIdiom = fallbackKeyboardIdiom
                default:
                        break
                }
        }
        private func aftercareSelected(_ candidate: Candidate) {
                switch bufferText.first {
                case .none:
                        break
                case .some("r"), .some("v"), .some("x"), .some("q"):
                        if bufferText.count <= candidate.input.count + 1 {
                                bufferText = .empty
                        } else {
                                let first: String = String(bufferText.first!)
                                let tail = bufferText.dropFirst(candidate.input.count + 1)
                                bufferText = first + tail
                        }
                default:
                        guard candidate.isCantonese else {
                                candidateSequence = []
                                bufferText = .empty
                                return
                        }
                        candidateSequence.append(candidate)
                        defer {
                                if bufferText.isEmpty && !candidateSequence.isEmpty {
                                        let concatenatedCandidate: Candidate = candidateSequence.joined()
                                        candidateSequence = []
                                        handleLexicon(concatenatedCandidate)
                                }
                        }
                        let bufferTextLength: Int = bufferText.count
                        let candidateInputText: String = {
                                if keyboardLayout == .saamPing {
                                        return candidate.input
                                } else {
                                        let converted: String = candidate.input.replacingOccurrences(of: "(4|5|6)", with: "RR", options: .regularExpression)
                                        return converted
                                }
                        }()
                        let inputCount: Int = {
                                let candidateInputCount: Int = candidateInputText.count
                                guard bufferTextLength > 2 else { return candidateInputCount }
                                guard candidateInputText.contains("jyu") else { return candidateInputCount }
                                let suffixCount: Int = max(0, bufferTextLength - candidateInputCount)
                                let leading = bufferText.dropLast(suffixCount)
                                let modifiedLeading = leading.replacingOccurrences(of: "(c|d|h|j|l|s|z)yu(n|t)", with: "RRRR", options: .regularExpression)
                                        .replacingOccurrences(of: "^(g|k|n|t)?yu(n|t)", with: "RRRR", options: .regularExpression)
                                        .replacingOccurrences(of: "(?<!c|j|s|z)yu(?!k|m|ng)", with: "jyu", options: .regularExpression)
                                return candidateInputCount - (modifiedLeading.count - leading.count)
                        }()
                        let difference: Int = bufferTextLength - inputCount
                        guard difference > 0 else {
                                bufferText = .empty
                                return
                        }
                        let leading = bufferText.dropLast(difference)
                        let filtered = leading.replacingOccurrences(of: "'", with: "")
                        var tail: Substring = {
                                if filtered.count == leading.count {
                                        return bufferText.dropFirst(inputCount)
                                } else {
                                        let separatorsCount: Int = leading.count - filtered.count
                                        return bufferText.dropFirst(inputCount + separatorsCount)
                                }
                        }()
                        while tail.hasPrefix("'") {
                                tail = tail.dropFirst()
                        }
                        bufferText = String(tail)
                }
        }


        // MARK: - Input Texts

        private(set) lazy var bufferText: String = .empty {
                didSet {
                        switch bufferText.first {
                        case .none:
                                possibleTexts = []
                                processingText = .empty
                        case .some("r"), .some("v"), .some("x"), .some("q"):
                                processingText = bufferText
                        default:
                                if keyboardLayout == .saamPing {
                                        processingText = bufferText
                                } else {
                                        processingText = bufferText.replacingOccurrences(of: "vv", with: "4")
                                                .replacingOccurrences(of: "xx", with: "5")
                                                .replacingOccurrences(of: "qq", with: "6")
                                                .replacingOccurrences(of: "v", with: "1")
                                                .replacingOccurrences(of: "x", with: "2")
                                                .replacingOccurrences(of: "q", with: "3")
                                }
                        }
                        switch (bufferText.isEmpty, oldValue.isEmpty) {
                        case (true, false):
                                updateBottomStackView(buffered: false)
                        case (false, true):
                                updateBottomStackView(buffered: true)
                        default:
                                break
                        }
                }
        }
        private lazy var processingText: String = .empty {
                didSet {
                        toolBar.update()
                        switch processingText.first {
                        case .none:
                                flexibleSchemes = []
                                markedText = .empty
                                candidates = []
                                break
                        case .some("r"), .some("v"), .some("x"), .some("q"):
                                flexibleSchemes = []
                                markedText = processingText
                        default:
                                flexibleSchemes = Splitter.split(processingText)
                                if let syllables: [String] = flexibleSchemes.first {
                                        let splittable: String = syllables.joined()
                                        if splittable.count == processingText.count {
                                                markedText = syllables.joined(separator: .space)
                                        } else if processingText.contains("'") {
                                                markedText = processingText.replacingOccurrences(of: "'", with: "' ")
                                        } else {
                                                let tail = processingText.dropFirst(splittable.count)
                                                markedText = syllables.joined(separator: .space) + .space + tail
                                        }
                                } else {
                                        markedText = processingText
                                }
                        }
                        imeQueue.async { [unowned self] in
                                suggest()
                        }
                }
        }
        private lazy var markedText: String = .empty {
                willSet {
                        // REASON: Chrome address bar
                        guard markedText.isEmpty && !newValue.isEmpty else { return }
                        guard textDocumentProxy.keyboardType == .webSearch else { return }
                        shouldKeepBufferTextWhileTextDidChange = true
                        textDocumentProxy.insertText(.empty)
                }
                didSet {
                        guard shouldMarkInput else { return }
                        handleMarkedText()
                }
        }
        private lazy var flexibleSchemes: [[String]] = [] {
                didSet {
                        guard !flexibleSchemes.isEmpty else {
                                regularSchemes = []
                                return
                        }
                        regularSchemes = flexibleSchemes.map({ block -> [String] in
                                let sequence: [String] = block.map { syllable -> String in
                                        let converted: String = syllable.replacingOccurrences(of: "eo(ng|k)$", with: "oe$1", options: .regularExpression)
                                                .replacingOccurrences(of: "oe(i|n|t)$", with: "eo$1", options: .regularExpression)
                                                .replacingOccurrences(of: "eung$", with: "oeng", options: .regularExpression)
                                                .replacingOccurrences(of: "(u|o)m$", with: "am", options: .regularExpression)
                                                .replacingOccurrences(of: "^y(u|un|ut)$", with: "jy$1", options: .regularExpression)
                                                .replacingOccurrences(of: "y", with: "j", options: .anchored)
                                        return converted
                                }
                                return sequence
                        })
                }
        }
        private lazy var regularSchemes: [[String]] = []

        /// some apps can't be compatible with `textDocumentProxy.setMarkedText() & textDocumentProxy.insertText()`
        /// - Parameter text: text to insert
        private func compose(_ text: String) {
                shouldMarkInput = false
                defer {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) { [unowned self] in
                                shouldMarkInput = true
                        }
                }
                let location: Int = (text as NSString).length
                let range: NSRange = NSRange(location: location, length: 0)
                textDocumentProxy.setMarkedText(text, selectedRange: range)
                textDocumentProxy.unmarkText()
        }
        private lazy var shouldMarkInput: Bool = true {
                didSet {
                        guard shouldMarkInput else { return }
                        handleMarkedText()
                }
        }
        private func handleMarkedText() {
                guard !(markedText.isEmpty) else {
                        textDocumentProxy.setMarkedText("", selectedRange: NSRange(location: 0, length: 0))
                        textDocumentProxy.unmarkText()
                        return
                }
                let location: Int = (markedText as NSString).length
                let range: NSRange = NSRange(location: location, length: 0)
                textDocumentProxy.setMarkedText(markedText, selectedRange: range)
        }

        /// Calling `textDocumentProxy.insertText(_:)`
        /// - Parameter text: text to insert
        func insert(_ text: String) {
                textDocumentProxy.insertText(text)
        }


        // MARK: - Engine

        private let imeQueue: DispatchQueue = DispatchQueue(label: "im.cantonese.CantoneseIM.Keyboard.ime", qos: .userInteractive)
        private lazy var userLexicon: UserLexicon? = UserLexicon()
        private lazy var simplifier: Simplifier? = nil
        private func suggest() {
                switch processingText.first {
                case .none:
                        break
                case .some("r"):
                        pinyinReverseLookup()
                case .some("v"):
                        cangjieReverseLookup()
                case .some("x"):
                        strokeReverseLookup()
                case .some("q"):
                        leungFanReverseLookup()
                default:
                        let key: String = bufferText.lowercased()
                        if let markText = Candidate.specialMarks[key] {
                                let markCandidate: Candidate = Candidate(mark: markText)
                                candidates = [markCandidate]
                        } else {
                                imeSuggest()
                        }
                }
        }
        private func pinyinReverseLookup() {
                let text: String = String(processingText.dropFirst())
                guard !text.isEmpty else {
                        candidates = []
                        return
                }
                let lookup: [Candidate] = Lychee.pinyinLookup(for: text).transformed()
                push(lookup)
        }
        private func cangjieReverseLookup() {
                let text: String = String(processingText.dropFirst())
                guard !text.isEmpty else {
                        candidates = []
                        return
                }
                let lookup: [Candidate] = Lychee.cangjieLookup(for: text).transformed()
                push(lookup)
        }
        private func strokeReverseLookup() {

                // 橫: w, h     :  w for Waang, h for Heng or Horizontal
                // 豎: s, v     :  s for Syu or Shu, v for Vertical
                // 撇: a, p, l  :  p for Pit or Pie, l for Left, a for the position of key A
                // 點: d, n, r  :  d for Dim or Dian or Dot, n for Naat(捺) or Na, r for Right
                // 折: z, t     :  z for Zit or Zhe, t for Turning
                let text: String = processingText.dropFirst()
                        .replacingOccurrences(of: "h", with: "w")
                        .replacingOccurrences(of: "v", with: "s")
                        .replacingOccurrences(of: "p", with: "a")
                        .replacingOccurrences(of: "l", with: "a")
                        .replacingOccurrences(of: "n", with: "d")
                        .replacingOccurrences(of: "r", with: "d")
                        .replacingOccurrences(of: "t", with: "z")

                guard !text.isEmpty else {
                        candidates = []
                        return
                }
                let lookup: [Candidate] = Lychee.strokeLookup(for: text).transformed()
                push(lookup)
        }
        private func leungFanReverseLookup() {
                let text: String = String(processingText.dropFirst())
                guard !text.isEmpty else {
                        candidates = []
                        return
                }
                let lookup: [Candidate] = Lychee.leungFanLookup(for: text).transformed()
                push(lookup)
        }

        /// For tests only
        private func fetchEmojis(for text: String) -> [Candidate] {
                switch text {
                case "fai":
                        let fai: Candidate = Candidate(emoji: "🫁", cantonese: "肺", romanization: "fai3", input: text)
                        return [fai]
                case "gaamgaai":
                        let gaamgaai: Candidate = Candidate(emoji: "😅", cantonese: "尷尬", romanization: "gaam3 gaai3", input: text)
                        return [gaamgaai]
                default:
                        return []
                }
        }
        private func imeSuggest() {
                let engineCandidates: [Candidate] = {
                        var normal: [Candidate] = Lychee.suggest(for: processingText, schemes: regularSchemes.uniqued()).transformed()
                        let droppedLast = processingText.dropLast()
                        let shouldDropSeparator: Bool = normal.isEmpty && processingText.hasSuffix("'") && !droppedLast.contains("'")
                        guard !shouldDropSeparator else {
                                let droppedSeparator: String = String(droppedLast)
                                let newSchemes: [[String]] = Splitter.split(droppedSeparator).uniqued().filter({ $0.joined() == droppedSeparator || $0.count == 1 })
                                return Lychee.suggest(for: droppedSeparator, schemes: newSchemes).transformed()
                        }
                        // TODO: Add needsEmojiCandidates
                        let shouldContinue: Bool = !normal.isEmpty && candidateSequence.isEmpty
                        guard shouldContinue else { return normal }
                        let emojis: [Candidate] = fetchEmojis(for: bufferText)
                        for emoji in emojis {
                                if let index = normal.firstIndex(where: { $0.input == bufferText && $0.lexiconText == emoji.lexiconText }) {
                                        normal.insert(emoji, at: index + 1)
                                }
                        }
                        return normal
                }()
                let lexiconCandidates: [Candidate] = userLexicon?.suggest(for: processingText) ?? []
                let combined: [Candidate] = lexiconCandidates + engineCandidates
                push(combined)
        }
        private func push(_ origin: [Candidate]) {
                switch Logogram.current {
                case .traditional:
                        candidates = origin.uniqued()
                case .hongkong:
                        let converted: [Candidate] = origin.map({ Candidate(text: Converter.convert($0.text, to: .hongkong), romanization: $0.romanization, input: $0.input, lexiconText: $0.lexiconText) })
                        candidates = converted.uniqued()
                case .taiwan:
                        let converted: [Candidate] = origin.map({ Candidate(text: Converter.convert($0.text, to: .taiwan), romanization: $0.romanization, input: $0.input, lexiconText: $0.lexiconText) })
                        candidates = converted.uniqued()
                case .simplified:
                        if simplifier == nil {
                                simplifier = Simplifier()
                        }
                        let converted: [Candidate] = origin.map({ Candidate(text: simplifier?.convert($0.text) ?? $0.text, romanization: $0.romanization, input: $0.input, lexiconText: $0.lexiconText)})
                        candidates = converted.uniqued()
                }
        }
        private(set) lazy var candidates: [Candidate] = [] {
                didSet {
                        DispatchQueue.main.async { [unowned self] in
                                candidateCollectionView.reloadData()
                                candidateCollectionView.setContentOffset(.zero, animated: true)
                        }
                }
        }
        private lazy var candidateSequence: [Candidate] = []
        func handleLexicon(_ candidate: Candidate) {
                imeQueue.async { [unowned self] in
                        userLexicon?.handle(candidate)
                }
        }
        func clearUserLexicon() {
                imeQueue.async { [unowned self] in
                        userLexicon?.deleteAll()
                }
                Emoji.clearFrequentEmojis()
        }


        // MARK: - ToolBar Actions

        private func setupToolBarActions() {
                toolBar.settingsButton.addTarget(self, action: #selector(handleSettingsButton), for: .touchUpInside)
                toolBar.yueEngSwitch.addTarget(self, action: #selector(handleYueEngSwitch), for: .touchDown)
                toolBar.pasteButton.addTarget(self, action: #selector(handlePaste), for: .touchUpInside)
                toolBar.emojiSwitch.addTarget(self, action: #selector(handleEmojiSwitch), for: .touchUpInside)
                toolBar.keyboardDown.addTarget(self, action: #selector(dismissInputMethod), for: .touchUpInside)
                toolBar.downArrow.addTarget(self, action: #selector(handleDownArrow), for: .touchUpInside)
        }
        @objc private func handleSettingsButton() {
                keyboardIdiom = .settings
        }
        @objc private func handleYueEngSwitch() {
                hapticFeedback?.impactOccurred()
                AudioFeedback.perform(.modify)
                let switched: Bool = toolBar.yueEngSwitch.switched
                if switched {
                        let newIdiom: KeyboardIdiom = {
                                let shouldBeTenKeyLayout: Bool = keyboardLayout == .tenKey
                                switch keyboardIdiom {
                                case .alphabetic(.lowercased):
                                        return fallbackKeyboardIdiom
                                case .alphabetic(.uppercased):
                                        return shouldBeTenKeyLayout ? .tenKeyCantonese : .cantonese(.uppercased)
                                case .alphabetic(.capsLocked):
                                        return shouldBeTenKeyLayout ? .tenKeyCantonese : .cantonese(.capsLocked)
                                case .numeric:
                                        return shouldBeTenKeyLayout ? .tenKeyCantonese : .cantoneseNumeric
                                case .symbolic:
                                        return shouldBeTenKeyLayout ? .tenKeyCantonese : .cantoneseSymbolic
                                default:
                                        return fallbackKeyboardIdiom
                                }
                        }()
                        keyboardIdiom = newIdiom
                } else {
                        let newIdiom: KeyboardIdiom = {
                                switch keyboardIdiom {
                                case .cantonese(.lowercased):
                                        return .alphabetic(.lowercased)
                                case .cantonese(.uppercased):
                                        return .alphabetic(.uppercased)
                                case .cantonese(.capsLocked):
                                        return .alphabetic(.capsLocked)
                                case .cantoneseNumeric:
                                        return .numeric
                                case .cantoneseSymbolic:
                                        return .symbolic
                                default:
                                        return .alphabetic(.lowercased)
                                }
                        }()
                        keyboardIdiom = newIdiom
                }
        }
        @objc private func handlePaste() {
                guard UIPasteboard.general.hasStrings else { return }
                guard let copied: String = UIPasteboard.general.string else { return }
                textDocumentProxy.insertText(copied)
                hapticFeedback?.impactOccurred()
                AudioFeedback.perform(.input)
        }
        @objc private func handleEmojiSwitch() {
                hapticFeedback?.impactOccurred()
                AudioFeedback.perform(.modify)
                keyboardIdiom = .emoji
        }
        @objc private func dismissInputMethod() {
                dismissKeyboard()
        }
        @objc private func handleDownArrow() {
                keyboardIdiom = .candidates
        }


        // MARK: - Properties

        private(set) lazy var isDarkAppearance: Bool = traitCollection.userInterfaceStyle == .dark || textDocumentProxy.keyboardAppearance == .dark
        private(set) lazy var keyboardInterface: KeyboardInterface = matchInterface()
        private func matchInterface() -> KeyboardInterface {
                switch traitCollection.userInterfaceIdiom {
                case .pad:
                        guard traitCollection.horizontalSizeClass != .compact else { return .padFloating }
                        let width: CGFloat = UIScreen.main.bounds.width
                        let height: CGFloat = UIScreen.main.bounds.height
                        let isPortrait: Bool = width < height
                        let minSide: CGFloat = min(width, height)
                        if minSide > 840 {
                                return isPortrait ? .padPortraitLarge : .padLandscapeLarge
                        } else if minSide > 815 {
                                return isPortrait ? .padPortraitMedium : .padLandscapeMedium
                        } else {
                                return isPortrait ? .padPortraitSmall : .padLandscapeSmall
                        }
                default:
                        switch traitCollection.verticalSizeClass {
                        case .compact:
                                return .phoneLandscape
                        default:
                                return .phonePortrait
                        }
                }
        }


        // MARK: - Settings

        private var hapticFeedback: UIImpactFeedbackGenerator?
        func triggerHapticFeedback() {
                hapticFeedback?.impactOccurred()
        }
        func prepareHapticFeedback() {
                hapticFeedback?.prepare()
        }
        private(set) lazy var isHapticFeedbackOn: Bool = hasFullAccess && UserDefaults.standard.bool(forKey: "haptic_feedback") {
                didSet {
                        if isHapticFeedbackOn {
                                if hapticFeedback == nil {
                                        hapticFeedback = UIImpactFeedbackGenerator(style: .light)
                                }
                        } else {
                                if hapticFeedback != nil {
                                        hapticFeedback = nil
                                }
                        }
                }
        }
        func updateHapticFeedbackStatus() {
                isHapticFeedbackOn = hasFullAccess && UserDefaults.standard.bool(forKey: "haptic_feedback")
        }

        /// 鍵盤佈局。全鍵盤 或三拼 或九宮格。
        private(set) lazy var keyboardLayout: KeyboardLayout = {

                /// 鍵盤佈局
                ///
                /// 0: The key "keyboard_layout" doesn‘t exist.
                ///
                /// 1: 全鍵盤 QWERTY
                ///
                /// 2: 三拼
                ///
                /// 3: 九宮格（未實現）
                let value: Int = UserDefaults.standard.integer(forKey: "keyboard_layout")
                switch value {
                case 0, 1:
                        return .qwerty
                case 2:
                        return .saamPing
                case 3:
                        return .tenKey
                default:
                        return .qwerty
                }
        }()
        func updateKeyboardLayout(to newLayout: KeyboardLayout) {
                let value: Int = {
                        switch newLayout {
                        case .qwerty:
                                return 1
                        case .saamPing:
                                return 2
                        case .tenKey:
                                return 3
                        }
                }()
                UserDefaults.standard.set(value, forKey: "keyboard_layout")
                keyboardLayout = newLayout
        }

        /// 粵拼顯示
        ///
        /// 0: The key "jyutping_display" doesn‘t exist.
        ///
        /// 1: 候選詞之上
        ///
        /// 2: 候選詞之下
        ///
        /// 3: 無
        private(set) lazy var footnoteStyle: Int = UserDefaults.standard.integer(forKey: "jyutping_display")
        func updateFootnoteStyle() {
                footnoteStyle = UserDefaults.standard.integer(forKey: "jyutping_display")
        }

        /// 粵拼聲調樣式
        ///
        /// 0: The key "tone_style" doesn‘t exist.
        ///
        /// 1: 正常
        ///
        /// 2: 無聲調
        ///
        /// 3: 上標
        ///
        /// 4: 下標
        private(set) lazy var toneStyle: Int = UserDefaults.standard.integer(forKey: "tone_style")
        func updateToneStyle() {
                toneStyle = UserDefaults.standard.integer(forKey: "tone_style")
        }

        /// 雙擊空格鍵快捷動作
        ///
        /// 0: The key "double_space_shortcut" doesn‘t exist.
        ///
        /// 1: 輸入一個句號「。」（英文鍵盤輸入一個句號「.」加一個空格）
        ///
        /// 2: 無（輸入兩個空格）
        ///
        /// 3: 輸入一個頓號「、」（英文鍵盤輸入一個逗號「,」加一個空格）
        ///
        /// 4: 輸入一個全形空格（U+3000）
        private(set) lazy var doubleSpaceShortcut: Int = UserDefaults.standard.integer(forKey: "double_space_shortcut")
        func updateDoubleSpaceShortcut() {
                doubleSpaceShortcut = UserDefaults.standard.integer(forKey: "double_space_shortcut")
        }
}


private extension Array where Element == CoreCandidate {
        func transformed() -> [Candidate] {
                return self.map({ Candidate(text: $0.text, romanization: $0.romanization, input: $0.input, lexiconText: $0.text) })
        }
}

