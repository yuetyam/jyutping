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
                backgroundColor = .interactableClear
                
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
        
        private lazy var shapeLayer: CAShapeLayer = {
                let caLayer: CAShapeLayer = CAShapeLayer()
                caLayer.shadowOpacity = 0.5
                caLayer.shadowRadius = 1
                caLayer.shadowOffset = .zero
                caLayer.shadowColor = UIColor.black.cgColor
                caLayer.shouldRasterize = true
                caLayer.rasterizationScale = UIScreen.main.scale
                return caLayer
        }()
        private lazy var previewLabel: UILabel = UILabel()
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesBegan(touches, with: event)
                viewController.hapticFeedback?.impactOccurred()
                switch keyboardEvent {
                case .text(_):
                        if viewController.traitCollection.userInterfaceIdiom == .phone && viewController.traitCollection.verticalSizeClass == .regular {
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
                                keyButtonView.backgroundColor = highlightButtonColor
                        }
                case .space:
                        keyButtonView.backgroundColor = highlightButtonColor
                        spaceTouchPoint = touches.first?.location(in: self) ?? .zero
                        performedDraggingOnSpace = false
                case .backspace:
                        keyButtonView.backgroundColor = highlightButtonColor
                        backspaceTouchPoint = touches.first?.location(in: self) ?? .zero
                case .newLine:
                        keyButtonView.backgroundColor = highlightButtonColor
                default:
                        break
                }
        }
        
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesEnded(touches, with: event)
                
                invalidateBackspaceTimers()
                
                if keyboardEvent == .space {
                        guard !performedDraggingOnSpace else {
                                spaceTouchPoint = .zero
                                changeColorToNormal()
                                return
                        }
                        switch viewController.keyboardLayout {
                        case .jyutping, .jyutpingUppercase:
                                if let firstCandidate: Candidate = viewController.candidates.first {
                                        viewController.textDocumentProxy.insertText(firstCandidate.text)
                                        AudioFeedback.perform(audioFeedback: .modify)
                                        if viewController.currentInputText.hasPrefix("r") {
                                                if viewController.currentInputText == "r" + firstCandidate.input {
                                                        viewController.currentInputText = ""
                                                } else {
                                                        viewController.currentInputText = "r" + viewController.currentInputText.dropFirst(firstCandidate.input.count + 1)
                                                }
                                        } else if viewController.currentInputText.hasPrefix("v") {
                                                if viewController.currentInputText == "v" + firstCandidate.input {
                                                        viewController.currentInputText = ""
                                                } else {
                                                        viewController.currentInputText = "v" + viewController.currentInputText.dropFirst(firstCandidate.input.count + 1)
                                                }
                                        } else {
                                                viewController.candidateSequence.append(firstCandidate)
                                                viewController.currentInputText = String(viewController.currentInputText.dropFirst(firstCandidate.input.count))
                                        }
                                        if viewController.currentInputText.isEmpty && !(viewController.candidateSequence.isEmpty) {
                                                let concatenatedCandidate: Candidate = viewController.candidateSequence.joined()
                                                viewController.candidateSequence = []
                                                viewController.imeQueue.async {
                                                        self.viewController.lexiconManager?.handle(candidate: concatenatedCandidate)
                                                }
                                        }
                                } else if !(viewController.currentInputText.isEmpty) {
                                        viewController.textDocumentProxy.insertText(viewController.currentInputText)
                                        AudioFeedback.perform(audioFeedback: .modify)
                                        viewController.currentInputText = ""
                                } else {
                                        viewController.textDocumentProxy.insertText(" ")
                                        AudioFeedback.play(for: .space)
                                }
                                if viewController.keyboardLayout == .jyutpingUppercase && !viewController.isCapsLocked {
                                        viewController.keyboardLayout = .jyutping
                                }
                        case .alphabeticUppercase:
                                viewController.textDocumentProxy.insertText(" ")
                                AudioFeedback.play(for: .space)
                                if !viewController.isCapsLocked {
                                        viewController.keyboardLayout = .alphabetic
                                }
                        default:
                                viewController.textDocumentProxy.insertText(" ")
                                AudioFeedback.play(for: .space)
                        }
                        spaceTouchPoint = .zero
                        changeColorToNormal()
                }
                switch keyboardEvent {
                case .backspace, .newLine:
                        changeColorToNormal()
                case .text(_):
                        if viewController.traitCollection.userInterfaceIdiom == .phone && viewController.traitCollection.verticalSizeClass == .regular {
                                removePreview()
                        } else {
                                changeColorToNormal()
                        }
                default:
                        break
                }
                viewController.hapticFeedback?.prepare()
        }
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesMoved(touches, with: event)
                if keyboardEvent == .space {
                        guard let location: CGPoint = touches.first?.location(in: self) else { return }
                        let distance: CGFloat = location.x - spaceTouchPoint.x
                        guard abs(distance) > 8 else { return }
                        viewController.currentInputText = ""
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
                case .backspace, .newLine:
                        changeColorToNormal()
                case .space:
                        spaceTouchPoint = .zero
                        changeColorToNormal()
                case .text(_):
                        if viewController.traitCollection.userInterfaceIdiom == .phone && viewController.traitCollection.verticalSizeClass == .regular {
                                removePreview()
                        } else {
                                changeColorToNormal()
                        }
                default:
                        break
                }
        }
        
        private func changeColorToNormal() {
                UIView.animate(
                        withDuration: 0,
                        delay: 0.03,
                        animations: {
                                self.keyButtonView.backgroundColor = self.viewController.isDarkAppearance ? .clear : self.buttonColor
                        }
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
        
        private lazy var performedDraggingOnSpace: Bool = false
        private lazy var spaceTouchPoint: CGPoint = .zero
        private lazy var backspaceTouchPoint: CGPoint = .zero
}
