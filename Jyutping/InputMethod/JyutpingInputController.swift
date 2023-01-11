import SwiftUI
import Cocoa
import InputMethodKit
import CommonExtensions
import CharacterSets
import CoreIME

private struct VisualEffect: NSViewRepresentable {
        // https://developer.apple.com/forums/thread/694837
        func makeNSView(context: Self.Context) -> NSView {
                let view = NSVisualEffectView()
                view.state = NSVisualEffectView.State.active
                return view
        }
        func updateNSView(_ nsView: NSView, context: Context) { }
}

private extension View {
        func visualEffect() -> some View {
                return self.background(
                        VisualEffect()
                                .cornerRadius(8)
                                .shadow(radius: 4)
                )
        }
}

@objc(JyutpingInputController)
final class JyutpingInputController: IMKInputController {

        override func menu() -> NSMenu! {
                let preferences = NSMenuItem()
                preferences.title = NSLocalizedString("menu.preferences", comment: "")
                preferences.action = #selector(openPreferences)
                preferences.keyEquivalent = ","
                preferences.keyEquivalentModifierMask = [.control, .shift]
                let menu = NSMenu()
                menu.addItem(preferences)
                return menu
        }
        @objc private func openPreferences() {
                displayPreferencesPane()
        }
        private lazy var preferencesWindow: NSWindow? = nil
        private func displayPreferencesPane() {
                preferencesWindow?.setFrame(.zero, display: true)
                preferencesWindow?.close()
                let frame: CGRect = {
                        let x: CGFloat = screenFrame.width / 4.0
                        let y: CGFloat = screenFrame.height / 5.0
                        let width: CGFloat = screenFrame.width / 2.0
                        let height: CGFloat = (screenFrame.height / 5.0) * 3.0
                        return CGRect(x: x, y: y, width: width, height: height)
                }()
                preferencesWindow = NSWindow(contentRect: frame, styleMask: [.titled, .closable, .resizable, .fullSizeContentView], backing: .buffered, defer: true)
                preferencesWindow?.title = NSLocalizedString("Jyutping Input Method Preferences", comment: "")
                let visualEffectView = NSVisualEffectView()
                visualEffectView.material = .titlebar
                visualEffectView.state = .active
                preferencesWindow?.contentView = visualEffectView

                let pane = NSHostingController(rootView: PreferencesView().background(VisualEffect()))
                preferencesWindow?.contentView?.addSubview(pane.view)
                pane.view.translatesAutoresizingMaskIntoConstraints = false
                if let topAnchor = preferencesWindow?.contentView?.topAnchor,
                   let bottomAnchor = preferencesWindow?.contentView?.bottomAnchor,
                   let leadingAnchor = preferencesWindow?.contentView?.leadingAnchor,
                   let trailingAnchor = preferencesWindow?.contentView?.trailingAnchor {
                        NSLayoutConstraint.activate([
                                pane.view.topAnchor.constraint(equalTo: topAnchor),
                                pane.view.bottomAnchor.constraint(equalTo: bottomAnchor),
                                pane.view.leadingAnchor.constraint(equalTo: leadingAnchor),
                                pane.view.trailingAnchor.constraint(equalTo: trailingAnchor)
                        ])
                }
                preferencesWindow?.contentViewController?.addChild(pane)
                preferencesWindow?.orderFrontRegardless()
                preferencesWindow?.setFrame(frame, display: true)
                NSApp.activate(ignoringOtherApps: true)
        }

        private lazy var window: NSWindow? = nil
        private lazy var screenFrame: CGRect = NSScreen.main?.frame ?? CGRect(origin: .zero, size: CGSize(width: 1920, height: 1080))
        private let offset: CGFloat = 10

        private func resetWindow() {
                _ = window?.contentView?.subviews.map({ $0.removeFromSuperview() })
                _ = window?.contentViewController?.children.map({ $0.removeFromParent() })
                lazy var frame: CGRect = windowFrame()
                if window == nil {
                        window = NSWindow(contentRect: frame, styleMask: .borderless, backing: .buffered, defer: false)
                        window?.backgroundColor = .clear
                        let levelValue: Int = Int(CGShieldingWindowLevel())
                        window?.level = NSWindow.Level(levelValue)
                        window?.orderFrontRegardless()
                }
                switch inputState {
                case .instantSettings:
                        let settingsUI = NSHostingController(rootView: InstantSettingsView().environmentObject(settingsObject).visualEffect())
                        window?.contentView?.addSubview(settingsUI.view)
                        settingsUI.view.translatesAutoresizingMaskIntoConstraints = false
                        if let topAnchor = window?.contentView?.topAnchor,
                           let bottomAnchor = window?.contentView?.bottomAnchor,
                           let leadingAnchor = window?.contentView?.leadingAnchor,
                           let trailingAnchor = window?.contentView?.trailingAnchor {
                                switch windowPattern {
                                case .regular:
                                        NSLayoutConstraint.activate([
                                                settingsUI.view.topAnchor.constraint(equalTo: topAnchor, constant: offset),
                                                settingsUI.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset)
                                        ])
                                case .horizontalReversed:
                                        NSLayoutConstraint.activate([
                                                settingsUI.view.topAnchor.constraint(equalTo: topAnchor, constant: offset),
                                                settingsUI.view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset)
                                        ])
                                case .verticalReversed:
                                        NSLayoutConstraint.activate([
                                                settingsUI.view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset),
                                                settingsUI.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset)
                                        ])
                                case .reversed:
                                        NSLayoutConstraint.activate([
                                                settingsUI.view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset),
                                                settingsUI.view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset)
                                        ])
                                }
                        }
                        window?.contentViewController?.addChild(settingsUI)
                        window?.setFrame(.zero, display: true)
                        settingsObject.resetHighlightedIndex()
                        window?.setFrame(frame, display: true)
                default:
                        let candidateUI = NSHostingController(rootView: CandidateView().environmentObject(displayObject).visualEffect())
                        window?.contentView?.addSubview(candidateUI.view)
                        candidateUI.view.translatesAutoresizingMaskIntoConstraints = false
                        if let topAnchor = window?.contentView?.topAnchor,
                           let bottomAnchor = window?.contentView?.bottomAnchor,
                           let leadingAnchor = window?.contentView?.leadingAnchor,
                           let trailingAnchor = window?.contentView?.trailingAnchor {
                                switch windowPattern {
                                case .regular:
                                        NSLayoutConstraint.activate([
                                                candidateUI.view.topAnchor.constraint(equalTo: topAnchor, constant: offset),
                                                candidateUI.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset)
                                        ])
                                case .horizontalReversed:
                                        NSLayoutConstraint.activate([
                                                candidateUI.view.topAnchor.constraint(equalTo: topAnchor, constant: offset),
                                                candidateUI.view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset)
                                        ])
                                case .verticalReversed:
                                        NSLayoutConstraint.activate([
                                                candidateUI.view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset),
                                                candidateUI.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset)
                                        ])
                                case .reversed:
                                        NSLayoutConstraint.activate([
                                                candidateUI.view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset),
                                                candidateUI.view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -offset)
                                        ])
                                }
                        }
                        window?.contentViewController?.addChild(candidateUI)
                        window?.setFrame(.zero, display: true)
                }
        }

        private lazy var windowPattern: WindowPattern = .regular

        private func windowFrame(origin: CGPoint? = nil) -> CGRect {
                let origin: CGPoint = origin ?? currentClient?.position ?? .zero
                let width: CGFloat = 600
                let height: CGFloat = 380 + (offset * 2)
                let x: CGFloat = {
                        if windowPattern.isReversingHorizontal {
                                return origin.x - width - 8
                        } else {
                                return origin.x
                        }
                }()
                let y: CGFloat = {
                        if windowPattern.isReversingVertical {
                                return origin.y + 16
                        } else {
                                return origin.y - height
                        }
                }()
                return CGRect(x: x, y: y, width: width, height: height)
        }

        private lazy var currentClient: IMKTextInput? = nil {
                didSet {
                        guard let origin = currentClient?.position else { return }
                        let isRegularHorizontal: Bool = origin.x < (screenFrame.maxX - 600)
                        let isRegularVertical: Bool = origin.y > (screenFrame.minY + 400)
                        let newPattern: WindowPattern = {
                                switch (isRegularHorizontal, isRegularVertical) {
                                case (true, true):
                                        return .regular
                                case (false, true):
                                        return .horizontalReversed
                                case (true, false):
                                        return .verticalReversed
                                case (false, false):
                                        return .reversed
                                }
                        }()
                        let shouldResetWindow: Bool = newPattern != windowPattern || window == nil || oldValue == nil
                        if shouldResetWindow {
                                windowPattern = newPattern
                                resetWindow()
                        }
                }
        }

        private lazy var displayObject = DisplayObject()
        private lazy var settingsObject = InstantSettingsObject()

        private lazy var candidates: [Candidate] = [] {
                didSet {
                        updateDisplayingCandidates(.establish)
                }
        }

        /// DisplayCandidates indices
        private lazy var indices: (first: Int, last: Int) = (0, 0)

        private func updateDisplayingCandidates(_ mode: CandidatesTransformation) {
                guard !candidates.isEmpty else {
                        indices = (0, 0)
                        displayObject.reset()
                        return
                }
                let pageSize: Int = AppSettings.displayCandidatePageSize
                let newFirstIndex: Int? = {
                        switch mode {
                        case .establish:
                                return 0
                        case .previousPage:
                                let oldFirstIndex: Int = indices.first
                                guard oldFirstIndex > 0 else { return nil }
                                return max(0, oldFirstIndex - pageSize)
                        case .nextPage:
                                let oldLastIndex: Int = indices.last
                                guard oldLastIndex < candidates.count - 1 else { return nil }
                                return oldLastIndex + 1
                        }
                }()
                guard let firstIndex: Int = newFirstIndex else { return }
                let bound: Int = min(firstIndex + pageSize, candidates.count)
                indices = (firstIndex, bound - 1)
                let newItems = candidates[firstIndex..<bound].map { item -> DisplayCandidate in
                        switch item.type {
                        case .cantonese:
                                return DisplayCandidate(item.text, comment: item.romanization)
                        case .specialMark:
                                return DisplayCandidate(item.text)
                        case .emoji:
                                let convertedText: String = convert(text: item.lexiconText, logogram: Logogram.current)
                                let comment: String = "〔\(convertedText)〕"
                                return DisplayCandidate(item.text, comment: comment)
                        case .symbol:
                                let originalComment: String = item.lexiconText
                                lazy var convertedComment: String = convert(text: originalComment, logogram: Logogram.current)
                                let comment: String? = originalComment.isEmpty ? nil : "〔\(convertedComment)〕"
                                let secondaryComment: String? = item.romanization.isEmpty ? nil : item.romanization
                                return DisplayCandidate(item.text, comment: comment, secondaryComment: secondaryComment)
                        }
                }
                displayObject.setItems(newItems)
        }

        private lazy var bufferText: String = .empty {
                didSet {
                        indices = (0, 0)
                        switch bufferText.first {
                        case .none:
                                processingText = .empty
                        case .some("r"), .some("v"), .some("x"), .some("q"):
                                processingText = bufferText
                        case .some(let character) where character.isBasicLatinLetter:
                                processingText = bufferText.replacingOccurrences(of: "vv", with: "4")
                                        .replacingOccurrences(of: "xx", with: "5")
                                        .replacingOccurrences(of: "qq", with: "6")
                                        .replacingOccurrences(of: "v", with: "1")
                                        .replacingOccurrences(of: "x", with: "2")
                                        .replacingOccurrences(of: "q", with: "3")
                        default:
                                processingText = bufferText
                        }
                }
        }
        private lazy var processingText: String = .empty {
                willSet {
                        if processingText.isEmpty && !newValue.isEmpty {
                                Lychee.prepare()
                        }
                }
                didSet {
                        switch processingText.first {
                        case .none:
                                segmentation = []
                                markedText = .empty
                                candidates = []
                                displayObject.reset()
                                window?.setFrame(.zero, display: true)
                                break
                        case .some("r"):
                                segmentation = []
                                markedText = processingText
                                pinyinReverseLookup()
                        case .some("v"):
                                segmentation = []
                                markedText = processingText
                                cangjieReverseLookup()
                        case .some("x"):
                                segmentation = []
                                markedText = processingText
                                strokeReverseLookup()
                        case .some("q"):
                                segmentation = []
                                markedText = processingText
                                leungFanReverseLookup()
                        case .some(let character) where character.isBasicLatinLetter:
                                segmentation = Segmentor.segment(processingText)
                                markedText = {
                                        guard !(processingText.contains("'")) else { return processingText.replacingOccurrences(of: "'", with: "' ") }
                                        guard let bestScheme = segmentation.first else { return processingText }
                                        let leading: String = bestScheme.joined(separator: " ")
                                        let isFullScheme: Bool = bestScheme.length == processingText.count
                                        guard !isFullScheme else { return leading }
                                        let tail = processingText.dropFirst(bestScheme.length)
                                        return leading + " " + tail
                                }()
                                suggest()
                        default:
                                segmentation = []
                                markedText = processingText
                                if Logogram.current == .simplified && simplifier == nil {
                                        simplifier = Simplifier()
                                }
                                let symbols: [PunctuationSymbol] = {
                                        switch processingText {
                                        case PunctuationKey.comma.shiftingKeyText:
                                                return PunctuationKey.comma.shiftingSymbols
                                        case PunctuationKey.period.shiftingKeyText:
                                                return PunctuationKey.period.shiftingSymbols
                                        case PunctuationKey.slash.keyText:
                                                return PunctuationKey.slash.symbols

                                        case PunctuationKey.bracketLeft.shiftingKeyText:
                                                return PunctuationKey.bracketLeft.shiftingSymbols
                                        case PunctuationKey.bracketRight.shiftingKeyText:
                                                return PunctuationKey.bracketRight.shiftingSymbols
                                        case PunctuationKey.backSlash.shiftingKeyText:
                                                return PunctuationKey.backSlash.shiftingSymbols
                                        default:
                                                return PunctuationKey.slash.symbols
                                        }
                                }()
                                candidates = symbols.map({ Candidate(key: bufferText, symbol: $0.symbol, comment: $0.comment, secondaryComment: $0.secondaryComment) })
                        }
                }
        }

        private lazy var markedText: String = .empty {
                didSet {
                        let convertedText: NSString = markedText as NSString
                        currentClient?.setMarkedText(convertedText, selectionRange: NSRange(location: convertedText.length, length: 0), replacementRange: NSRange(location: NSNotFound, length: 0))
                }
        }

        /// Flexible Segmentation
        private lazy var segmentation: Segmentation = []

        private func suggest() {
                let engineCandidates: [Candidate] = {
                        let convertedSegmentation: Segmentation = segmentation.converted()
                        var normal: [Candidate] = Lychee.suggest(for: processingText, segmentation: convertedSegmentation)
                        let droppedLast = processingText.dropLast()
                        let shouldDropSeparator: Bool = normal.isEmpty && processingText.hasSuffix("'") && !droppedLast.contains("'")
                        guard !shouldDropSeparator else {
                                let droppedSeparator: String = String(processingText.dropLast())
                                let newSchemes: [[String]] = Segmentor.segment(droppedSeparator).filter({ $0.joined() == droppedSeparator || $0.count == 1 })
                                return Lychee.suggest(for: droppedSeparator, segmentation: newSchemes)
                        }
                        let shouldContinue: Bool = InstantSettings.needsEmojiCandidates && !normal.isEmpty && candidateSequence.isEmpty
                        guard shouldContinue else { return normal }
                        let emojis: [Candidate] = Lychee.searchEmojis(for: bufferText)
                        for emoji in emojis.reversed() {
                                if let index = normal.firstIndex(where: { $0.lexiconText == emoji.lexiconText }) {
                                        normal.insert(emoji, at: index + 1)
                                }
                        }
                        return normal
                }()
                let lexiconCandidates: [Candidate] = userLexicon?.suggest(for: processingText) ?? []
                let combined: [Candidate] = lexiconCandidates + engineCandidates
                push(combined)
        }

        private func pinyinReverseLookup() {
                let text: String = String(processingText.dropFirst())
                guard !text.isEmpty else {
                        candidates = []
                        return
                }
                let lookup: [Candidate] = Lychee.pinyinLookup(for: text)
                push(lookup)
        }
        private func cangjieReverseLookup() {
                let text: String = String(processingText.dropFirst())
                guard !text.isEmpty else {
                        candidates = []
                        return
                }
                let lookup: [Candidate] = Lychee.cangjieLookup(for: text)
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
                let lookup: [Candidate] = Lychee.strokeLookup(for: text)
                push(lookup)
        }
        private func leungFanReverseLookup() {
                let text: String = String(processingText.dropFirst())
                guard !text.isEmpty else {
                        candidates = []
                        return
                }
                let lookup: [Candidate] = Lychee.leungFanLookup(for: text)
                push(lookup)
        }
        private func push(_ origin: [Candidate]) {
                switch Logogram.current {
                case .traditional:
                        candidates = origin.uniqued()
                case .hongkong:
                        let converted: [Candidate] = origin.map({ transform($0, logogram: .hongkong) })
                        candidates = converted.uniqued()
                case .taiwan:
                        let converted: [Candidate] = origin.map({ transform($0, logogram: .taiwan) })
                        candidates = converted.uniqued()
                case .simplified:
                        if simplifier == nil {
                                simplifier = Simplifier()
                        }
                        let converted: [Candidate] = origin.map({ transform($0, logogram: .simplified) })
                        candidates = converted.uniqued()
                }
        }
        private func transform(_ candidate: Candidate, logogram: Logogram) -> Candidate {
                guard candidate.isCantonese else { return candidate }
                let convertedText: String = convert(text: candidate.text, logogram: logogram)
                return Candidate(text: convertedText, romanization: candidate.romanization, input: candidate.input, lexiconText: candidate.lexiconText)
        }
        private func convert(text: String, logogram: Logogram) -> String {
                switch logogram {
                case .traditional:
                        return text
                case .hongkong:
                        return Converter.convert(text, to: .hongkong)
                case .taiwan:
                        return Converter.convert(text, to: .taiwan)
                case .simplified:
                        return simplifier?.convert(text) ?? text
                }
        }

        private lazy var userLexicon: UserLexicon? = nil
        private lazy var simplifier: Simplifier? = nil

        override func activateServer(_ sender: Any!) {
                currentClient = sender as? IMKTextInput
                Lychee.connect()
                if userLexicon == nil {
                        userLexicon = UserLexicon()
                }
                if !bufferText.isEmpty {
                        bufferText = .empty
                }
                resetWindow()
                DispatchQueue.main.async { [weak self] in
                        self?.currentClient?.overrideKeyboard(withKeyboardNamed: "com.apple.keylayout.ABC")
                }
        }
        override func deactivateServer(_ sender: Any!) {
                Lychee.close()
                userLexicon?.close()
                userLexicon = nil
                simplifier?.close()
                simplifier = nil

                bufferText = .empty
                markedText = .empty
                candidates = []
                candidateSequence = []
                displayObject.reset()
                settingsObject.resetHighlightedIndex()
                indices = (0, 0)
                window?.setFrame(.zero, display: true)

                currentClient = nil
        }

        private lazy var inputState: InputState = {
                switch InstantSettings.inputMethodMode {
                case .cantonese:
                        return .cantonese
                case .english:
                        return .english
                }
        }() {
                didSet {
                        resetWindow()
                }
        }
        private var isBufferState: Bool {
                return !(bufferText.isEmpty)
        }
        private lazy var candidateSequence: [Candidate] = []

        override func recognizedEvents(_ sender: Any!) -> Int {
                let masks: NSEvent.EventTypeMask = [.keyDown, .flagsChanged]
                return Int(masks.rawValue)
        }

        override func handle(_ event: NSEvent!, client sender: Any!) -> Bool {
                let modifiers = event.modifierFlags
                let shouldIgnoreCurrentEvent: Bool = modifiers.contains(.command) || modifiers.contains(.option)
                guard !shouldIgnoreCurrentEvent else { return false }
                guard let client: IMKTextInput = sender as? IMKTextInput else { return false }
                let shouldResetClient: Bool = {
                        guard let previousPosition = currentClient?.position else { return true }
                        guard !bufferText.isEmpty else { return true }
                        let distanceX = client.position.x.distance(to: previousPosition.x)
                        let distanceY = client.position.y.distance(to: previousPosition.y)
                        let hasSignificantDistance: Bool = abs(distanceX) > 300 || abs(distanceY) > 300
                        return hasSignificantDistance
                }()
                if shouldResetClient {
                        currentClient = client
                }
                func toggleInstantSettingsView() {
                        switch inputState {
                        case .cantonese:
                                passBuffer()
                                inputState = .instantSettings
                        case .english:
                                inputState = .instantSettings
                        case .instantSettings:
                                handleSettings(-1)
                        }
                }
                lazy var hasControlShiftModifiers: Bool = false
                switch modifiers {
                case [.control, .shift], .control:
                        switch event.keyCode {
                        case KeyCode.Symbol.VK_COMMA:
                                // handled by NSMenu
                                return false
                        case KeyCode.Symbol.VK_BACKQUOTE:
                                toggleInstantSettingsView()
                                return true
                        /*
                        case KeyCode.Symbol.VK_MINUS:
                                inputState = .cantonese
                                InstantSettings.updateInputMethodMode(to: .cantonese)
                                return true
                        case KeyCode.Symbol.VK_EQUAL:
                                inputState = .english
                                InstantSettings.updateInputMethodMode(to: .english)
                                return true
                        */
                        case KeyCode.Special.VK_BACKWARD_DELETE:
                                switch inputState {
                                case .cantonese:
                                        guard !(candidates.isEmpty) else { return false }
                                        let index = displayObject.highlightedIndex
                                        guard let selectedItem = displayObject.items.fetch(index) else { return false }
                                        for candidate in candidates where candidate.isCantonese {
                                                let isEqual: Bool = candidate.text == selectedItem.text && candidate.romanization == selectedItem.comment
                                                if isEqual {
                                                        userLexicon?.removeItem(candidate: candidate)
                                                        break
                                                }
                                        }
                                        return true
                                case .english:
                                        return false
                                case .instantSettings:
                                        return true
                                }
                        case KeyCode.Alphabet.VK_U:
                                guard inputState.isCantonese && isBufferState else { return false }
                                shutdownSession()
                                return true
                        case let value where KeyCode.numberSet.contains(value):
                                hasControlShiftModifiers = true
                        default:
                                return false
                        }
                case .option, .capsLock, .function, .help:
                        return false
                default:
                        break
                }
                let isShifting: Bool = modifiers == .shift
                switch event.keyCode.representative {
                case .arrow(let direction):
                        switch direction {
                        case .up:
                                switch inputState {
                                case .cantonese:
                                        guard isBufferState else { return false }
                                        displayObject.decreaseHighlightedIndex()
                                        return true
                                case .english:
                                        return false
                                case .instantSettings:
                                        settingsObject.decreaseHighlightedIndex()
                                        return true
                                }
                        case .down:
                                switch inputState {
                                case .cantonese:
                                        guard isBufferState else { return false }
                                        displayObject.increaseHighlightedIndex()
                                        return true
                                case .english:
                                        return false
                                case .instantSettings:
                                        settingsObject.increaseHighlightedIndex()
                                        return true
                                }
                        case .left:
                                return false
                        case .right:
                                return false
                        }
                case .number(let number):
                        let index: Int = number == 0 ? 9 : (number - 1)
                        switch inputState {
                        case .cantonese:
                                if isBufferState {
                                        selectDisplayingItem(index: index, client: client)
                                        adjustWindow(origin: client.position)
                                        return true
                                        /*
                                        if hasControlShiftModifiers {
                                                guard AppSettings.isSpeakCandidateEnabled else { return true }
                                                guard let item = displayObject.items.fetch(index) else { return true }
                                                guard let romanization = item.comment else { return true }
                                                Speech.speak(romanization)
                                                return true
                                        } else {
                                                selectDisplayingItem(index: index, client: client)
                                                adjustWindow(origin: client.position)
                                                return true
                                        }
                                        */
                                } else {
                                        if hasControlShiftModifiers {
                                                handleSettings(index)
                                                return true
                                        } else {
                                                switch InstantSettings.characterForm {
                                                case .halfWidth:
                                                        let shouldInsertCantoneseSymbol: Bool = InstantSettings.punctuation.isCantoneseMode && isShifting
                                                        guard shouldInsertCantoneseSymbol else { return false }
                                                        let text: String = KeyCode.shiftingSymbol(of: number)
                                                        insert(text)
                                                        return true
                                                case .fullWidth:
                                                        let text: String = isShifting ? KeyCode.shiftingSymbol(of: number) : "\(number)"
                                                        let fullWidthText: String = text.fullWidth()
                                                        insert(fullWidthText)
                                                        return true
                                                }
                                        }
                                }
                        case .english:
                                if hasControlShiftModifiers {
                                        handleSettings(index)
                                        return true
                                } else {
                                        return false
                                }
                        case .instantSettings:
                                handleSettings(index)
                                return true
                        }
                case .punctuation(let punctuationKey):
                        switch inputState {
                        case .cantonese:
                                guard candidates.isEmpty else {
                                        switch punctuationKey {
                                        case .bracketLeft, .comma:
                                                updateDisplayingCandidates(.previousPage)
                                                return true
                                        case .bracketRight, .period:
                                                updateDisplayingCandidates(.nextPage)
                                                return true
                                        default:
                                                return true
                                        }
                                }
                                passBuffer()
                                guard InstantSettings.punctuation.isCantoneseMode else { return false }
                                if isShifting {
                                        if let symbol = punctuationKey.instantShiftingSymbol {
                                                insert(symbol)
                                        } else {
                                                bufferText = punctuationKey.shiftingKeyText
                                        }
                                } else {
                                        if let symbol = punctuationKey.instantSymbol {
                                                insert(symbol)
                                        } else {
                                                bufferText = punctuationKey.keyText
                                        }
                                }
                                adjustWindow(origin: client.position)
                                return true
                        case .english:
                                return false
                        case .instantSettings:
                                return true
                        }
                case .alphabet(let letter):
                        switch inputState {
                        case .cantonese:
                                let hasCharacters: Bool = event.characters.hasContent
                                guard hasCharacters else { return false }
                                let text: String = isShifting ? letter.uppercased() : letter
                                bufferText += text
                                adjustWindow(origin: client.position)
                                return true
                        case .english:
                                return false
                        case .instantSettings:
                                return true
                        }
                case .separator:
                        switch inputState {
                        case .cantonese:
                                guard isBufferState else { return false }
                                bufferText += "'"
                                return true
                        case .english:
                                return false
                        case .instantSettings:
                                return true
                        }
                case .return:
                        switch inputState {
                        case .cantonese:
                                guard isBufferState else { return false }
                                passBuffer()
                                return true
                        case .english:
                                return false
                        case .instantSettings:
                                handleSettings()
                                return true
                        }
                case .backspace:
                        switch inputState {
                        case .cantonese:
                                guard isBufferState else { return false }
                                bufferText = String(bufferText.dropLast())
                                adjustWindow(origin: client.position)
                                return true
                        case .english:
                                return false
                        case .instantSettings:
                                handleSettings(-1)
                                return true
                        }
                case .escapeClear:
                        switch inputState {
                        case .cantonese:
                                guard isBufferState else { return false }
                                shutdownSession()
                                return true
                        case .english:
                                return false
                        case .instantSettings:
                                handleSettings(-1)
                                return true
                        }
                case .space:
                        switch inputState {
                        case .cantonese:
                                if candidates.isEmpty {
                                        passBuffer()
                                        let shouldInsertFullWidthSpace: Bool = isShifting || InstantSettings.characterForm == .fullWidth
                                        guard shouldInsertFullWidthSpace else { return false }
                                        insert(String.fullWidthSpace)
                                        return true
                                } else {
                                        selectDisplayingItem(index: displayObject.highlightedIndex, client: client)
                                        adjustWindow(origin: client.position)
                                        return true
                                }
                        case .english:
                                return false
                        case .instantSettings:
                                handleSettings()
                                return true
                        }
                case .tab:
                        switch inputState {
                        case .cantonese:
                                guard isBufferState else { return false }
                                displayObject.increaseHighlightedIndex()
                                return true
                        case .english:
                                return false
                        case .instantSettings:
                                settingsObject.increaseHighlightedIndex()
                                return true
                        }
                case .previousPage:
                        switch inputState {
                        case .cantonese:
                                guard isBufferState else { return false }
                                updateDisplayingCandidates(.previousPage)
                                return true
                        case .english:
                                return false
                        case .instantSettings:
                                return true
                        }
                case .nextPage:
                        switch inputState {
                        case .cantonese:
                                guard isBufferState else { return false }
                                updateDisplayingCandidates(.nextPage)
                                return true
                        case .english:
                                return false
                        case .instantSettings:
                                return true
                        }
                case .other:
                        switch event.keyCode {
                        case KeyCode.Special.VK_HOME:
                                let shouldJump2FirstPage: Bool = inputState == .cantonese && !(candidates.isEmpty)
                                guard shouldJump2FirstPage else { return false }
                                updateDisplayingCandidates(.establish)
                                return true
                        default:
                                return false
                        }
                }
        }

        private func adjustWindow(origin: CGPoint? = nil) {
                let isEmptyWindow: Bool = bufferText.isEmpty || candidates.isEmpty
                let frame: CGRect = isEmptyWindow ? .zero : windowFrame(origin: origin)
                window?.setFrame(frame, display: true)
        }

        private func passBuffer() {
                guard isBufferState else { return }
                let text: String = InstantSettings.characterForm == .halfWidth ? bufferText : bufferText.fullWidth()
                insert(text)
                bufferText = .empty
                candidateSequence = []
        }

        private func handleSettings(_ index: Int? = nil) {
                let selectedIndex: Int = index ?? settingsObject.highlightedIndex
                defer {
                        settingsObject.resetHighlightedIndex()
                        window?.setFrame(.zero, display: true)
                        inputState = {
                                switch InstantSettings.inputMethodMode {
                                case .cantonese:
                                        return .cantonese
                                case .english:
                                        return .english
                                }
                        }()
                }
                switch selectedIndex {
                case -1:
                        return
                case 4:
                        InstantSettings.updateCharacterFormState(to: .halfWidth)
                case 5:
                        InstantSettings.updateCharacterFormState(to: .fullWidth)
                case 6:
                        InstantSettings.updatePunctuationState(to: .cantonese)
                case 7:
                        InstantSettings.updatePunctuationState(to: .english)
                case 8:
                        InstantSettings.updateNeedsEmojiCandidates(to: true)
                case 9:
                        InstantSettings.updateNeedsEmojiCandidates(to: false)
                default:
                        break
                }
                let newSelection: Logogram = {
                        switch selectedIndex {
                        case 0:
                                return .traditional
                        case 1:
                                return .hongkong
                        case 2:
                                return .taiwan
                        case 3:
                                return .simplified
                        default:
                                return Logogram.current
                        }
                }()
                guard newSelection != Logogram.current else { return }
                Logogram.updateCurrent(to: newSelection)
        }

        private func selectDisplayingItem(index: Int, client: IMKTextInput) {
                guard let selectedItem = displayObject.items.fetch(index) else { return }
                client.insertText(selectedItem.text, replacementRange: NSRange(location: NSNotFound, length: NSNotFound))

                let find: Candidate? = {
                        for item in candidates where item.isCantonese {
                                let isEqual: Bool = item.text == selectedItem.text && item.romanization == selectedItem.comment
                                if isEqual {
                                        return item
                                }
                        }
                        return nil
                }()
                guard let candidate = find else {
                        shutdownSession()
                        return
                }
                switch bufferText.first {
                case .none:
                        break
                case .some("r"), .some("v"), .some("x"), .some("q"):
                        if bufferText.count <= candidate.input.count + 1 {
                                shutdownSession()
                        } else {
                                let first: String = String(bufferText.first!)
                                let tail = bufferText.dropFirst(candidate.input.count + 1)
                                bufferText = first + tail
                        }
                default:
                        defer {
                                if bufferText.isEmpty && !candidateSequence.isEmpty {
                                        let concatenatedCandidate: Candidate = candidateSequence.joined()
                                        candidateSequence = []
                                        userLexicon?.handle(concatenatedCandidate)
                                }
                        }
                        candidateSequence.append(candidate)
                        let bufferTextLength: Int = bufferText.count
                        let candidateInputText: String = {
                                let converted: String = candidate.input.replacingOccurrences(of: "(4|5|6)", with: "RR", options: .regularExpression)
                                return converted
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
                        var tail: String.SubSequence = {
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

        private func insert(_ text: String) {
                currentClient?.insertText(text, replacementRange: NSRange(location: NSNotFound, length: NSNotFound))
        }

        private func shutdownSession() {
                candidateSequence = []
                bufferText = .empty
        }
}


enum CandidatesTransformation {
        case establish
        case previousPage
        case nextPage
}

