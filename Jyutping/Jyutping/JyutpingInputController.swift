import SwiftUI
import Cocoa
import InputMethodKit
import CommonExtensions
import InputMethodData
import CharacterSets

class JyutpingInputController: IMKInputController {

        private lazy var window: NSWindow? = nil
        private lazy var screenFrame: CGRect = NSScreen.main?.frame ?? CGRect(origin: .zero, size: CGSize(width: 1920, height: 1080))
        private let offset: CGFloat = 10

        private func resetWindow() {
                _ = window?.contentView?.subviews.map({ $0.removeFromSuperview() })
                _ = window?.contentViewController?.children.map({ $0.removeFromParent() })
                window = NSWindow(contentRect: windowFrame(), styleMask: .borderless, backing: .buffered, defer: false)
                window?.backgroundColor = .clear
                window?.level = .floating
                window?.orderFrontRegardless()
                switch inputMethodMode {
                case .settings:
                        let settingsUI = NSHostingController(rootView: SettingsView().environmentObject(settingsObject))
                        window?.contentView?.addSubview(settingsUI.view)
                        settingsUI.view.translatesAutoresizingMaskIntoConstraints = false
                        if let topAnchor = window?.contentView?.topAnchor, let bottomAnchor = window?.contentView?.bottomAnchor, let leadingAnchor = window?.contentView?.leadingAnchor {
                                if windowPattern.isReversingVertical {
                                        NSLayoutConstraint.activate([
                                                settingsUI.view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset),
                                                settingsUI.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset)
                                        ])
                                } else {
                                        NSLayoutConstraint.activate([
                                                settingsUI.view.topAnchor.constraint(equalTo: topAnchor, constant: offset),
                                                settingsUI.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset)
                                        ])
                                }
                        }
                        window?.contentViewController?.addChild(settingsUI)
                default:
                        let candidateUI = NSHostingController(rootView: CandidatesView().environmentObject(displayObject))
                        window?.contentView?.addSubview(candidateUI.view)
                        candidateUI.view.translatesAutoresizingMaskIntoConstraints = false
                        if let topAnchor = window?.contentView?.topAnchor, let bottomAnchor = window?.contentView?.bottomAnchor, let leadingAnchor = window?.contentView?.leadingAnchor {
                                if windowPattern.isReversingVertical {
                                        NSLayoutConstraint.activate([
                                                candidateUI.view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset),
                                                candidateUI.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset)
                                        ])
                                } else {
                                        NSLayoutConstraint.activate([
                                                candidateUI.view.topAnchor.constraint(equalTo: topAnchor, constant: offset),
                                                candidateUI.view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: offset)
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
                let height: CGFloat = 300 + (offset * 2)
                let x: CGFloat = {
                        if windowPattern.isReversingHorizontal {
                                // FIXME: should be on cursor's left side
                                return origin.x
                        } else {
                                return origin.x
                        }
                }()
                let y: CGFloat = {
                        if windowPattern.isReversingVertical {
                                return origin.y + (offset * 2)
                        } else {
                                return (origin.y - height)
                        }
                }()
                return CGRect(x: x, y: y, width: width, height: height)
        }

        private lazy var currentClient: IMKTextInput? = nil {
                didSet {
                        guard let origin = currentClient?.position else { return }
                        let isRegularHorizontal: Bool = origin.x < (screenFrame.maxX - 600)
                        let isRegularVertical: Bool = origin.y > (screenFrame.minY + 320)
                        windowPattern = {
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
                }
        }

        private lazy var displayObject = DisplayObject()
        private lazy var settingsObject = SettingsObject()

        private lazy var candidates: [Candidate] = [] {
                didSet {
                        firstIndex = 0
                }
        }
        private lazy var firstIndex: Int = 0 {
                didSet {
                        guard !candidates.isEmpty else {
                                lastIndex = 0
                                displayObject.reset()
                                return
                        }
                        displayObject.resetHighlightedIndex()
                        let bound: Int = (firstIndex == 0) ? min(9, candidates.count) : min(firstIndex + 9, candidates.count)
                        lastIndex = bound - 1
                        let newItems = candidates[firstIndex..<bound].map({ DisplayCandidate($0.text, comment: $0.romanization) })
                        displayObject.setItems(newItems)
                }
        }
        private lazy var lastIndex: Int = 0

        private lazy var bufferText: String = .empty {
                didSet {
                        switch bufferText.first {
                        case .none:
                                processingText = .empty
                        case .some("r"), .some("v"), .some("x"), .some("q"):
                                processingText = bufferText
                        default:
                                processingText = bufferText.replacingOccurrences(of: "vv", with: "4")
                                        .replacingOccurrences(of: "xx", with: "5")
                                        .replacingOccurrences(of: "qq", with: "6")
                                        .replacingOccurrences(of: "v", with: "1")
                                        .replacingOccurrences(of: "x", with: "2")
                                        .replacingOccurrences(of: "q", with: "3")
                        }
                }
        }
        private lazy var processingText: String = .empty {
                didSet {
                        switch processingText.first {
                        case .none:
                                flexibleSchemes = []
                                markedText = .empty
                                candidates = []
                                displayObject.reset()
                                window?.setFrame(.zero, display: true)
                                break
                        case .some("r"):
                                flexibleSchemes = []
                                markedText = processingText
                                pinyinReverseLookup()
                        case .some("v"):
                                flexibleSchemes = []
                                markedText = processingText
                                cangjieReverseLookup()
                        case .some("x"):
                                flexibleSchemes = []
                                markedText = processingText
                                strokeReverseLookup()
                        case .some("q"):
                                flexibleSchemes = []
                                markedText = processingText
                                loengfanReverseLookup()
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
                                suggest()
                        }
                }
        }

        private lazy var markedText: String = .empty {
                didSet {
                        let convertedText: NSString = markedText as NSString
                        currentClient?.setMarkedText(convertedText, selectionRange: NSRange(location: convertedText.length, length: 0), replacementRange: NSRange(location: NSNotFound, length: 0))
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
                                                .replacingOccurrences(of: "(eoy|oey)$", with: "eoi", options: .regularExpression)
                                                .replacingOccurrences(of: "^([b-z]|ng)(u|o)m$", with: "$1am", options: .regularExpression)
                                                .replacingOccurrences(of: "^y(u|un|ut)$", with: "jy$1", options: .regularExpression)
                                                .replacingOccurrences(of: "y", with: "j", options: .anchored)
                                        return converted
                                }
                                return sequence
                        })
                }
        }
        private lazy var regularSchemes: [[String]] = []

        private func suggest() {
                let lexiconCandidates: [Candidate] = userLexicon?.suggest(for: processingText) ?? []
                let engineCandidates: [Candidate] = {
                        let normal: [Candidate] = engine?.suggest(for: processingText, schemes: regularSchemes.uniqued()) ?? []
                        if normal.isEmpty && processingText.hasSuffix("'") && !processingText.dropLast().contains("'") {
                                let droppedSeparator: String = String(processingText.dropLast())
                                let newSchemes: [[String]] = Splitter.split(droppedSeparator).uniqued().filter({ $0.joined() == droppedSeparator || $0.count == 1 })
                                return engine?.suggest(for: droppedSeparator, schemes: newSchemes) ?? []
                        } else {
                                return normal
                        }
                }()
                let combined: [Candidate] = lexiconCandidates + engineCandidates
                push(combined)
        }

        private func pinyinReverseLookup() {
                let text: String = String(processingText.dropFirst())
                guard !text.isEmpty else {
                        candidates = []
                        return
                }
                if pinyinProvider == nil {
                        pinyinProvider = PinyinProvider()
                }
                guard let searches = pinyinProvider?.search(for: text), !searches.isEmpty else { return }
                let lookup: [[Candidate]] = searches.map { lexicon -> [Candidate] in
                        let romanizations: [String] = Lookup.look(for: lexicon.text)
                        let candidates: [Candidate] = romanizations.map({ Candidate(text: lexicon.text, romanization: $0, input: lexicon.input, lexiconText: lexicon.text) })
                        return candidates
                }
                let joined: [Candidate] = Array<Candidate>(lookup.joined())
                push(joined)
        }
        private func cangjieReverseLookup() {
                let text: String = String(processingText.dropFirst())
                guard !text.isEmpty else {
                        candidates = []
                        return
                }
                if shapeData == nil {
                        shapeData = ShapeData()
                }
                guard let searches = shapeData?.search(cangjie: text), !searches.isEmpty else { return }
                let lookup: [[Candidate]] = searches.map { lexicon -> [Candidate] in
                        let romanizations: [String] = Lookup.look(for: lexicon.text)
                        let candidates: [Candidate] = romanizations.map({ Candidate(text: lexicon.text, romanization: $0, input: lexicon.input, lexiconText: lexicon.text) })
                        return candidates
                }
                let joined: [Candidate] = Array<Candidate>(lookup.joined())
                push(joined)
        }
        private func strokeReverseLookup() {

                // 橫h => 橫w, 撇p => 撇a, 捺n => 點d
                let text: String = processingText.dropFirst().replacingOccurrences(of: "h", with: "w").replacingOccurrences(of: "p", with: "a").replacingOccurrences(of: "n", with: "d")

                guard !text.isEmpty else {
                        candidates = []
                        return
                }
                if shapeData == nil {
                        shapeData = ShapeData()
                }
                guard let searches = shapeData?.search(stroke: text), !searches.isEmpty else { return }
                let lookup: [[Candidate]] = searches.map { lexicon -> [Candidate] in
                        let romanizations: [String] = Lookup.look(for: lexicon.text)
                        let candidates: [Candidate] = romanizations.map({ Candidate(text: lexicon.text, romanization: $0, input: lexicon.input, lexiconText: lexicon.text) })
                        return candidates
                }
                let joined: [Candidate] = Array<Candidate>(lookup.joined())
                push(joined)
        }
        private func loengfanReverseLookup() {
                let text: String = String(processingText.dropFirst())
                guard !text.isEmpty else {
                        candidates = []
                        return
                }
                if loengfanProvider == nil {
                        loengfanProvider = LoengfanProvider()
                }
                guard let searches = loengfanProvider?.search(for: text), !searches.isEmpty else {
                        candidates = []
                        return
                }
                let lookup: [[Candidate]] = searches.map { lexicon -> [Candidate] in
                        let romanizations: [String] = Lookup.look(for: lexicon.text)
                        let candidates: [Candidate] = romanizations.map({ Candidate(text: lexicon.text, romanization: $0, input: lexicon.input, lexiconText: lexicon.text) })
                        return candidates
                }
                let joined: [Candidate] = Array<Candidate>(lookup.joined())
                push(joined)
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

        private lazy var engine: Engine? = nil
        private lazy var userLexicon: UserLexicon? = nil
        private lazy var pinyinProvider: PinyinProvider? = nil
        private lazy var shapeData: ShapeData? = nil
        private lazy var loengfanProvider: LoengfanProvider? = nil
        private lazy var simplifier: Simplifier? = nil

        override func activateServer(_ sender: Any!) {
                currentClient = sender as? IMKTextInput
                if engine == nil {
                        engine = Engine()
                }
                if userLexicon == nil {
                        userLexicon = UserLexicon()
                }
                resetWindow()
        }
        override func deactivateServer(_ sender: Any!) {
                engine?.close()
                engine = nil
                userLexicon?.close()
                userLexicon = nil
                pinyinProvider?.close()
                pinyinProvider = nil
                shapeData?.close()
                shapeData = nil
                loengfanProvider?.close()
                loengfanProvider = nil
                simplifier?.close()
                simplifier = nil

                shutdownSession()
                currentClient = nil
        }

        private lazy var inputMethodMode: InputMethodMode = .cantonese {
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
                guard let client: IMKTextInput = sender as? IMKTextInput else { return false }
                guard !(event.modifierFlags.contains(.command)) else { return false }  // Ignore any Command + ...
                let isShifting: Bool = event.modifierFlags == .shift

                switch event.keyCode.representative {
                case .arrow(let direction):
                        switch direction {
                        case .up:
                                guard !(inputMethodMode.isSettings) else {
                                        settingsObject.decreaseHighlightedIndex()
                                        return true
                                }
                                guard isBufferState else { return false }
                                displayObject.decreaseHighlightedIndex()
                        case .down:
                                guard !(inputMethodMode.isSettings) else {
                                        settingsObject.increaseHighlightedIndex()
                                        return true
                                }
                                guard isBufferState else { return false }
                                displayObject.increaseHighlightedIndex()
                        case .left:
                                return false
                        case .right:
                                return false
                        }
                case .number(let number):
                        guard !(inputMethodMode.isSettings) else {
                                if number >= 1 && number <= 4 {
                                        handleSettings(number - 1)
                                }
                                return true
                        }
                        if isBufferState {
                                selectDisplayingItem(index: number - 1, client: client)
                        } else {
                                let text: String = isShifting ? KeyCode.shiftingSymbol(of: number) : "\(number)"
                                insert(text)
                        }
                case .instant(let text):
                        if isBufferState {
                                selectDisplayingItem(index: displayObject.highlightedIndex, client: client)
                        }
                        passBuffer()
                        let symbol: String = {
                                guard isShifting else { return text }
                                switch text {
                                case "，": return "《"
                                case "。": return "》"
                                case "；": return "："
                                case "「": return "『"
                                case "」": return "』"
                                case "、": return "・"
                                default: return text
                                }
                        }()
                        insert(symbol)
                case .transparent:
                        passBuffer()
                        return false
                case .alphabet where event.modifierFlags.contains(.control):
                        let shouldPerformClearing: Bool = event.keyCode == KeyCode.Alphabet.VK_U && isBufferState
                        guard shouldPerformClearing else { return false }
                        bufferText = .empty
                case .alphabet:
                        guard let letter: String = event.characters else { return false }
                        bufferText += letter
                default:
                        switch event.keyCode {
                        case KeyCode.Symbol.VK_QUOTE:
                                guard isBufferState else { return false }
                                bufferText += "'"
                        case KeyCode.Symbol.VK_SLASH:
                                passBuffer()
                                let text: String = isShifting ? "？" : "/"
                                insert(text)
                        case KeyCode.Symbol.VK_MINUS, KeyCode.Special.VK_PAGEUP:
                                guard isBufferState else { return false }
                                guard !candidates.isEmpty && !displayObject.items.isEmpty else { return false }
                                guard firstIndex > 0 else { return true }
                                firstIndex = max(0, firstIndex - 9)
                        case KeyCode.Symbol.VK_EQUAL, KeyCode.Special.VK_PAGEDOWN:
                                guard isBufferState else { return false }
                                guard !candidates.isEmpty && !displayObject.items.isEmpty else { return false }
                                guard lastIndex < candidates.count - 1 else { return true }
                                firstIndex = lastIndex + 1
                        case KeyCode.Special.VK_SPACE:
                                guard isBufferState else { return false }
                                selectDisplayingItem(index: displayObject.highlightedIndex, client: client)
                        case KeyCode.Special.VK_RETURN, KeyCode.Keypad.VK_KEYPAD_ENTER:
                                guard !(inputMethodMode.isSettings) else {
                                        handleSettings()
                                        return true
                                }
                                guard isBufferState else { return false }
                                passBuffer()
                        case KeyCode.Special.VK_BACKWARD_DELETE:
                                guard isBufferState else { return false }
                                bufferText = String(bufferText.dropLast())
                        case KeyCode.Special.VK_ESCAPE, KeyCode.Keypad.VK_KEYPAD_CLEAR:
                                guard !(inputMethodMode.isSettings) else {
                                        handleSettings(-1)
                                        return true
                                }
                                guard isBufferState else { return false }
                                bufferText = .empty
                        case KeyCode.Symbol.VK_BACKQUOTE where event.modifierFlags == .control || event.modifierFlags == [.control, .shift]:
                                let shouldDisplaySettings: Bool = inputMethodMode == .cantonese && !isBufferState
                                guard shouldDisplaySettings else { return false }
                                inputMethodMode = .settings
                                return true
                        default:
                                return false
                        }
                }
                showCandidates(origin: client.position)
                return true
        }

        private func showCandidates(origin: CGPoint? = nil) {
                let shouldShowCandidates: Bool = isBufferState && !displayObject.items.isEmpty
                let frame: CGRect = shouldShowCandidates ? windowFrame(origin: origin) : .zero
                window?.setFrame(frame, display: true)
        }

        private func passBuffer() {
                guard isBufferState else { return }
                insert(bufferText)
                bufferText = .empty
        }

        private func handleSettings(_ index: Int? = nil) {
                let selectedIndex: Int = index ?? settingsObject.highlightedIndex
                defer {
                        settingsObject.resetHighlightedIndex()
                        window?.setFrame(.zero, display: true)
                        inputMethodMode = .cantonese
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
                Logogram.changeCurrent(to: newSelection)
                Logogram.updatePreference()
        }

        private func selectDisplayingItem(index: Int, client: IMKTextInput) {
                guard let selectedItem = displayObject.items.fetch(index) else { return }
                client.insertText(selectedItem.text, replacementRange: NSRange(location: NSNotFound, length: NSNotFound))

                let find: Candidate? = {
                        for item in candidates {
                                let isEqual: Bool = item.text == selectedItem.text && item.romanization == selectedItem.comment
                                if isEqual {
                                        return item
                                }
                        }
                        return nil
                }()
                guard let candidate = find else { return }
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
                        candidateSequence.append(candidate)
                        let bufferTextLength: Int = bufferText.count
                        let candidateInputText: String = {
                                let converted: String = candidate.input.replacingOccurrences(of: "(4|5|6)", with: "xx", options: .regularExpression)
                                return converted
                        }()
                        let inputCount: Int = {
                                let candidateInputCount: Int = candidateInputText.count
                                guard bufferTextLength > 2 else { return candidateInputCount }
                                guard candidateInputText.contains("jyu") else { return candidateInputCount }
                                let suffixCount: Int = max(0, bufferTextLength - candidateInputCount)
                                let leading = bufferText.dropLast(suffixCount)
                                let modifiedLeading = leading.replacingOccurrences(of: "(?<!c|s|j|z)yu(?!k|m|ng)", with: "jyu", options: .regularExpression)
                                return candidateInputCount - (modifiedLeading.count - leading.count)
                        }()
                        let leading = bufferText.dropLast(bufferTextLength - inputCount)
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
                        if tail.isEmpty {
                                shutdownSession()
                        } else {
                                bufferText = String(tail)
                        }
                }
                if bufferText.isEmpty && !candidateSequence.isEmpty {
                        let concatenatedCandidate: Candidate = candidateSequence.joined()
                        candidateSequence = []
                        userLexicon?.handle(concatenatedCandidate)
                }
        }

        private func insert(_ text: String) {
                currentClient?.insertText(text, replacementRange: NSRange(location: NSNotFound, length: NSNotFound))
        }

        private func shutdownSession() {
                bufferText = .empty
                candidates = []
                displayObject.reset()
                window?.setFrame(.zero, display: true)
        }
}
