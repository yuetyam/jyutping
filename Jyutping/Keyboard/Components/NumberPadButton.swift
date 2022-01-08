import UIKit

/// Number / Digit button for `.numberPad` and `.decimalPad`
final class NumberButton: UIView {

        private let digit: Int
        private let controller: KeyboardViewController
        private let isDarkAppearance: Bool
        private let foreColor: UIColor
        private let shape: UIView = UIView()

        init(digit: Int, controller: KeyboardViewController) {
                self.digit = digit
                self.controller = controller
                self.isDarkAppearance = controller.isDarkAppearance
                self.foreColor = controller.isDarkAppearance ? .white : .black
                super.init(frame: .zero)
                backgroundColor = .interactiveClear
                setupShapeView()
                setupDigitLabel()
                setupFootnoteLabel()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) { fatalError() }

        override var intrinsicContentSize: CGSize {
                return CGSize(width: 50, height: 45)
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                controller.insert(String(digit))
                shape.backgroundColor = isDarkAppearance ? .black : .lightEmphatic
                AudioFeedback.perform(.input)
                controller.triggerHapticFeedback()
        }
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) { [weak self] in
                        guard let self = self else { return }
                        self.shape.backgroundColor = self.isDarkAppearance ? .clear : .white
                }
        }
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
                shape.backgroundColor = isDarkAppearance ? .clear : .white
        }

        private func setupShapeView() {
                addSubview(shape)
                shape.translatesAutoresizingMaskIntoConstraints = false
                let horizontalConstant: CGFloat = 4
                let verticalConstant: CGFloat = 4
                NSLayoutConstraint.activate([
                        shape.topAnchor.constraint(equalTo: topAnchor, constant: verticalConstant),
                        shape.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalConstant),
                        shape.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalConstant),
                        shape.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalConstant)
                ])
                shape.isUserInteractionEnabled = false
                shape.tintColor = isDarkAppearance ? .white : .black
                shape.layer.cornerRadius = 5
                shape.layer.cornerCurve = .continuous
                shape.layer.shadowColor = UIColor.black.cgColor
                shape.layer.shadowOpacity = 0.3
                shape.layer.shadowOffset = CGSize(width: 0, height: 1)
                shape.layer.shadowRadius = 0.5
                shape.layer.shouldRasterize = true
                shape.layer.rasterizationScale = UIScreen.main.scale

                guard isDarkAppearance else {
                        shape.backgroundColor = .white
                        return
                }
                let blurEffectView: UIVisualEffectView = BlurEffectView(fraction: 0.44, effectStyle: .extraLight)
                blurEffectView.frame = shape.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                blurEffectView.layer.cornerRadius = 5
                blurEffectView.layer.cornerCurve = .continuous
                blurEffectView.clipsToBounds = true
                shape.addSubview(blurEffectView)
        }
        private func setupDigitLabel() {
                let digitLabel: UILabel = UILabel()
                shape.addSubview(digitLabel)
                digitLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        digitLabel.topAnchor.constraint(equalTo: shape.topAnchor),
                        digitLabel.bottomAnchor.constraint(equalTo: shape.bottomAnchor, constant: -15),
                        digitLabel.leadingAnchor.constraint(equalTo: shape.leadingAnchor),
                        digitLabel.trailingAnchor.constraint(equalTo: shape.trailingAnchor)
                ])
                digitLabel.textAlignment = .center
                digitLabel.font = .systemFont(ofSize: 25)
                digitLabel.text = String(digit)
                digitLabel.textColor = foreColor
        }
        private func setupFootnoteLabel() {
                let footnoteLabel: UILabel = UILabel()
                shape.addSubview(footnoteLabel)
                footnoteLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        footnoteLabel.topAnchor.constraint(equalTo: shape.bottomAnchor, constant: -20),
                        footnoteLabel.bottomAnchor.constraint(equalTo: shape.bottomAnchor),
                        footnoteLabel.leadingAnchor.constraint(equalTo: shape.leadingAnchor),
                        footnoteLabel.trailingAnchor.constraint(equalTo: shape.trailingAnchor)
                ])
                footnoteLabel.textAlignment = .center
                footnoteLabel.font = .boldSystemFont(ofSize: 10)
                footnoteLabel.text = footnote
                footnoteLabel.textColor = foreColor
        }

        private var footnote: String? {
                switch digit {
                case 2:
                        return "ABC"
                case 3:
                        return "DEF"
                case 4:
                        return "GHI"
                case 5:
                        return "JKL"
                case 6:
                        return "MNO"
                case 7:
                        return "PQRS"
                case 8:
                        return "TUV"
                case 9:
                        return "WXYZ"
                default:
                        return nil
                }
        }
}

/// Point / Dot button for `.decimalPad`
final class PointButton: UIButton {

        private let controller: KeyboardViewController

        init(controller: KeyboardViewController) {
                self.controller = controller
                super.init(frame: .zero)
                backgroundColor = .interactiveClear
                setupTextLabel()
                addTarget(self, action: #selector(insert), for: .touchUpInside)
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) { fatalError() }

        override var intrinsicContentSize: CGSize {
                return CGSize(width: 50, height: 45)
        }

        @objc private func insert() {
                controller.insert(".")
                AudioFeedback.perform(.input)
                controller.triggerHapticFeedback()
        }
        private func setupTextLabel() {
                let label = UILabel()
                addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        label.topAnchor.constraint(equalTo: topAnchor),
                        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
                        label.leadingAnchor.constraint(equalTo: leadingAnchor),
                        label.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
                label.textAlignment = .center
                label.font = .systemFont(ofSize: 28)
                label.text = "."
                label.textColor = controller.isDarkAppearance ? .white : .black
        }
}

/// Backspace button for `.numberPad` and `.decimalPad`
final class BackspaceButton: UIView {

        private let controller: KeyboardViewController
        private let keyImageView: UIImageView = UIImageView()

        init(controller: KeyboardViewController) {
                self.controller = controller
                super.init(frame: .zero)
                backgroundColor = .interactiveClear
                setupKeyImageView()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) { fatalError() }

        override var intrinsicContentSize: CGSize {
                return CGSize(width: 50, height: 45)
        }

        private var backspaceTimer: Timer?
        private var repeatingBackspaceTimer: Timer?
        private func invalidateTimers() {
                backspaceTimer?.invalidate()
                repeatingBackspaceTimer?.invalidate()
                backspaceTimer = nil
                repeatingBackspaceTimer = nil
        }
        private lazy var isInteracting: Bool = false
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                invalidateTimers()
                isInteracting = true
                DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.keyImageView.image = UIImage(systemName: "delete.left.fill")
                }
                controller.triggerHapticFeedback()
                handleBackspace()
        }
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
                invalidateTimers()
                isInteracting = false
                keyImageView.image = UIImage(systemName: "delete.left")
        }
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
                invalidateTimers()
                isInteracting = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) { [weak self] in
                        guard let self = self else { return }
                        self.keyImageView.image = UIImage(systemName: "delete.left")
                }
        }
        private func handleBackspace() {
                performBackspace()
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
                                self.performBackspace()
                        }
                }
        }
        private func performBackspace() {
                controller.textDocumentProxy.deleteBackward()
                AudioFeedback.perform(.delete)
        }
        private func setupKeyImageView() {
                addSubview(keyImageView)
                keyImageView.translatesAutoresizingMaskIntoConstraints = false
                let topBottomInset: CGFloat = 15
                NSLayoutConstraint.activate([
                        keyImageView.topAnchor.constraint(equalTo: topAnchor, constant: topBottomInset),
                        keyImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -topBottomInset),
                        keyImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
                        keyImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
                keyImageView.contentMode = .scaleAspectFit
                keyImageView.image = UIImage(systemName: "delete.left")
        }
}

final class NumberPadEmptyKey: UIView {
        override var intrinsicContentSize: CGSize { CGSize(width: 50, height: 45) }
}
