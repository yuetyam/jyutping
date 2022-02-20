import SwiftUI
import Cocoa
import InputMethodKit
import KeyboardData
import LookupData
import Simplifier

class JyutpingInputController: IMKInputController {

        private lazy var window: NSWindow? = nil
        private lazy var isWindowInitialed: Bool = false
        private lazy var screenFrame: CGRect = NSScreen.main?.frame ?? CGRect(origin: .zero, size: CGSize(width: 1920, height: 1080))

        private func showCandidatesWindow(origin: CGPoint, size: CGSize = CGSize(width: 600, height: 256)) {
                guard isBufferState && !displayObject.items.isEmpty else {
                        if isWindowInitialed {
                                window?.setFrame(.zero, display: true)
                        }
                        return
                }
                let frame = windowFrame(origin, size: size)
                if isWindowInitialed {
                        window?.setFrame(frame, display: true)
                } else {
                        window = NSWindow(contentRect: frame, styleMask: .borderless, backing: .buffered, defer: false)
                        initialWindow()
                }
        }
        private func initialWindow() {
                window?.backgroundColor = .clear
                window?.level = .floating
                window?.orderFrontRegardless()

                let candidateUI = NSHostingController(rootView: CandidatesView().environmentObject(displayObject))
                window?.contentView?.addSubview(candidateUI.view)
                candidateUI.view.translatesAutoresizingMaskIntoConstraints = false
                if let topAnchor = window?.contentView?.topAnchor, let leadingAnchor = window?.contentView?.leadingAnchor {
                        NSLayoutConstraint.activate([
                                candidateUI.view.topAnchor.constraint(equalTo: topAnchor),
                                candidateUI.view.leadingAnchor.constraint(equalTo: leadingAnchor)
                        ])
                }
                window?.contentViewController?.addChild(candidateUI)

                isWindowInitialed = true
        }

        private func resetWindow() {
                _ = window?.contentView?.subviews.map({ $0.removeFromSuperview() })
                _ = window?.contentViewController?.children.map({ $0.removeFromParent() })
                switch inputMethodMode {
                case .settings:
                        window = NSWindow(contentRect: windowFrame(), styleMask: .borderless, backing: .buffered, defer: false)
                        window?.backgroundColor = .clear
                        window?.level = .floating
                        window?.orderFrontRegardless()
                        let candidateUI = NSHostingController(rootView: SettingsView().environmentObject(settingsObject))
                        window?.contentView?.addSubview(candidateUI.view)
                        candidateUI.view.translatesAutoresizingMaskIntoConstraints = false
                        if let topAnchor = window?.contentView?.topAnchor, let leadingAnchor = window?.contentView?.leadingAnchor {
                                NSLayoutConstraint.activate([
                                        candidateUI.view.topAnchor.constraint(equalTo: topAnchor),
                                        candidateUI.view.leadingAnchor.constraint(equalTo: leadingAnchor)
                                ])
                        }
                        window?.contentViewController?.addChild(candidateUI)
                default:
                        window = NSWindow(contentRect: .zero, styleMask: .borderless, backing: .buffered, defer: false)
                        initialWindow()
                }
        }

        // FIXME: candidateView size
        private func windowFrame(_ origin: CGPoint? = nil, size: CGSize = CGSize(width: 600, height: 256)) -> CGRect {
                let origin = origin ?? currentClient?.position ?? .zero
                let x: CGFloat = {
                        if origin.x > (screenFrame.maxX - size.width) {
                                // should be cursor's left side
                                return origin.x + 16
                        } else {
                                return origin.x + 16
                        }
                }()
                let y: CGFloat = {
                        if origin.y > (screenFrame.minY + size.height) {
                                // below cursor
                                return origin.y - size.height - 8
                        } else {
                                // above cursor
                                return origin.y + 16
                        }
                }()
                let frame = CGRect(x: x, y: y, width: size.width, height: size.height)
                return frame
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
                        case .some("r"), .some("v"), .some("x"):
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
        private lazy var currentClient: IMKTextInput? = nil
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
                push(engineCandidates)
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
                        let romanizations: [String] = LookupData.search(for: lexicon.text)
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
                        let romanizations: [String] = LookupData.search(for: lexicon.text)
                        let candidates: [Candidate] = romanizations.map({ Candidate(text: lexicon.text, romanization: $0, input: lexicon.input, lexiconText: lexicon.text) })
                        return candidates
                }
                let joined: [Candidate] = Array<Candidate>(lookup.joined())
                push(joined)
        }
        private func strokeReverseLookup() {
                let text: String = String(processingText.dropFirst())
                guard !text.isEmpty else {
                        candidates = []
                        return
                }
                if shapeData == nil {
                        shapeData = ShapeData()
                }
                guard let searches = shapeData?.search(stroke: text), !searches.isEmpty else { return }
                let lookup: [[Candidate]] = searches.map { lexicon -> [Candidate] in
                        let romanizations: [String] = LookupData.search(for: lexicon.text)
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
                case .hongkong, .taiwan:
                        let converted: [Candidate] = origin.map({ Candidate(text: VariantConverter.convert(text: $0.text, to: .current), romanization: $0.romanization, input: $0.input, lexiconText: $0.lexiconText) })
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
        private lazy var pinyinProvider: PinyinProvider? = nil
        private lazy var shapeData: ShapeData? = nil
        private lazy var simplifier: Simplifier? = nil

        override func activateServer(_ sender: Any!) {
                if engine == nil {
                        engine = Engine()
                }
                currentClient = sender as? IMKTextInput
        }
        override func deactivateServer(_ sender: Any!) {
                engine?.close()
                engine = nil
                pinyinProvider?.close()
                pinyinProvider = nil
                shapeData?.close()
                shapeData = nil
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

        override func recognizedEvents(_ sender: Any!) -> Int {
                let masks: NSEvent.EventTypeMask = [.keyDown, .flagsChanged]
                return Int(masks.rawValue)
        }

        override func handle(_ event: NSEvent!, client sender: Any!) -> Bool {

                // Ignore any Command + ...
                guard !(event.modifierFlags.contains(.command)) else {
                        if isBufferState {
                                bufferText = .empty
                        }
                        return false
                }
                guard let client: IMKTextInput = sender as? IMKTextInput else { return false }

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
                                if number > 0 && number < 6 {
                                        handleSettings(number - 1)
                                }
                                return true
                        }
                        if isBufferState {
                                selectDisplayingItem(index: number - 1, client: client)
                        } else {
                                guard event.modifierFlags == .shift else { return false }
                                switch number {
                                case 1:
                                        insert("！")
                                        return true
                                case 9:
                                        insert("（")
                                        return true
                                case 0:
                                        insert("）")
                                        return true
                                default:
                                        return false
                                }
                        }
                case .instant(let text):
                        if isBufferState {
                                selectDisplayingItem(index: displayObject.highlightedIndex, client: client)
                        }
                        insert(text)
                        bufferText = .empty
                case .transparent:
                        if isBufferState {
                                insert(bufferText)
                                bufferText = .empty
                        }
                        return false
                case .alphabet:
                        guard let letter: String = event.characters else { return false }
                        bufferText += letter
                default:
                        switch event.keyCode {
                        case KeyCode.Symbol.VK_QUOTE:
                                guard isBufferState else { return false }
                                bufferText += "'"
                        case KeyCode.Symbol.VK_SLASH where event.modifierFlags == .shift:
                                if isBufferState {
                                        selectDisplayingItem(index: displayObject.highlightedIndex, client: client)
                                }
                                insert("？")
                                bufferText = .empty
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
                                guard isBufferState else {
                                        insert("\n")
                                        return true
                                }
                                insert(bufferText)
                                bufferText = .empty
                        case KeyCode.Special.VK_BACKWARD_DELETE:
                                guard isBufferState else { return false }
                                bufferText = String(bufferText.dropLast())
                        case KeyCode.Special.VK_ESCAPE, KeyCode.Keypad.VK_KEYPAD_CLEAR:
                                guard !(inputMethodMode.isSettings) else {
                                        handleSettings(0)
                                        return true
                                }
                                guard isBufferState else { return false }
                                bufferText = .empty
                        case KeyCode.Alphabet.VK_U where event.modifierFlags == .control:
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
                showCandidatesWindow(origin: client.position)
                return true
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
                                return Logogram.current
                        case 1:
                                return .traditional
                        case 2:
                                return .hongkong
                        case 3:
                                return .taiwan
                        case 4:
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
                case .some("r"), .some("v"), .some("x"):
                        if bufferText.count == candidate.input.count + 1 {
                                bufferText = .empty
                        } else {
                                let first: String = String(bufferText.first!)
                                let tail = bufferText.dropFirst(candidate.input.count + 1)
                                bufferText = first + tail
                        }
                default:
                        let bufferTextLength: Int = bufferText.count
                        let candidateInputText: String = {
                                let converted: String = candidate.input.replacingOccurrences(of: "(4|5|6)", with: "xx", options: .regularExpression)
                                return converted
                        }()
                        let inputCount: Int = {
                                let candidateInputCount: Int = candidateInputText.count
                                guard bufferTextLength != 2 else { return candidateInputCount }
                                guard candidateInputText.contains("jyu") else { return candidateInputCount }
                                let suffixCount: Int = max(0, bufferTextLength - candidateInputCount)
                                let leading = bufferText.dropLast(suffixCount)
                                let modifiedLeading = leading.replacingOccurrences(of: "jyu", with: "xxx").replacingOccurrences(of: "yu", with: "jyu")
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
