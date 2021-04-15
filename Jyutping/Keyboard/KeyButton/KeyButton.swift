import UIKit

final class KeyButton: UIButton {

        let shape: UIView = UIView()
        let event: KeyboardEvent
        let controller: KeyboardViewController
        let isDarkAppearance: Bool
        let isPhonePortrait: Bool
        let isPhoneInterface: Bool
        let isPadLandscape: Bool

        init(event: KeyboardEvent, controller: KeyboardViewController) {
                self.event = event
                self.controller = controller
                isDarkAppearance = controller.isDarkAppearance
                isPhonePortrait = controller.isPhonePortrait
                isPhoneInterface = controller.isPhoneInterface
                isPadLandscape = controller.isPadLandscape
                super.init(frame: .zero)
                backgroundColor = .interactiveClear
                switch event {
                case .none, .shadowKey, .shadowBackspace:
                        break
                case .backspace, .shift:
                        setupKeyShapeView()
                        setupKeyImageView(constant: 11)
                case .switchInputMethod:
                        setupKeyShapeView()
                        setupKeyImageView()
                case .key(let seat) where seat.primary.header != nil:
                        setupKeyShapeView()
                        setupKeyTextLabel()
                        setupKeyHeaderLabel(text: seat.primary.header)
                default:
                        setupKeyShapeView()
                        setupKeyTextLabel()
                }
                setupKeyActions()
        }
        required init?(coder: NSCoder) { fatalError("KeyView.init(coder:) error") }
        override var intrinsicContentSize: CGSize { CGSize(width: width, height: height) }

        deinit {
                backspaceTimer?.invalidate()
        }
        private(set) lazy var isInteracting: Bool = false {
                didSet {
                        if !isInteracting {
                                backspaceTimer?.invalidate()
                        }
                }
        }
        private(set) lazy var peekingText: String? = nil

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesBegan(touches, with: event)
                controller.hapticFeedback?.impactOccurred()
                isInteracting = true
                peekingText = nil
                switch self.event {
                case .key(let seat):
                        if isPhonePortrait {
                                displayPreview()
                        } else {
                                shape.backgroundColor = highlightingBackColor
                        }
                        if !seat.children.isEmpty { handleLongPress() }
                case .backspace:
                        shape.backgroundColor = highlightingBackColor
                        backspaceTouchPoint = touches.first?.location(in: self) ?? .zero
                        handleBackspace()
                case .shadowBackspace:
                        handleBackspace()
                case .space:
                        shape.backgroundColor = highlightingBackColor
                        spaceTouchPoint = touches.first?.location(in: self) ?? .zero
                        draggedOnSpace = false
                case .newLine:
                        shape.backgroundColor = highlightingBackColor
                default:
                        break
                }
        }

        private lazy var distances: [CGFloat] = {
                let max: CGFloat = calloutStackView.bounds.width
                var blocks: [CGFloat] = []
                let count: Int = calloutKeys.count + 1
                let step: CGFloat = max / CGFloat(count)
                for number in 0..<count {
                        let length: CGFloat = step * CGFloat(number)
                        blocks.append(length)
                }
                return blocks
        }()
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesMoved(touches, with: event)
                switch self.event {
                case .key(let seat) where !seat.children.isEmpty:
                        guard isCalloutDisplaying else { break }
                        guard let location: CGPoint = touches.first?.location(in: controller.view) else { break }
                        let distance: CGFloat = location.x - self.frame.midX
                        for index in 0..<(distances.count - 1) {
                                let rightCondition: Bool = (distances[index] < distance) && (distance < distances[index + 1])
                                let leftCondition: Bool = (distances[index] < -distance) && (-distance < distances[index + 1])
                                let condition: Bool = greaterMidX ? leftCondition : rightCondition
                                if condition {
                                        let this: Int = greaterMidX ? (calloutKeys.count - 1 - index): index
                                        _ = calloutKeys.map({ $0.backgroundColor = backColor })
                                        calloutKeys[this].backgroundColor = selectionColor
                                        peekingText = calloutKeys[this].text
                                }
                        }
                case .space:
                        guard let location: CGPoint = touches.first?.location(in: self) else { break }
                        let distance: CGFloat = location.x - spaceTouchPoint.x
                        guard abs(distance) > 10 else { break }
                        controller.inputText = "" // FIXME: Dragging in input text
                        let offset: Int = distance > 0 ? 1 : -1
                        controller.textDocumentProxy.adjustTextPosition(byCharacterOffset: offset)
                        spaceTouchPoint = location
                        draggedOnSpace = true
                case .backspace:
                        guard controller.keyboardLayout.isCantoneseMode else { break }
                        guard let location: CGPoint = touches.first?.location(in: self) else { break }
                        let distance: CGFloat = location.x - backspaceTouchPoint.x
                        guard distance < -44 else { break }
                        controller.inputText = ""
                default:
                        break
                }
        }
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesEnded(touches, with: event)
                isInteracting = false
                switch self.event {
                case .newLine:
                        changeColorToNormal()
                case .backspace:
                        backspaceTouchPoint = .zero
                        changeColorToNormal()
                case .space:
                        spaceTouchPoint = .zero
                        changeColorToNormal()
                case .key(let seat) where !seat.children.isEmpty:
                        removeCallout()
                        if isPhonePortrait {
                                removePreview()
                        } else {
                                changeColorToNormal()
                        }
                        guard let text: String = peekingText else { break }
                        AudioFeedback.perform(.input)
                        controller.hapticFeedback?.impactOccurred()
                        guard controller.keyboardLayout.isCantoneseMode else {
                                controller.textDocumentProxy.insertText(text)
                                break
                        }
                        let punctuation: String = "，。？！"
                        guard punctuation.contains(text) else {
                                controller.inputText += text
                                break
                        }
                        if controller.inputText.isEmpty {
                                controller.textDocumentProxy.insertText(text)
                        } else {
                                let combined: String = controller.processingText + text
                                controller.inputText = ""
                                controller.textDocumentProxy.insertText(combined)
                        }
                case .key:
                        if isPhonePortrait {
                                removePreview()
                        } else {
                                changeColorToNormal()
                        }
                default:
                        break
                }
                controller.hapticFeedback?.prepare()
        }
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesCancelled(touches, with: event)
                isInteracting = false
                peekingText = nil
                switch self.event {
                case .newLine:
                        changeColorToNormal()
                case .backspace:
                        backspaceTouchPoint = .zero
                        changeColorToNormal()
                case .space:
                        spaceTouchPoint = .zero
                        changeColorToNormal()
                case .key(let seat):
                        if !seat.children.isEmpty { removeCallout() }
                        if isPhonePortrait {
                                removePreview()
                        } else {
                                changeColorToNormal()
                        }
                default:
                        break
                }
        }

        var backspaceTimer: Timer?
        private(set) lazy var backspaceTouchPoint: CGPoint = .zero
        private(set) lazy var spaceTouchPoint: CGPoint = .zero
        private(set) lazy var draggedOnSpace: Bool = false
        private(set) lazy var greaterMidX: Bool = frame.midX > controller.view.frame.midX

        private lazy var keyShapePath: UIBezierPath = keyShapeBezierPath(origin: bottomCenter, keyWidth: shapeWidth, keyHeight: shapeHeight, keyCornerRadius: 5)
        private lazy var previewPath: UIBezierPath = previewBezierPath(origin: bottomCenter, previewCornerRadius: 10, keyWidth: shapeWidth, keyHeight: shapeHeight, keyCornerRadius: 5)
        private lazy var shapeWidth: CGFloat = shape.frame.width
        private lazy var shapeHeight: CGFloat = shape.frame.height
        private lazy var bottomCenter: CGPoint = CGPoint(x: shape.frame.midX, y: shape.frame.maxY)

        private func displayPreview() {
                layer.addSublayer(previewShapeLayer)
                addSubview(previewLabel)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.008) { [weak self] in
                        if self != nil {
                                self!.previewLabel.text = self!.keyText
                        }
                }
        }
        private func removePreview() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) { [weak self] in
                        if self != nil {
                                self!.previewLabel.text = nil
                                self!.previewLabel.removeFromSuperview()
                                self!.previewShapeLayer.removeFromSuperlayer()
                        }
                }
        }
        private func changeColorToNormal() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) { [weak self] in
                        if self != nil {
                                self!.shape.backgroundColor = self!.isDarkAppearance ? .clear : self!.backColor
                        }
                }
        }
        private(set) lazy var previewShapeLayer: CAShapeLayer = {
                let layer = CAShapeLayer()
                layer.shadowOpacity = 0.3
                layer.shadowRadius = 0.5
                layer.shadowOffset = .zero
                layer.shadowColor = UIColor.black.cgColor
                layer.shouldRasterize = true
                layer.rasterizationScale = UIScreen.main.scale
                layer.path = keyShapePath.cgPath
                layer.fillColor = backColor.cgColor
                let animation = CABasicAnimation(keyPath: "path")
                animation.duration = 0.005
                animation.toValue = previewPath.cgPath
                animation.fillMode = .forwards
                animation.isRemovedOnCompletion = false
                animation.timingFunction = CAMediaTimingFunction(name: .default)
                layer.add(animation, forKey: animation.keyPath)
                return layer
        }()
        private(set) lazy var previewLabel: UILabel = {
                let preview = previewPath.bounds
                let height: CGFloat = preview.height - shapeHeight - 8
                let frame = CGRect(origin: preview.origin, size: CGSize(width: preview.width, height: height))
                let label = UILabel(frame: frame)
                label.textAlignment = .center
                label.font = .systemFont(ofSize: 34)
                label.textColor = foreColor
                return label
        }()

        func displayCallout() {
                layer.addSublayer(calloutLayer)
                addSubview(calloutStackView)
                isCalloutDisplaying = true
        }
        private lazy var isCalloutDisplaying: Bool = false
        private func removeCallout() {
                _ = calloutKeys.map({ $0.backgroundColor = backColor })
                calloutStackView.removeFromSuperview()
                calloutLayer.removeFromSuperlayer()
                isCalloutDisplaying = false
        }
        private lazy var calloutStackView: UIStackView = {
                let rect: CGRect = {
                        if isPhonePortrait {
                                let expansion = greaterMidX ? (bubblePath.bounds.maxX - shape.bounds.maxX - 5) : (shape.bounds.minX - bubblePath.bounds.minX)
                                let width = bubblePath.bounds.width - (expansion * 2)
                                let origin = CGPoint(x: bubblePath.bounds.minX + expansion, y: bubblePath.bounds.minY + 2)
                                let size = CGSize(width: width, height: shapeHeight)
                                return CGRect(origin: origin, size: size)
                        } else {
                                let origin = CGPoint(x: bubblePath.bounds.minX, y: bubblePath.bounds.minY)
                                let width = bubblePath.bounds.width
                                let size = CGSize(width: width, height: shapeHeight)
                                return CGRect(origin: origin, size: size)
                        }
                }()
                let stackView: UIStackView = UIStackView(frame: rect)
                stackView.distribution = .fillEqually
                stackView.addMultipleArrangedSubviews(calloutKeys)
                return stackView
        }()
        private lazy var calloutLayer: CAShapeLayer = {
                let layer = CAShapeLayer()
                layer.shadowOpacity = 0.3
                layer.shadowRadius = 0.5
                layer.shadowOffset = .zero
                layer.shadowColor = UIColor.black.cgColor
                layer.shouldRasterize = true
                layer.rasterizationScale = UIScreen.main.scale
                layer.path = isPhonePortrait ? previewPath.cgPath : keyShapePath.cgPath
                layer.fillColor = backColor.cgColor
                let animation = CABasicAnimation(keyPath: "path")
                animation.duration = 0.01
                animation.toValue = bubblePath.cgPath
                animation.fillMode = .forwards
                animation.isRemovedOnCompletion = false
                animation.timingFunction = CAMediaTimingFunction(name: .default)
                layer.add(animation, forKey: animation.keyPath)
                return layer
        }()
        private lazy var calloutKeys: [CalloutView] = {
                switch event {
                case .key(let seat):
                        guard !seat.children.isEmpty else { return [] }
                        let firstChild: KeyElement = seat.children.first!
                        let firstKey = CalloutView(text: firstChild.text, header: firstChild.header, footer: firstChild.footer, alignments: firstChild.alignments)
                        firstKey.backgroundColor = selectionColor
                        var keys: [CalloutView] = [firstKey]
                        for index in 1..<seat.children.count {
                                let element: KeyElement = seat.children[index]
                                let callout = CalloutView(text: element.text, header: element.header, footer: element.footer, alignments: element.alignments)
                                keys.append(callout)
                        }
                        return greaterMidX ? keys.reversed() : keys
                default:
                        return []
                }
        }()
        private lazy var selectionColor: UIColor =  UIColor(red: 52.0 / 255, green: 120.0 / 255, blue: 246.0 / 255, alpha: 1)
        private lazy var bubblePath: UIBezierPath = {
                if isPhonePortrait {
                        if greaterMidX {
                                return leftBubblePath(origin: bottomCenter, previewCornerRadius: 10, keyWidth: shapeWidth, keyHeight: shapeHeight, keyCornerRadius: 5, expansions: calloutKeys.count - 1)
                        } else {
                                return rightBubblePath(origin: bottomCenter, previewCornerRadius: 10, keyWidth: shapeWidth, keyHeight: shapeHeight, keyCornerRadius: 5, expansions: calloutKeys.count - 1)
                        }
                } else {
                        if greaterMidX {
                                return leftSquareBubblePath(origin: bottomCenter, keyWidth: shapeWidth, keyHeight: shapeHeight, cornerRadius: 5, expansions: calloutKeys.count - 1)
                        } else {
                                return rightSquareBubblePath(origin: bottomCenter, keyWidth: shapeWidth, keyHeight: shapeHeight, cornerRadius: 5, expansions: calloutKeys.count - 1)
                        }
                }
        }()
}
