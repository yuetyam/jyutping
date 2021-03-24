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
                textToInput = nil
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
                invalidateTimers()
                switch keyboardEvent {
                case .backspace, .newLine:
                        changeColorToNormal()
                case .space:
                        spaceTouchPoint = .zero
                        changeColorToNormal()
                case .key(let seat):
                        if isPhonePortrait {
                                removePreview()
                                removeCallout()
                        } else {
                                changeColorToNormal()
                        }
                        if seat == .cantoneseCommaSeat {
                                if let text: String = textToInput {
                                        if text == "'" {
                                                viewController.inputText += text
                                        } else if viewController.inputText.isEmpty {
                                                viewController.textDocumentProxy.insertText(text)
                                        } else {
                                                let combined: String = viewController.processingText + text
                                                viewController.inputText = ""
                                                viewController.textDocumentProxy.insertText(combined)
                                        }
                                        AudioFeedback.perform(.input)
                                        viewController.hapticFeedback?.impactOccurred()
                                }
                        }
                default:
                        break
                }
                viewController.hapticFeedback?.prepare()
        }
        private(set) lazy var textToInput: String? = nil
        private lazy var distances: [CGFloat] = {
                let max: CGFloat = calloutStackView.bounds.width
                var blocks: [CGFloat] = []
                let count: Int = calloutKeys.count
                let step: CGFloat = max / CGFloat(count)
                for number in 0..<count {
                        let length: CGFloat = step * CGFloat(number)
                        blocks.append(length)
                }
                blocks.append(max)
                return blocks
        }()
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesMoved(touches, with: event)
                switch keyboardEvent {
                case .key(.cantoneseCommaSeat):
                        guard let location: CGPoint = touches.first?.location(in: viewController.view) else { return }
                        let distance: CGFloat = location.x - self.frame.midX
                        for index in 0..<(distances.count - 1) {
                                let rightCondition: Bool = (distances[index] < distance) && (distance < distances[index + 1])
                                let leftCondition: Bool = (distances[index] < -distance) && (-distance < distances[index + 1])
                                let condition: Bool = isRightBubble ? rightCondition : leftCondition
                                if condition {
                                        let this: Int = isRightBubble ? index : (calloutKeys.count - 1 - index)
                                        _ = calloutKeys.map({ $0.backgroundColor = buttonColor })
                                        calloutKeys[this].backgroundColor = selectionColor
                                        textToInput = calloutKeys[this].text
                                }
                        }
                case .space:
                        guard let location: CGPoint = touches.first?.location(in: self) else { return }
                        let distance: CGFloat = location.x - spaceTouchPoint.x
                        guard abs(distance) > 10 else { return }

                        // FIXME: Dragging in input text
                        viewController.inputText = ""

                        let offset: Int = distance > 0 ? 1 : -1
                        viewController.textDocumentProxy.adjustTextPosition(byCharacterOffset: offset)
                        spaceTouchPoint = location
                        performedDraggingOnSpace = true
                case .backspace:
                        guard viewController.keyboardLayout.isJyutpingMode else { return }
                        guard let location: CGPoint = touches.first?.location(in: self) else { return }
                        let distance: CGFloat = location.x - backspaceTouchPoint.x
                        guard distance < -44 else { return }
                        viewController.inputText = ""
                default:
                        break
                }
        }
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesCancelled(touches, with: event)
                invalidateTimers()
                switch keyboardEvent {
                case .backspace, .newLine:
                        changeColorToNormal()
                case .space:
                        spaceTouchPoint = .zero
                        changeColorToNormal()
                case .key:
                        if isPhonePortrait {
                                removePreview()
                                removeCallout()
                        } else {
                                changeColorToNormal()
                        }
                default:
                        break
                }
        }

        var slowBackspaceTimer: Timer?
        var fastBackspaceTimer: Timer?
        var longPressTimer: Timer?
        private func invalidateTimers() {
                slowBackspaceTimer?.invalidate()
                fastBackspaceTimer?.invalidate()
                longPressTimer?.invalidate()
        }
        deinit {
                invalidateTimers()
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
        private lazy var bottomCenter: CGPoint = CGPoint(x: keyButtonView.frame.midX, y: keyButtonView.frame.maxY)


        // MARK: - Callout

        private lazy var selectionColor: UIColor =  UIColor(red: 52.0 / 255, green: 120.0 / 255, blue: 246.0 / 255, alpha: 1)
        private lazy var calloutKeys: [CalloutView] = {
                switch keyboardEvent {
                case .key(let seat):
                        let primaryKey = CalloutView(text: seat.primary.text, header: seat.primary.header, footer: seat.primary.footer, alignments: seat.primary.alignments)
                        primaryKey.backgroundColor = selectionColor
                        var keys: [CalloutView] = [primaryKey]
                        for index in 0..<seat.children.count {
                                let element: KeyElement = seat.children[index]
                                let callout = CalloutView(text: element.text, header: element.header, footer: element.footer, alignments: element.alignments)
                                keys.append(callout)
                        }
                        return isRightBubble ? keys : keys.reversed()
                default:
                        return []
                }
        }()
        func displayCallout() {
                guard isPhonePortrait else { return }
                layer.addSublayer(calloutLayer)
                addSubview(calloutStackView)
        }
        func removeCallout() {
                _ = calloutKeys.map({ $0.backgroundColor = buttonColor })
                calloutStackView.removeFromSuperview()
                calloutLayer.removeFromSuperlayer()
        }
        private lazy var calloutStackView: UIStackView = {
                let expansion = isRightBubble ? (keyButtonView.bounds.minX - bubblePath.bounds.minX) : (bubblePath.bounds.maxX - keyButtonView.bounds.maxX - 5)
                let width = bubblePath.bounds.width - (expansion * 2)
                let origin = CGPoint(x: bubblePath.bounds.minX + expansion, y: bubblePath.bounds.minY + 2)
                let size = CGSize(width: width, height: keyHeight)
                let stackView: UIStackView = UIStackView(frame: CGRect(origin: origin, size: size))
                stackView.distribution = .fillEqually
                stackView.addMultipleArrangedSubviews(calloutKeys)
                return stackView
        }()
        private lazy var calloutLayer: CAShapeLayer = {
                let layer = CAShapeLayer()
                layer.shadowOpacity = 0.5
                layer.shadowRadius = 1
                layer.shadowOffset = .zero
                layer.shadowColor = UIColor.black.cgColor
                layer.shouldRasterize = true
                layer.rasterizationScale = UIScreen.main.scale
                layer.path = previewPath.cgPath
                layer.fillColor = buttonColor.cgColor
                let animation = CABasicAnimation(keyPath: "path")
                animation.duration = 0.01
                animation.toValue = bubblePath.cgPath
                animation.fillMode = .forwards
                animation.isRemovedOnCompletion = false
                animation.timingFunction = CAMediaTimingFunction(name: .default)
                layer.add(animation, forKey: animation.keyPath)
                return layer
        }()
        private lazy var isRightBubble: Bool = frame.midX < viewController.view.frame.midX
        private lazy var bubblePath: UIBezierPath = {
                if isRightBubble {
                        return rightBubblePath(origin: bottomCenter,
                                               previewCornerRadius: 10,
                                               keyWidth: keyWidth,
                                               keyHeight: keyHeight,
                                               keyCornerRadius: 5,
                                               count: calloutKeys.count - 1)
                } else {
                        return leftBubblePath(origin: bottomCenter,
                                              previewCornerRadius: 10,
                                              keyWidth: keyWidth,
                                              keyHeight: keyHeight,
                                              keyCornerRadius: 5,
                                              count: calloutKeys.count - 1)
                }
        }()
}

final class CalloutView: UIView {

        let text: String
        private let header: String?
        private let footer: String?
        private let alignments: (header: Alignment, footer: Alignment)

        init(text: String,
             header: String? = nil,
             footer: String? = nil,
             alignments: (header: Alignment, footer: Alignment) = (header: .center, footer: .center)) {
                self.text = text
                self.header = header
                self.footer = footer
                self.alignments = alignments
                super.init(frame: .zero)
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
                textLabel.textAlignment = .center
                textLabel.text = text
        }
}
