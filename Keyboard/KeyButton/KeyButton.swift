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
                case .none, .shadowKey, .shadowBackspace:
                        break
                default:
                        setupKeyButtonView()
                        setupKeyTextLabel()
                }
                setupKeyActions()
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
                        viewController.inputText = ""
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
                        viewController.inputText = ""
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
        deinit {
                invalidateBackspaceTimers()
        }
        private(set) lazy var performedDraggingOnSpace: Bool = false
        private lazy var spaceTouchPoint: CGPoint = .zero
        private lazy var backspaceTouchPoint: CGPoint = .zero


        // MARK: - Preview

        private func displayPreview() {
                layer.addSublayer(previewShapeLayer)
                addSubview(previewLabel)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.008) {
                        self.previewLabel.text = self.keyText
                }
        }
        private func removePreview() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                        self.previewLabel.text = nil
                        self.previewLabel.removeFromSuperview()
                        self.previewShapeLayer.removeFromSuperlayer()
                }
        }
        private func changeColorToNormal() {
                UIView.animate(withDuration: 0, delay: 0.03) {
                        self.keyButtonView.backgroundColor = self.viewController.isDarkAppearance ? .clear : self.buttonColor
                }
        }
        private lazy var previewShapeLayer: CAShapeLayer = {
                let layer = CAShapeLayer()
                layer.shadowOpacity = 0.5
                layer.shadowRadius = 1
                layer.shadowOffset = .zero
                layer.shadowColor = UIColor.black.cgColor
                layer.shouldRasterize = true
                layer.rasterizationScale = UIScreen.main.scale
                let keyShapePath: UIBezierPath = keyShapeBezierPath(origin: bottomCenter, keyWidth: keyWidth, keyHeight: keyHeight, keyCornerRadius: 5)
                layer.path = keyShapePath.cgPath
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
                let preview = previewPath.bounds
                let height: CGFloat = preview.height - keyHeight - 8
                let frame = CGRect(origin: preview.origin, size: CGSize(width: preview.width, height: height))
                let label = UILabel(frame: frame)
                label.textAlignment = .center
                label.font = .systemFont(ofSize: 34)
                label.textColor = buttonTintColor
                return label
        }()
        private lazy var previewPath: UIBezierPath = previewBezierPath(origin: bottomCenter, previewCornerRadius: 10, keyWidth: keyWidth, keyHeight: keyHeight, keyCornerRadius: 5)
        private lazy var keyWidth: CGFloat = keyButtonView.frame.width
        private lazy var keyHeight: CGFloat = keyButtonView.frame.height
        private lazy var bottomCenter: CGPoint = CGPoint(x: keyButtonView.frame.origin.x + keyWidth / 2, y: keyButtonView.frame.maxY)
}

final class CalloutKeyView: UIView {

        let text: String
        private let header: String?
        private let footer: String?
        private let alignments: (header: Alignment, footer: Alignment)
        private let isDarkAppearance: Bool

        init(frame: CGRect,
             text: String,
             header: String? = nil,
             footer: String? = nil,
             alignments: (header: Alignment, footer: Alignment) = (header: .center, footer: .center), isDarkAppearance: Bool) {
                self.text = text
                self.header = header
                self.footer = footer
                self.alignments = alignments
                self.isDarkAppearance = isDarkAppearance
                super.init(frame: frame)
                layer.cornerRadius = 5
                layer.cornerCurve = .continuous
                setupHeader()
                setupFooter()
                setupText()
        }
        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }

        override var intrinsicContentSize: CGSize { return CGSize(width: 40, height: 40) }

        private func setupHeader() {
                let headerLabel: UILabel = UILabel()
                addSubview(headerLabel)
                headerLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        headerLabel.topAnchor.constraint(equalTo: topAnchor),
                        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                        headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
                headerLabel.font = .systemFont(ofSize: 11)
                headerLabel.text = header
                headerLabel.textColor = isDarkAppearance ? UIColor.white.withAlphaComponent(0.8) : .gray
                switch alignments.header {
                case .center:
                        headerLabel.textAlignment = .center
                case .left:
                        headerLabel.textAlignment = .left
                case .right:
                        headerLabel.textAlignment = .right
                }
        }
        private func setupFooter() {
                let footerLabel: UILabel = UILabel()
                addSubview(footerLabel)
                footerLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        footerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                        footerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                        footerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
                footerLabel.font = .systemFont(ofSize: 9)
                footerLabel.text = footer
                footerLabel.textColor = isDarkAppearance ? UIColor.white.withAlphaComponent(0.7) : .gray
                switch alignments.footer {
                case .center:
                        footerLabel.textAlignment = .center
                case .left:
                        footerLabel.textAlignment = .left
                case .right:
                        footerLabel.textAlignment = .right
                }
        }
        private func setupText() {
                let textLabel: UILabel = UILabel()
                addSubview(textLabel)
                textLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
                textLabel.font = .systemFont(ofSize: 17)
                textLabel.text = text
                textLabel.textAlignment = .center
        }
}
