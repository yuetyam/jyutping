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
                case .backspace, .newLine, .shiftUp, .shiftDown:
                        setupKeyButtonView()
                        setupKeyImageView(constant: 11)
                case .switchInputMethod:
                        setupKeyButtonView()
                        setupKeyImageView()
                case .none:
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
        private var previewMask: UIView = UIView()
        private var previewLabel: UILabel = UILabel()
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesBegan(touches, with: event)
                previewLabel.text = nil
                previewLabel.removeFromSuperview()
                previewMask.removeFromSuperview()
                switch keyboardEvent {
                case .text(_):
                        if traitCollection.userInterfaceIdiom == .phone {
                                let shapeWidth: CGFloat = keyButtonView.frame.width
                                let previewHeight: CGFloat = height + 7
                                
                                let origin: CGPoint = CGPoint(x: keyButtonView.frame.origin.x, y: keyButtonView.frame.origin.y + 5)
                                let end: CGPoint = CGPoint(x: keyButtonView.frame.origin.x + shapeWidth, y: keyButtonView.frame.origin.y + 5)
                                let previewPath: CGPath = previewBezierPath(origin: origin, end: end, height: previewHeight, cornerRadius: 10).cgPath
                                
                                let startRect: CGRect = CGRect(origin: CGPoint(x: origin.x + shapeWidth / 2, y: origin.y), size: CGSize(width: 0, height: 0))
                                shapeLayer.path = previewStartPath(rect: startRect).cgPath
                                shapeLayer.fillColor = buttonColor.cgColor
                                
                                let animation = CABasicAnimation(keyPath: "path")
                                animation.duration = 0.03
                                animation.toValue = previewPath
                                animation.fillMode = .forwards
                                animation.isRemovedOnCompletion = false
                                animation.timingFunction = .init(name: .default)
                                shapeLayer.add(animation, forKey: animation.keyPath)
                                layer.addSublayer(shapeLayer)
                                
                                previewMask = UIView(frame: CGRect(x: origin.x, y: keyButtonView.frame.origin.y, width: shapeWidth, height: 10))
                                previewMask.backgroundColor = buttonColor
                                addSubview(previewMask)
                                
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
                        spaceTouchPoint = touches.first?.location(in: self) ?? .zero
                        performedDraggingOnSpace = false
                        keyButtonView.backgroundColor = self.highlightButtonColor
                case .backspace:
                        keyButtonView.backgroundColor = self.highlightButtonColor
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
                                        viewController.currentInputText = String(viewController.currentInputText.dropFirst(candidate.input?.count ?? 0))
                                        DispatchQueue.global().async {
                                                AudioFeedback.perform(audioFeedback: .modify)
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
                        if traitCollection.userInterfaceIdiom == .phone {
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
                        let location: CGPoint = touches.first?.location(in: self) ?? .zero
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
                               delay: 0.1,
                               animations: { self.keyButtonView.backgroundColor = self.buttonColor }
                )
        }
        
        private func showPreviewText() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) {
                        self.previewLabel.text = self.keyText
                        self.shapeLayer.shadowColor = UIColor.black.cgColor
                        self.shapeLayer.shadowOpacity = 0.5
                        self.shapeLayer.shadowRadius = 2
                        self.shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
                }
        }
        private func removePreview() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.11) {
                        self.previewLabel.text = nil
                        self.previewLabel.removeFromSuperview()
                        self.shapeLayer.removeFromSuperlayer()
                        self.previewMask.removeFromSuperview()
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
}
