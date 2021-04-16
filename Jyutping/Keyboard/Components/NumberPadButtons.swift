import UIKit

final class NumberButton: UIButton {

        private let digit: Int
        private let controller: KeyboardViewController
        private let keyButtonView: UIView = UIView()

        init(digit: Int, viewController: KeyboardViewController) {
                self.digit = digit
                self.controller = viewController
                super.init(frame: .zero)
                backgroundColor = .interactiveClear
                setupKeyButtonView()
                setupDigitLabel()
                setupFootnoteLabel()
        }

        required init?(coder: NSCoder) { fatalError("NumberButton.init(coder:) error") }
        override var intrinsicContentSize: CGSize { return CGSize(width: 50, height: 45) }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                controller.insert(String(digit))
                keyButtonView.backgroundColor = controller.isDarkAppearance ? .black : .lightActionButton
                AudioFeedback.perform(.input)
                controller.hapticFeedback?.impactOccurred()
        }
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) { [weak self] in
                        if self != nil {
                                self!.keyButtonView.backgroundColor = self!.controller.isDarkAppearance ? .clear : .white
                        }
                }
        }
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
                keyButtonView.backgroundColor = controller.isDarkAppearance ? .clear : .white
        }

        private func setupKeyButtonView() {
                addSubview(keyButtonView)
                keyButtonView.translatesAutoresizingMaskIntoConstraints = false
                let horizontalConstant: CGFloat = 4
                let verticalConstant: CGFloat = 4
                NSLayoutConstraint.activate([
                        keyButtonView.topAnchor.constraint(equalTo: topAnchor, constant: verticalConstant),
                        keyButtonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalConstant),
                        keyButtonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalConstant),
                        keyButtonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalConstant)
                ])
                keyButtonView.isUserInteractionEnabled = false
                keyButtonView.tintColor = controller.isDarkAppearance ? .white : .black
                keyButtonView.layer.cornerRadius = 5
                keyButtonView.layer.cornerCurve = .continuous
                keyButtonView.layer.shadowColor = UIColor.black.cgColor
                keyButtonView.layer.shadowOpacity = 0.3
                keyButtonView.layer.shadowOffset = CGSize(width: 0, height: 1)
                keyButtonView.layer.shadowRadius = 0.5
                keyButtonView.layer.shouldRasterize = true
                keyButtonView.layer.rasterizationScale = UIScreen.main.scale

                guard controller.isDarkAppearance else {
                        keyButtonView.backgroundColor = .white
                        return
                }
                let blurEffectView: UIVisualEffectView = BlurEffectView(fraction: 0.44, effectStyle: .extraLight)
                blurEffectView.frame = keyButtonView.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                blurEffectView.layer.cornerRadius = 5
                blurEffectView.layer.cornerCurve = .continuous
                blurEffectView.clipsToBounds = true
                keyButtonView.addSubview(blurEffectView)
        }

        private func setupDigitLabel() {
                let digitLabel: UILabel = UILabel()
                keyButtonView.addSubview(digitLabel)
                digitLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        digitLabel.topAnchor.constraint(equalTo: keyButtonView.topAnchor),
                        digitLabel.bottomAnchor.constraint(equalTo: keyButtonView.bottomAnchor, constant: -15),
                        digitLabel.leadingAnchor.constraint(equalTo: keyButtonView.leadingAnchor),
                        digitLabel.trailingAnchor.constraint(equalTo: keyButtonView.trailingAnchor)
                ])
                digitLabel.textAlignment = .center
                digitLabel.font = .systemFont(ofSize: 25)
                digitLabel.text = String(digit)
                digitLabel.textColor = controller.isDarkAppearance ? .white : .black
        }
        private func setupFootnoteLabel() {
                let footnoteLabel: UILabel = UILabel()
                keyButtonView.addSubview(footnoteLabel)
                footnoteLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        footnoteLabel.topAnchor.constraint(equalTo: keyButtonView.bottomAnchor, constant: -20),
                        footnoteLabel.bottomAnchor.constraint(equalTo: keyButtonView.bottomAnchor),
                        footnoteLabel.leadingAnchor.constraint(equalTo: keyButtonView.leadingAnchor),
                        footnoteLabel.trailingAnchor.constraint(equalTo: keyButtonView.trailingAnchor)
                ])
                footnoteLabel.textAlignment = .center
                footnoteLabel.font = .boldSystemFont(ofSize: 10)
                footnoteLabel.text = footnote
                footnoteLabel.textColor = controller.isDarkAppearance ? .white : .black
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

final class PeriodButton: UIButton {

        private let controller: KeyboardViewController
        private let keyButtonView: UIView = UIView()

        init(viewController: KeyboardViewController) {
                self.controller = viewController
                super.init(frame: .zero)
                backgroundColor = .interactiveClear
                setupKeyButtonView()
                setupPeriodLabel()
                addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        }
        @objc private func handleTap() {
                controller.insert(".")
                AudioFeedback.perform(.input)
                controller.hapticFeedback?.impactOccurred()
        }

        required init?(coder: NSCoder) { fatalError("PeriodButton.init(coder:) error") }
        override var intrinsicContentSize: CGSize { return CGSize(width: 50, height: 45) }

        private func setupKeyButtonView() {
                addSubview(keyButtonView)
                keyButtonView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        keyButtonView.topAnchor.constraint(equalTo: topAnchor),
                        keyButtonView.bottomAnchor.constraint(equalTo: bottomAnchor),
                        keyButtonView.leadingAnchor.constraint(equalTo: leadingAnchor),
                        keyButtonView.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
                keyButtonView.isUserInteractionEnabled = false
                keyButtonView.tintColor = controller.isDarkAppearance ? .white : .black
        }
        private func setupPeriodLabel() {
                let periodLabel = UILabel()
                keyButtonView.addSubview(periodLabel)
                periodLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        periodLabel.topAnchor.constraint(equalTo: keyButtonView.topAnchor),
                        periodLabel.bottomAnchor.constraint(equalTo: keyButtonView.bottomAnchor, constant: -15),
                        periodLabel.leadingAnchor.constraint(equalTo: keyButtonView.leadingAnchor),
                        periodLabel.trailingAnchor.constraint(equalTo: keyButtonView.trailingAnchor)
                ])
                periodLabel.textAlignment = .center
                periodLabel.font = .systemFont(ofSize: 28)
                periodLabel.text = "."
                periodLabel.textColor = controller.isDarkAppearance ? .white : .black
        }
}

final class BackspaceButton: UIButton {

        private let controller: KeyboardViewController
        private let keyButtonView: UIView = UIView()
        private let keyImageView = UIImageView()

        init(viewController: KeyboardViewController) {
                self.controller = viewController
                super.init(frame: .zero)
                backgroundColor = .interactiveClear
                setupKeyButtonView()
                setupKeyImageView()
        }
        required init?(coder: NSCoder) { fatalError("BackspaceButton.init(coder:) error") }
        override var intrinsicContentSize: CGSize { return CGSize(width: 50, height: 45) }
        deinit {
                backspaceTimer?.invalidate()
                isInteracting = false
        }
        private var backspaceTimer: Timer?
        private lazy var isInteracting: Bool = false {
                didSet {
                        if !isInteracting {
                                backspaceTimer?.invalidate()
                        }
                }
        }
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                isInteracting = true
                DispatchQueue.main.async { [weak self] in
                        if self != nil {
                                self!.keyImageView.image = UIImage(systemName: "delete.left.fill")
                        }
                }
                controller.hapticFeedback?.impactOccurred()
                handleBackspace()
        }
        private func handleBackspace() {
                performBackspace()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                        if self != nil {
                                if self!.isInteracting {
                                        self!.backspaceTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self!, selector: #selector(self!.performBackspace), userInfo: nil, repeats: true)
                                }
                        }
                }
        }
        @objc private func performBackspace() {
                controller.textDocumentProxy.deleteBackward()
                AudioFeedback.perform(.delete)
        }

        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
                isInteracting = false
                keyImageView.image = UIImage(systemName: "delete.left")
        }
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
                isInteracting = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.03) { [weak self] in
                        if self != nil {
                                self!.keyImageView.image = UIImage(systemName: "delete.left")
                        }
                }
        }

        private func setupKeyButtonView() {
                addSubview(keyButtonView)
                keyButtonView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        keyButtonView.topAnchor.constraint(equalTo: topAnchor),
                        keyButtonView.bottomAnchor.constraint(equalTo: bottomAnchor),
                        keyButtonView.leadingAnchor.constraint(equalTo: leadingAnchor),
                        keyButtonView.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
                keyButtonView.isUserInteractionEnabled = false
                keyButtonView.tintColor = controller.isDarkAppearance ? .white : .black
        }
        private func setupKeyImageView() {
                keyButtonView.addSubview(keyImageView)
                keyImageView.translatesAutoresizingMaskIntoConstraints = false
                let topBottomInset: CGFloat = 15
                NSLayoutConstraint.activate([
                        keyImageView.topAnchor.constraint(equalTo: keyButtonView.topAnchor, constant: topBottomInset),
                        keyImageView.bottomAnchor.constraint(equalTo: keyButtonView.bottomAnchor, constant: -topBottomInset),
                        keyImageView.leadingAnchor.constraint(equalTo: keyButtonView.leadingAnchor),
                        keyImageView.trailingAnchor.constraint(equalTo: keyButtonView.trailingAnchor)
                ])
                keyImageView.contentMode = .scaleAspectFit
                keyImageView.image = UIImage(systemName: "delete.left")
        }
}

final class NumberPadEmptyKey: UIView {
        override var intrinsicContentSize: CGSize {
                return CGSize(width: 50, height: 45)
        }
}
