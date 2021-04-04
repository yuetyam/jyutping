import UIKit

final class NumberButton: UIButton {
        
        private let digit: Int
        private let viewController: KeyboardViewController
        private let keyButtonView: UIView = UIView()
        
        init(digit: Int, viewController: KeyboardViewController) {
                self.digit = digit
                self.viewController = viewController
                super.init(frame: .zero)
                backgroundColor = .interactableClear
                setupKeyButtonView()
                setupDigitLabel()
                setupFootnoteLabel()
        }
        
        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
                CGSize(width: 50, height: 45)
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                viewController.textDocumentProxy.insertText(String(digit))
                keyButtonView.backgroundColor = viewController.isDarkAppearance ? .black : .lightActionButton
                AudioFeedback.perform(.input)
                viewController.hapticFeedback?.impactOccurred()
        }
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
                UIView.animate(withDuration: 0, delay: 0.03, animations: {
                        self.keyButtonView.backgroundColor = self.viewController.isDarkAppearance ? .clear : .white
                })
        }
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
                UIView.animate(withDuration: 0, delay: 0.03, animations: {
                        self.keyButtonView.backgroundColor = self.viewController.isDarkAppearance ? .clear : .white
                })
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
                keyButtonView.tintColor = viewController.isDarkAppearance ? .white : .black
                keyButtonView.layer.cornerRadius = 5
                keyButtonView.layer.cornerCurve = .continuous
                keyButtonView.layer.shadowColor = UIColor.black.cgColor
                keyButtonView.layer.shadowOpacity = 0.3
                keyButtonView.layer.shadowOffset = CGSize(width: 0, height: 1)
                keyButtonView.layer.shadowRadius = 0.5
                keyButtonView.layer.shouldRasterize = true
                keyButtonView.layer.rasterizationScale = UIScreen.main.scale

                guard viewController.isDarkAppearance else {
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
                digitLabel.textColor = viewController.isDarkAppearance ? .white : .black
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
                footnoteLabel.textColor = viewController.isDarkAppearance ? .white : .black
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
        
        private let viewController: KeyboardViewController
        private let keyButtonView: UIView = UIView()
        
        init(viewController: KeyboardViewController) {
                self.viewController = viewController
                super.init(frame: .zero)
                backgroundColor = .interactableClear
                setupKeyButtonView()
                setupPeriodLabel()
                addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        }
        
        @objc private func handleTap() {
                viewController.textDocumentProxy.insertText(".")
                AudioFeedback.perform(.input)
                viewController.hapticFeedback?.impactOccurred()
        }
        
        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
                return CGSize(width: 50, height: 45)
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
                keyButtonView.tintColor = viewController.isDarkAppearance ? .white : .black
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
                periodLabel.textColor = viewController.isDarkAppearance ? .white : .black
        }
}

final class BackspaceButton: UIButton {
        
        private let viewController: KeyboardViewController
        private let keyButtonView: UIView = UIView()
        private let keyImageView = UIImageView()
        
        init(viewController: KeyboardViewController) {
                self.viewController = viewController
                super.init(frame: .zero)
                backgroundColor = .interactableClear
                setupKeyButtonView()
                setupKeyImageView()
        }
        
        deinit {
                fastBackspaceTimer?.invalidate()
                slowBackspaceTimer?.invalidate()
        }
        
        private var slowBackspaceTimer: Timer?
        private var fastBackspaceTimer: Timer?
        
        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
                return CGSize(width: 50, height: 45)
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                DispatchQueue.main.async {
                        self.keyImageView.image = UIImage(systemName: "delete.left.fill")
                }
                viewController.hapticFeedback?.impactOccurred()
                handleBackspace()
        }
        private func handleBackspace() {
                DispatchQueue.main.async {
                        self.performBackspace()
                }
                slowBackspaceTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { _ in
                        self.fastBackspaceTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.performBackspace), userInfo: nil, repeats: true)
                }
        }
        @objc private func performBackspace() {
                viewController.textDocumentProxy.deleteBackward()
                AudioFeedback.perform(.delete)
        }
        
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
                fastBackspaceTimer?.invalidate()
                slowBackspaceTimer?.invalidate()
                
                UIView.animate(withDuration: 0, delay: 0.03, animations: {
                        self.keyImageView.image = UIImage(systemName: "delete.left")
                })
        }
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
                fastBackspaceTimer?.invalidate()
                slowBackspaceTimer?.invalidate()
                
                UIView.animate(withDuration: 0, delay: 0.03, animations: {
                        self.keyImageView.image = UIImage(systemName: "delete.left")
                })
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
                keyButtonView.tintColor = viewController.isDarkAppearance ? .white : .black
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
