import UIKit

final class KeyButton: UIButton {
        
        let keyButtonView: UIView = UIView()
        let keyTextLabel: UILabel = UILabel()
        let keyImageView: UIImageView = UIImageView()
        
        let keyboardEvent: KeyboardEvent
        let viewController: KeyboardViewController
        
        init(keyboardEvent: KeyboardEvent, viewController: KeyboardViewController) {
                self.keyboardEvent = keyboardEvent
                self.viewController = viewController
                
                super.init(frame: .zero)
                backgroundColor = .clearTappable
                
                switch keyboardEvent {
                case .backspace, .shift, .shiftDown:
                        setupKeyButtonView()
                        setupKeyImageView(constant: 11)
                case .switchInputMethod:
                        setupKeyButtonView()
                        setupKeyImageView()
                case .none, .keyALeft, .keyLRight, .keyZLeft, .keyBackspaceLeft:
                        break
                default:
                        setupKeyButtonView()
                        setupKeyTextLabel()
                }
                
                setupKeyActions()
        }
        
        deinit {
                invalidateBackspaceTimers()
        }
        
        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
                return CGSize(width: width, height: height)
        }
        
        private let shapeLayer: CAShapeLayer = CAShapeLayer()
        private var previewLabel: UILabel = UILabel()
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesBegan(touches, with: event)
                switch keyboardEvent {
                case .text(_):
                        if traitCollection.userInterfaceIdiom == .phone && UIScreen.main.bounds.height > UIScreen.main.bounds.width {
                                self.previewLabel.text = nil
                                self.previewLabel.removeFromSuperview()
                                
                                let shapeWidth: CGFloat = keyButtonView.frame.width
                                let previewHeight: CGFloat = height + 7
                                
                                let origin: CGPoint = CGPoint(x: keyButtonView.frame.origin.x, y: keyButtonView.frame.origin.y + 5)
                                let end: CGPoint = CGPoint(x: keyButtonView.frame.origin.x + shapeWidth, y: keyButtonView.frame.origin.y + 5)
                                let previewPath: CGPath = previewBezierPath(origin: origin, end: end, height: previewHeight, cornerRadius: 10).cgPath
                                
                                let startRect: CGRect = CGRect(origin: CGPoint(x: origin.x + shapeWidth / 2, y: origin.y), size: CGSize(width: 0, height: 0))
                                shapeLayer.path = previewStartPath(rect: startRect).cgPath
                                shapeLayer.fillColor = buttonColor.cgColor
                                
                                let animation = CABasicAnimation(keyPath: "path")
                                animation.duration = 0.01
                                animation.toValue = previewPath
                                animation.fillMode = .forwards
                                animation.isRemovedOnCompletion = false
                                animation.timingFunction = .init(name: .default)
                                shapeLayer.add(animation, forKey: animation.keyPath)
                                layer.addSublayer(shapeLayer)
                                
                                previewLabel = UILabel(frame: CGRect(x: origin.x, y: keyButtonView.frame.origin.y - previewHeight, width: shapeWidth, height: previewHeight))
                                previewLabel.textAlignment = .center
                                previewLabel.adjustsFontForContentSizeCategory = true
                                previewLabel.font = .preferredFont(forTextStyle: .largeTitle)
                                previewLabel.textColor = buttonTintColor
                                addSubview(previewLabel)
                                
                                showPreviewText()
                        } else {
                                keyButtonView.backgroundColor = self.highlightButtonColor
                        }
                case .space:
                        keyButtonView.backgroundColor = self.highlightButtonColor
                        spaceTouchPoint = touches.first?.location(in: self) ?? .zero
                        performedDraggingOnSpace = false
                case .backspace:
                        keyButtonView.backgroundColor = self.highlightButtonColor
                        backspaceTouchPoint = touches.first?.location(in: self) ?? .zero
                default:
                        break
                }
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesEnded(touches, with: event)
                
                invalidateBackspaceTimers()
                
                if keyboardEvent == .space {
                        if !performedDraggingOnSpace {
                                if viewController.keyboardLayout == .jyutping && !viewController.candidates.isEmpty {
                                        let candidate: Candidate = viewController.candidates[0]
                                        viewController.textDocumentProxy.insertText(candidate.text)
                                        viewController.currentInputText = String(viewController.currentInputText.dropFirst(candidate.input.count))
                                        DispatchQueue.global().async {
                                                AudioFeedback.perform(audioFeedback: .modify)
                                        }
                                        viewController.combinedPhrase.append(candidate)
                                        if viewController.currentInputText.isEmpty {
                                                var combinedCandidate: Candidate = viewController.combinedPhrase[0]
                                                _ = viewController.combinedPhrase.dropFirst().map { oneCandidate in
                                                        combinedCandidate += oneCandidate
                                                }
                                                viewController.combinedPhrase = []
                                                viewController.candidateQueue.async {
                                                        let id: Int64 = Int64((combinedCandidate.input + combinedCandidate.text + combinedCandidate.footnote).hash)
                                                        if let existPhrase: Phrase = self.viewController.userPhraseManager.fetch(by: id) {
                                                                self.viewController.userPhraseManager.update(id: existPhrase.id, frequency: existPhrase.frequency + 1)
                                                        } else {
                                                                let newPhrase: Phrase = Phrase(id: id, token: Int64(combinedCandidate.input.hash), shortcut: combinedCandidate.footnote.shortcut, frequency: 1, word: combinedCandidate.text, jyutping: combinedCandidate.footnote)
                                                                self.viewController.userPhraseManager.insert(phrase: newPhrase)
                                                        }
                                                }
                                        }
                                } else if viewController.keyboardLayout == .jyutping && !viewController.currentInputText.isEmpty {
                                        viewController.textDocumentProxy.insertText(viewController.currentInputText)
                                        viewController.currentInputText = ""
                                        DispatchQueue.global().async {
                                                AudioFeedback.perform(audioFeedback: .modify)
                                        }
                                } else {
                                        viewController.textDocumentProxy.insertText(" ")
                                        DispatchQueue.global().async {
                                                AudioFeedback.play(for: .space)
                                        }
                                }
                        }
                        spaceTouchPoint = .zero
                        changeColorToNormal()
                }
                switch keyboardEvent {
                case .backspace:
                        changeColorToNormal()
                case .text(_):
                        if traitCollection.userInterfaceIdiom == .phone && UIScreen.main.bounds.height > UIScreen.main.bounds.width {
                                removePreview()
                        } else {
                                changeColorToNormal()
                        }
                default:
                        break
                }
        }
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesMoved(touches, with: event)
                if keyboardEvent == .space {
                        guard let location: CGPoint = touches.first?.location(in: self) else { return }
                        let distance: CGFloat = location.x - spaceTouchPoint.x
                        guard abs(distance) > 8 else { return }
                        if distance > 0 {
                                viewController.textDocumentProxy.adjustTextPosition(byCharacterOffset: 1)
                        } else {
                                viewController.textDocumentProxy.adjustTextPosition(byCharacterOffset: -1)
                        }
                        spaceTouchPoint = location
                        performedDraggingOnSpace = true
                }
                if keyboardEvent == .backspace {
                        guard viewController.keyboardLayout == .jyutping else { return }
                        guard let location: CGPoint = touches.first?.location(in: self) else { return }
                        let distance: CGFloat = location.x - backspaceTouchPoint.x
                        guard distance < -44 else { return }
                        viewController.currentInputText = ""
                }
        }
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesCancelled(touches, with: event)
                
                invalidateBackspaceTimers()
                
                switch keyboardEvent {
                case .backspace:
                        changeColorToNormal()
                case .space:
                        spaceTouchPoint = .zero
                        changeColorToNormal()
                case .text(_):
                        if traitCollection.userInterfaceIdiom == .phone {
                                removePreview()
                        } else {
                                changeColorToNormal()
                        }
                default:
                        break
                }
        }
        
        private func changeColorToNormal() {
                UIView.animate(withDuration: 0,
                               delay: 0.05,
                               animations: { self.keyButtonView.backgroundColor = self.buttonColor }
                )
        }
        
        private func showPreviewText() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self.previewLabel.text = self.keyText
                        self.shapeLayer.shadowOpacity = 0.2
                        self.shapeLayer.shadowRadius = 2
                        self.shapeLayer.shadowColor = UIColor.black.cgColor
                }
        }
        private func removePreview() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.04) {
                        self.previewLabel.text = nil
                        self.previewLabel.removeFromSuperview()
                        self.shapeLayer.removeFromSuperlayer()
                }
        }
        
        var slowBackspaceTimer: Timer?
        var fastBackspaceTimer: Timer?
        private func invalidateBackspaceTimers() {
                slowBackspaceTimer?.invalidate()
                fastBackspaceTimer?.invalidate()
        }
        
        private var performedDraggingOnSpace: Bool = false
        private var spaceTouchPoint: CGPoint = .zero
        private var backspaceTouchPoint: CGPoint = .zero
}
