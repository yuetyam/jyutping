import UIKit

enum Operation: Hashable {
        case input(String)
        case separator
        case punctuation(String)
        case space
        case doubleSpace
        case backspace
        case clear
        case `return`
        case shift
        case doubleShift
        case switchTo(KeyboardLayout)
}

final class KeyView: UIView {

        let shape: UIView = UIView()
        let event: KeyboardEvent
        let controller: KeyboardViewController
        let layout: KeyboardLayout
        let isDarkAppearance: Bool
        let screenWidth: CGFloat
        let screenHeight: CGFloat
        let isCompactInterface: Bool
        let isPhonePortrait: Bool
        let isPhoneLandscape: Bool
        let isPadFloating: Bool
        let isPadPortrait: Bool
        let isPadLandscape: Bool

        init(event: KeyboardEvent, controller: KeyboardViewController) {
                self.event = event
                self.controller = controller
                layout = controller.keyboardLayout
                isDarkAppearance = controller.isDarkAppearance
                screenWidth = controller.screenWidth
                screenHeight = controller.screenHeight
                isCompactInterface = controller.isCompactInterface
                isPhonePortrait = controller.isPhonePortrait
                isPhoneLandscape = controller.isPhoneLandscape
                isPadFloating = controller.isPadFloating
                isPadPortrait = controller.isPadPortrait
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
                case .key(.separator):
                        setupKeyShapeView()
                        setupKeyTextLabel()
                        setupKeyFooterLabel(text: "分隔", alignment: .center)
                default:
                        setupKeyShapeView()
                        setupKeyTextLabel()
                }
                improveAccessibility()
        }
        required init?(coder: NSCoder) { fatalError("KeyView.init(coder:) error") }
        override var intrinsicContentSize: CGSize { CGSize(width: width, height: height) }


        // MARK: - Touches

        private var backspaceTimer: Timer?
        private var repeatingBackspaceTimer: Timer?
        private func invalidateTimers() {
                backspaceTimer?.invalidate()
                repeatingBackspaceTimer?.invalidate()
                backspaceTimer = nil
                repeatingBackspaceTimer = nil
        }
        private lazy var isInteracting: Bool = false
        private lazy var peekingText: String? = nil
        private lazy var spaceTouches: (first: Bool, second: Bool) = (false, false)
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesBegan(touches, with: event)
                controller.triggerHapticFeedback()
                invalidateTimers()
                isInteracting = true
                peekingText = nil
                switch self.event {
                case .none, .shadowKey, .switchInputMethod:
                        break
                case .key(let seat) where seat.hasChildren:
                        if isPhonePortrait {
                                displayPreview()
                        } else {
                                shape.backgroundColor = highlightingBackColor
                        }
                        handleLongPress()
                case .key:
                        if isPhonePortrait {
                                displayPreview()
                        } else {
                                shape.backgroundColor = highlightingBackColor
                        }
                case .backspace:
                        shape.backgroundColor = highlightingBackColor
                        backspaceTouchPoint = touches.first?.location(in: self) ?? .zero
                        handleBackspace()
                case .shadowBackspace:
                        handleBackspace()
                case .space:
                        spaceTouches = spaceTouches.first ? (true, true) : (true, false)
                        shape.backgroundColor = highlightingBackColor
                        spaceTouchPoint = touches.first?.location(in: self) ?? .zero
                        draggedOnSpace = false
                case .shift:
                        break
                case .newLine:
                        shape.backgroundColor = highlightingBackColor
                case .switchTo(let newLayout):
                        controller.operate(.switchTo(newLayout))
                }
        }

        private lazy var distances: [CGFloat] = {
                let max: CGFloat = calloutStackView.bounds.width
                var blocks: [CGFloat] = []
                let count: Int = calloutViews.count + 1
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
                case .key(let seat) where seat.hasChildren:
                        guard isCalloutDisplaying else { break }
                        guard let location: CGPoint = touches.first?.location(in: controller.view) else { break }
                        let distance: CGFloat = location.x - self.frame.midX
                        for index in 0..<(distances.count - 1) {
                                let rightCondition: Bool = (distances[index] < distance) && (distance < distances[index + 1])
                                let leftCondition: Bool = (distances[index] < -distance) && (-distance < distances[index + 1])
                                let condition: Bool = beyondMidX ? leftCondition : rightCondition
                                if condition {
                                        let this: Int = beyondMidX ? (calloutViews.count - 1 - index): index
                                        _ = calloutViews.map {
                                                $0.backgroundColor = backColor
                                                $0.setTextColor(foreColor)
                                        }
                                        calloutViews[this].backgroundColor = .selection
                                        calloutViews[this].setTextColor(.white)
                                        peekingText = calloutViews[this].text
                                }
                        }
                case .space:
                        guard let location: CGPoint = touches.first?.location(in: self) else { break }
                        let distance: CGFloat = location.x - spaceTouchPoint.x
                        guard abs(distance) > 10 else { break }
                        controller.inputText = .empty // FIXME: Dragging in input text
                        let offset: Int = distance > 0 ? 1 : -1
                        controller.textDocumentProxy.adjustTextPosition(byCharacterOffset: offset)
                        spaceTouchPoint = location
                        draggedOnSpace = true
                case .backspace:
                        guard layout.isCantoneseMode else { break }
                        guard let location: CGPoint = touches.first?.location(in: self) else { break }
                        let distance: CGFloat = location.x - backspaceTouchPoint.x
                        guard distance < -44 else { break }
                        controller.operate(.clear)
                default:
                        break
                }
        }
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesEnded(touches, with: event)
                invalidateTimers()
                isInteracting = false
                switch self.event {
                case .shift:
                        let now = Date.timeIntervalSinceReferenceDate
                        let distance = now - ShiftState.timePoint
                        ShiftState.timePoint = now
                        if distance < 0.3 {
                                controller.operate(.doubleShift)
                        } else {
                                controller.operate(.shift)
                        }
                case .space:
                        spaceTouchPoint = .zero
                        changeColorToNormal()
                        if !spaceTouches.second {
                                if !draggedOnSpace {
                                        controller.operate(.space)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                                        self?.spaceTouches = (false, false)
                                }
                        } else {
                                controller.operate(.doubleSpace)
                                spaceTouches = (false, false)
                        }
                case .backspace:
                        backspaceTouchPoint = .zero
                        changeColorToNormal()
                case .newLine:
                        controller.operate(.return)
                        changeColorToNormal()
                case .key(.cantoneseComma):
                        removeCallout()
                        if isPhonePortrait {
                                removePreview()
                        } else {
                                changeColorToNormal()
                        }
                        let punctuation: String = peekingText ?? KeySeat.cantoneseComma.primary.text
                        controller.operate(.punctuation(punctuation))
                case .key(.separator):
                        if isPhonePortrait {
                                removePreview()
                        } else {
                                changeColorToNormal()
                        }
                        controller.operate(.separator)
                case .key(let seat):
                        if seat.hasChildren {
                                removeCallout()
                        }
                        if isPhonePortrait {
                                removePreview()
                        } else {
                                changeColorToNormal()
                        }
                        let text: String = seat.hasChildren ? (peekingText ?? seat.primary.text) : seat.primary.text
                        controller.operate(.input(text))
                case .shadowKey(let text):
                        controller.operate(.input(text))
                default:
                        break
                }
                controller.prepareHapticFeedback()
        }
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
                super.touchesCancelled(touches, with: event)
                invalidateTimers()
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
                        spaceTouches = (false, false)
                case .shift:
                        spaceTouches = (false, false)
                case .key(let seat) where seat.hasChildren:
                        removeCallout()
                        if isPhonePortrait {
                                removePreview()
                        } else {
                                changeColorToNormal()
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
        }

        private func handleBackspace() {
                controller.operate(.backspace)
                guard backspaceTimer == nil && repeatingBackspaceTimer == nil else {
                        backspaceTimer?.invalidate()
                        repeatingBackspaceTimer?.invalidate()
                        backspaceTimer = nil
                        repeatingBackspaceTimer = nil
                        return
                }
                backspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] timer in
                        guard let self = self else { return }
                        guard self.isInteracting, self.backspaceTimer == timer else { return }
                        self.repeatingBackspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
                                guard let self = self else {
                                        timer.invalidate()
                                        return
                                }
                                guard self.isInteracting, self.repeatingBackspaceTimer == timer else {
                                        self.repeatingBackspaceTimer?.invalidate()
                                        self.repeatingBackspaceTimer = nil
                                        timer.invalidate()
                                        return
                                }
                                self.controller.operate(.backspace)
                        }
                }
        }


        // MARK: - Properties

        private lazy var backspaceTouchPoint: CGPoint = .zero
        private lazy var spaceTouchPoint: CGPoint = .zero
        private lazy var draggedOnSpace: Bool = false
        private lazy var beyondMidX: Bool = frame.midX > controller.view.frame.midX + 10
        private lazy var keyShapePath: UIBezierPath = shapeBezierPath(origin: bottomCenter, keyWidth: shapeWidth, keyHeight: shapeHeight, keyCornerRadius: 5)
        private lazy var previewPath: UIBezierPath = previewBezierPath(origin: bottomCenter, previewCornerRadius: 10, keyWidth: shapeWidth, keyHeight: shapeHeight, keyCornerRadius: 5)
        private lazy var shapeWidth: CGFloat = shape.frame.width
        private lazy var shapeHeight: CGFloat = shape.frame.height
        private lazy var bottomCenter: CGPoint = CGPoint(x: shape.frame.midX, y: shape.frame.maxY)


        // MARK: - Preview

        private func displayPreview() {
                layer.addSublayer(previewShapeLayer)
                addSubview(previewLabel)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.008) { [weak self] in
                        guard let self = self else { return }
                        self.previewLabel.text = self.keyText
                }
        }
        private func removePreview() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) { [weak self] in
                        guard let self = self else { return }
                        self.previewLabel.text = nil
                        self.previewLabel.removeFromSuperview()
                        self.previewShapeLayer.removeFromSuperlayer()
                }
        }
        private func changeColorToNormal() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) { [weak self] in
                        guard let self = self else { return }
                        self.shape.backgroundColor = self.isDarkAppearance ? .clear : self.backColor
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


        // MARK: - Callout

        private func handleLongPress() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                        guard let self = self else { return }
                        guard self.isInteracting else { return }
                        self.displayCallout()
                }
        }
        private func displayCallout() {
                layer.addSublayer(calloutLayer)
                addSubview(calloutStackView)
                isCalloutDisplaying = true
        }
        private lazy var isCalloutDisplaying: Bool = false
        private func removeCallout() {
                _ = calloutViews.map {
                        $0.backgroundColor = backColor
                        $0.setTextColor(foreColor)
                }
                calloutStackView.removeFromSuperview()
                calloutLayer.removeFromSuperlayer()
                isCalloutDisplaying = false
        }
        private lazy var calloutStackView: UIStackView = {
                let rect: CGRect = {
                        if isPhonePortrait {
                                let expansion = beyondMidX ? (bubblePath.bounds.maxX - shape.bounds.maxX - 5) : (shape.bounds.minX - bubblePath.bounds.minX)
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
                stackView.addArrangedSubviews(calloutViews)
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
        private lazy var calloutViews: [CalloutView] = {
                switch event {
                case .key(let seat) where seat.hasChildren:
                        let firstChild: KeyElement = seat.children.first!
                        let firstKey = CalloutView(text: firstChild.text, header: firstChild.header, footer: firstChild.footer, isPhoneInterface: isCompactInterface)
                        firstKey.backgroundColor = .selection
                        firstKey.setTextColor(.white)
                        var keys: [CalloutView] = [firstKey]
                        for index in 1..<seat.children.count {
                                let element: KeyElement = seat.children[index]
                                let callout = CalloutView(text: element.text, header: element.header, footer: element.footer, isPhoneInterface: isCompactInterface)
                                keys.append(callout)
                        }
                        return beyondMidX ? keys.reversed() : keys
                default:
                        return []
                }
        }()
        private lazy var bubblePath: UIBezierPath = {
                if isPhonePortrait {
                        if beyondMidX {
                                return leftBubblePath(origin: bottomCenter, previewCornerRadius: 10, keyWidth: shapeWidth, keyHeight: shapeHeight, keyCornerRadius: 5, expansions: calloutViews.count - 1)
                        } else {
                                return rightBubblePath(origin: bottomCenter, previewCornerRadius: 10, keyWidth: shapeWidth, keyHeight: shapeHeight, keyCornerRadius: 5, expansions: calloutViews.count - 1)
                        }
                } else {
                        if beyondMidX {
                                return leftSquareBubblePath(origin: bottomCenter, keyWidth: shapeWidth, keyHeight: shapeHeight, cornerRadius: 5, expansions: calloutViews.count - 1)
                        } else {
                                return rightSquareBubblePath(origin: bottomCenter, keyWidth: shapeWidth, keyHeight: shapeHeight, cornerRadius: 5, expansions: calloutViews.count - 1)
                        }
                }
        }()


        // MARK: - Accessibility

        private func improveAccessibility() {
                switch event {
                case .space:
                        isAccessibilityElement = true
                        accessibilityTraits = [.keyboardKey]
                        accessibilityLabel = NSLocalizedString("space bar", comment: .empty)
                case .newLine:
                        isAccessibilityElement = true
                        accessibilityTraits = [.keyboardKey]
                        accessibilityLabel = NSLocalizedString("return key", comment: .empty)
                case .backspace:
                        isAccessibilityElement = true
                        accessibilityTraits = [.keyboardKey]
                        accessibilityLabel = NSLocalizedString("backspace key", comment: .empty)
                case .shift:
                        isAccessibilityElement = true
                        accessibilityTraits = [.keyboardKey]
                        accessibilityLabel = NSLocalizedString("shift key", comment: .empty)
                        switch layout {
                        case .cantonese(.capsLocked), .alphabetic(.capsLocked):
                                accessibilityValue = NSLocalizedString("Caps Locked", comment: .empty)
                        case .cantonese(.uppercased), .alphabetic(.uppercased):
                                accessibilityValue = NSLocalizedString("Uppercased", comment: .empty)
                        default:
                                accessibilityValue = NSLocalizedString("Lowercased", comment: .empty)
                        }
                case .switchTo(let layout):
                        switch layout {
                        case .cantonese:
                                isAccessibilityElement = true
                                accessibilityTraits = [.keyboardKey]
                                accessibilityLabel = NSLocalizedString("Switch to Cantonese layout", comment: .empty)
                        case .alphabetic:
                                isAccessibilityElement = true
                                accessibilityTraits = [.keyboardKey]
                                accessibilityLabel = NSLocalizedString("Switch to English layout", comment: .empty)
                        case .numeric, .cantoneseNumeric:
                                isAccessibilityElement = true
                                accessibilityTraits = [.keyboardKey]
                                accessibilityLabel = NSLocalizedString("Switch to Numbers layout", comment: .empty)
                        case .symbolic, .cantoneseSymbolic:
                                isAccessibilityElement = true
                                accessibilityTraits = [.keyboardKey]
                                accessibilityLabel = NSLocalizedString("Switch to Symbols layout", comment: .empty)
                        default:
                                break
                        }
                default:
                        break
                }
        }
}
