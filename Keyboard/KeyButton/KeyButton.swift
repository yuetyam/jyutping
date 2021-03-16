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
                case .backspace, .shift:
                        setupKeyButtonView()
                        setupKeyImageView(constant: 11)
                case .switchInputMethod:
                        setupKeyButtonView()
                        setupKeyImageView()
                case .none, .shadowKey(_), .shadowBackspace:
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

        private lazy var isPhonePortrait: Bool = { traitCollection.userInterfaceIdiom == .phone && traitCollection.verticalSizeClass == .regular }()

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesBegan(touches, with: event)
                viewController.hapticFeedback?.impactOccurred()
                switch keyboardEvent {
                case .key:
                        if isPhonePortrait {
                                displayPreview()
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
                switch keyboardEvent {
                case .backspace, .newLine:
                        changeColorToNormal()
                case .space:
                        spaceTouchPoint = .zero
                        changeColorToNormal()
                case .key:
                        if isPhonePortrait {
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
                        let offset: Int = distance > 0 ? 1 : -1
                        viewController.textDocumentProxy.adjustTextPosition(byCharacterOffset: offset)
                        spaceTouchPoint = location
                        performedDraggingOnSpace = true
                }
                if keyboardEvent == .backspace {
                        guard viewController.keyboardLayout.isJyutpingMode else { return }
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
                case .key:
                        if isPhonePortrait {
                                removePreview()
                        } else {
                                changeColorToNormal()
                        }
                default:
                        break
                }
        }

        var slowBackspaceTimer: Timer?
        var fastBackspaceTimer: Timer?
        private func invalidateBackspaceTimers() {
                slowBackspaceTimer?.invalidate()
                fastBackspaceTimer?.invalidate()
        }
        private(set) lazy var performedDraggingOnSpace: Bool = false
        private lazy var spaceTouchPoint: CGPoint = .zero
        private lazy var backspaceTouchPoint: CGPoint = .zero


        // MARK: - Preview

        private func displayPreview() {
                layer.addSublayer(shapeLayer)
                addSubview(previewLabel)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.008) {
                        self.previewLabel.text = self.keyText
                }
        }
        private func removePreview() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                        self.previewLabel.text = nil
                        self.previewLabel.removeFromSuperview()
                        self.shapeLayer.removeFromSuperlayer()
                }
        }
        private func changeColorToNormal() {
                UIView.animate(withDuration: 0, delay: 0.03) {
                        self.keyButtonView.backgroundColor = self.viewController.isDarkAppearance ? .clear : self.buttonColor
                }
        }
        private lazy var shapeLayer: CAShapeLayer = {
                let layer = CAShapeLayer()
                layer.shadowOpacity = 0.5
                layer.shadowRadius = 1
                layer.shadowOffset = .zero
                layer.shadowColor = UIColor.black.cgColor
                layer.shouldRasterize = true
                layer.rasterizationScale = UIScreen.main.scale
                layer.path = originPath.cgPath
                layer.fillColor = buttonColor.cgColor
                let animation = CABasicAnimation(keyPath: "path")
                animation.duration = 0.005
                animation.toValue = previewPath.cgPath
                animation.fillMode = .forwards
                animation.isRemovedOnCompletion = false
                animation.timingFunction = CAMediaTimingFunction(name: .default)
                layer.add(animation, forKey: animation.keyPath)
                return layer
        }()
        private lazy var previewLabel: UILabel = {
                let keyWidth: CGFloat = keyButtonView.frame.width
                let keyHeight: CGFloat = keyButtonView.frame.height
                let labelHeight: CGFloat = previewPath.bounds.height - keyHeight - 8
                let originPoint: CGPoint = keyButtonView.frame.origin
                let label = UILabel(frame: CGRect(x: originPoint.x - 5, y: originPoint.y - labelHeight - 8, width: keyWidth + 10, height: labelHeight))
                label.textAlignment = .center
                label.font = .systemFont(ofSize: 34)
                label.textColor = buttonTintColor
                return label
        }()
}

private extension KeyButton {
        var originPath: UIBezierPath {
                let keyWidth: CGFloat = keyButtonView.frame.width
                let keyHeight: CGFloat = keyButtonView.frame.height
                let bottomCenter: CGPoint = CGPoint(x: keyButtonView.frame.origin.x + keyWidth / 2, y: keyButtonView.frame.maxY)
                let path: UIBezierPath = startBezierPath(origin: bottomCenter, keyWidth: keyWidth, keyHeight: keyHeight, keyCornerRadius: 5)
                return path
        }
        var previewPath: UIBezierPath {
                let keyWidth: CGFloat = keyButtonView.frame.width
                let keyHeight: CGFloat = keyButtonView.frame.height
                let bottomCenter: CGPoint = CGPoint(x: keyButtonView.frame.origin.x + keyWidth / 2, y: keyButtonView.frame.maxY)
                let path: UIBezierPath = previewBezierPath(origin: bottomCenter, previewCornerRadius: 10, keyWidth: keyWidth, keyHeight: keyHeight, keyCornerRadius: 5)
                return path
        }
}
