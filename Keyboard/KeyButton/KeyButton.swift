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
        
        private var shapeLayer: CAShapeLayer = {
                let caLayer: CAShapeLayer = CAShapeLayer()
                caLayer.shadowOpacity = 0.7
                caLayer.shadowRadius = 1
                caLayer.shadowOffset = .zero
                caLayer.shadowColor = UIColor.black.cgColor
                return caLayer
        }()
        private var previewLabel: UILabel = UILabel()
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesBegan(touches, with: event)
                switch keyboardEvent {
                case .text(_):
                        if viewController.traitCollection.userInterfaceIdiom == .phone && viewController.traitCollection.horizontalSizeClass == .compact {
                                self.previewLabel.text = nil
                                self.previewLabel.removeFromSuperview()
                                
                                let keyWidth: CGFloat = keyButtonView.frame.width
                                let keyHeight: CGFloat = keyButtonView.frame.height
                                let bottomCenter: CGPoint = CGPoint(x: keyButtonView.frame.origin.x + keyWidth / 2, y: keyButtonView.frame.maxY)
                                let startPath: UIBezierPath = startBezierPath(origin: bottomCenter, keyWidth: keyWidth, keyHeight: keyHeight, keyCornerRadius: 5)
                                let previewPath: UIBezierPath = previewBezierPath(origin: bottomCenter, previewCornerRadius: 10, keyWidth: keyWidth, keyHeight: keyHeight, keyCornerRadius: 5)
                                shapeLayer.path = startPath.cgPath
                                shapeLayer.fillColor = buttonColor.cgColor
                                
                                let animation = CABasicAnimation(keyPath: "path")
                                animation.duration = 0.01
                                animation.toValue = previewPath.cgPath
                                animation.fillMode = .forwards
                                animation.isRemovedOnCompletion = false
                                animation.timingFunction = CAMediaTimingFunction(name: .default)
                                shapeLayer.add(animation, forKey: animation.keyPath)
                                layer.addSublayer(shapeLayer)
                                
                                let labelHeight: CGFloat = previewPath.bounds.height - keyHeight - 8
                                previewLabel = UILabel(frame: CGRect(x: keyButtonView.frame.origin.x - 5, y: keyButtonView.frame.origin.y - labelHeight - 8, width: keyWidth + 10, height: labelHeight))
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
                                        AudioFeedback.perform(audioFeedback: .modify)
                                        viewController.candidateSequence.append(candidate)
                                        viewController.currentInputText = String(viewController.currentInputText.dropFirst(candidate.input.count))
                                        if viewController.currentInputText.isEmpty {
                                                var combinedCandidate: Candidate = viewController.candidateSequence[0]
                                                _ = viewController.candidateSequence.dropFirst().map { oneCandidate in
                                                        combinedCandidate += oneCandidate
                                                }
                                                viewController.candidateSequence = []
                                                viewController.imeQueue.async {
                                                        self.viewController.lexiconManager.handle(candidate: combinedCandidate)
                                                }
                                        }
                                } else if viewController.keyboardLayout == .jyutping && !viewController.currentInputText.isEmpty {
                                        viewController.textDocumentProxy.insertText(viewController.currentInputText)
                                        viewController.currentInputText = ""
                                        AudioFeedback.perform(audioFeedback: .modify)
                                } else {
                                        viewController.textDocumentProxy.insertText(" ")
                                        AudioFeedback.play(for: .space)
                                }
                        }
                        spaceTouchPoint = .zero
                        changeColorToNormal()
                }
                switch keyboardEvent {
                case .backspace:
                        changeColorToNormal()
                case .text(_):
                        if viewController.traitCollection.userInterfaceIdiom == .phone && viewController.traitCollection.horizontalSizeClass == .compact {
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
                        if viewController.traitCollection.userInterfaceIdiom == .phone && viewController.traitCollection.horizontalSizeClass == .compact {
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
                               delay: 0.03,
                               animations: { self.keyButtonView.backgroundColor = self.buttonColor }
                )
        }
        
        private func showPreviewText() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        self.previewLabel.text = self.keyText
                }
        }
        private func removePreview() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
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
