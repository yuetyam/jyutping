import UIKit

final class NumberButton: UIButton {
        
        private let digit: Int
        private let viewController: KeyboardViewController
        private let keyButtonView: UIView = UIView()
        
        init(digit: Int, viewController: KeyboardViewController) {
                self.digit = digit
                self.viewController = viewController
                super.init(frame: .zero)
                
                setupKeyButtonView()
                setupDigitLabel()
                setupFootnoteLabel()
        }
        
        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
                return CGSize(width: 50, height: 60)
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                viewController.textDocumentProxy.insertText(String(digit))
                keyButtonView.backgroundColor = viewController.isDarkAppearance ? DarkMode.darkActionButton : LightMode.lightActionButton
                AudioFeedback.perform(audioFeedback: .input)
        }
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
                UIView.animate(withDuration: 0, delay: 0.05, animations: {
                        self.keyButtonView.backgroundColor = self.viewController.isDarkAppearance ? DarkMode.darkButton : .white
                })
        }
        
        private func setupKeyButtonView() {
                addSubview(keyButtonView)
                keyButtonView.translatesAutoresizingMaskIntoConstraints = false
                let horizontalConstant: CGFloat = 4
                let verticalConstant: CGFloat = 4
                keyButtonView.topAnchor.constraint(equalTo: topAnchor, constant: verticalConstant).isActive = true
                keyButtonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalConstant).isActive = true
                keyButtonView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalConstant).isActive = true
                keyButtonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalConstant).isActive = true
                keyButtonView.isUserInteractionEnabled = false
                keyButtonView.backgroundColor = viewController.isDarkAppearance ? DarkMode.darkButton : .white
                keyButtonView.tintColor = viewController.isDarkAppearance ? .white : .black
                
                keyButtonView.layer.cornerRadius = 5
                keyButtonView.layer.cornerCurve = .continuous
                keyButtonView.layer.shadowColor = UIColor.black.cgColor
                keyButtonView.layer.shadowOpacity = 0.3
                keyButtonView.layer.shadowOffset = CGSize(width: 0, height: 1)
                keyButtonView.layer.shadowRadius = 0.5
                keyButtonView.layer.shouldRasterize = true
                keyButtonView.layer.rasterizationScale = UIScreen.main.scale
                keyButtonView.layer.shadowPath = nil
        }
        
        private func setupDigitLabel() {
                let digitLabel: UILabel = UILabel()
                keyButtonView.addSubview(digitLabel)
                digitLabel.translatesAutoresizingMaskIntoConstraints = false
                digitLabel.topAnchor.constraint(equalTo: keyButtonView.topAnchor).isActive = true
                digitLabel.bottomAnchor.constraint(equalTo: keyButtonView.bottomAnchor, constant: -15).isActive = true
                digitLabel.leadingAnchor.constraint(equalTo: keyButtonView.leadingAnchor).isActive = true
                digitLabel.trailingAnchor.constraint(equalTo: keyButtonView.trailingAnchor).isActive = true
                digitLabel.textAlignment = .center
                digitLabel.adjustsFontForContentSizeCategory = true
                digitLabel.font = .preferredFont(forTextStyle: .title1)
                digitLabel.text = String(digit)
                digitLabel.textColor = viewController.isDarkAppearance ? .white : .black
        }
        private func setupFootnoteLabel() {
                let footnoteLabel: UILabel = UILabel()
                keyButtonView.addSubview(footnoteLabel)
                footnoteLabel.translatesAutoresizingMaskIntoConstraints = false
                footnoteLabel.topAnchor.constraint(equalTo: keyButtonView.bottomAnchor, constant: -20).isActive = true
                footnoteLabel.bottomAnchor.constraint(equalTo: keyButtonView.bottomAnchor).isActive = true
                footnoteLabel.leadingAnchor.constraint(equalTo: keyButtonView.leadingAnchor).isActive = true
                footnoteLabel.trailingAnchor.constraint(equalTo: keyButtonView.trailingAnchor).isActive = true
                footnoteLabel.textAlignment = .center
                footnoteLabel.adjustsFontForContentSizeCategory = true
                footnoteLabel.font = UIFontMetrics(forTextStyle: .caption1).scaledFont(for: .systemFont(ofSize: 12, weight: .medium))
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
                setupKeyButtonView()
                setupPeriodLabel()
                addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        }
        
        @objc private func handleTap() {
                viewController.textDocumentProxy.insertText(".")
                AudioFeedback.perform(audioFeedback: .input)
        }
        
        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
        
        override var intrinsicContentSize: CGSize {
                return CGSize(width: 50, height: 60)
        }
        
        private func setupKeyButtonView() {
                addSubview(keyButtonView)
                keyButtonView.translatesAutoresizingMaskIntoConstraints = false
                keyButtonView.topAnchor.constraint(equalTo: topAnchor).isActive = true
                keyButtonView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                keyButtonView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                keyButtonView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
                keyButtonView.isUserInteractionEnabled = false
                keyButtonView.backgroundColor = .clearTappable
                keyButtonView.tintColor = viewController.isDarkAppearance ? .white : .black
        }
        private func setupPeriodLabel() {
                let periodLabel = UILabel()
                keyButtonView.addSubview(periodLabel)
                periodLabel.translatesAutoresizingMaskIntoConstraints = false
                periodLabel.topAnchor.constraint(equalTo: keyButtonView.topAnchor).isActive = true
                periodLabel.bottomAnchor.constraint(equalTo: keyButtonView.bottomAnchor, constant: -15).isActive = true
                periodLabel.leadingAnchor.constraint(equalTo: keyButtonView.leadingAnchor).isActive = true
                periodLabel.trailingAnchor.constraint(equalTo: keyButtonView.trailingAnchor).isActive = true
                periodLabel.textAlignment = .center
                periodLabel.adjustsFontForContentSizeCategory = true
                periodLabel.font = .preferredFont(forTextStyle: .title1)
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
                return CGSize(width: 50, height: 60)
        }
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                DispatchQueue.main.async {
                        self.keyImageView.image = UIImage(systemName: "delete.left.fill")
                }
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
                AudioFeedback.perform(audioFeedback: .delete)
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
                keyButtonView.topAnchor.constraint(equalTo: topAnchor).isActive = true
                keyButtonView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                keyButtonView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                keyButtonView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
                keyButtonView.isUserInteractionEnabled = false
                keyButtonView.backgroundColor = .clearTappable
                keyButtonView.tintColor = viewController.isDarkAppearance ? .white : .black
        }
        private func setupKeyImageView() {
                keyButtonView.addSubview(keyImageView)
                keyImageView.translatesAutoresizingMaskIntoConstraints = false
                let topBottomInset: CGFloat = 15
                keyImageView.topAnchor.constraint(equalTo: keyButtonView.topAnchor, constant: topBottomInset).isActive = true
                keyImageView.bottomAnchor.constraint(equalTo: keyButtonView.bottomAnchor, constant: -topBottomInset).isActive = true
                keyImageView.leadingAnchor.constraint(equalTo: keyButtonView.leadingAnchor).isActive = true
                keyImageView.trailingAnchor.constraint(equalTo: keyButtonView.trailingAnchor).isActive = true
                keyImageView.contentMode = .scaleAspectFit
                keyImageView.image = UIImage(systemName: "delete.left")
        }
}

final class NumberPadEmptyKey: UIView {
        override var intrinsicContentSize: CGSize {
                return CGSize(width: 50, height: 60)
        }
}

/*
final class TopBar: UIView {
        
        private let viewController: KeyboardViewController
        init(viewController: KeyboardViewController) {
                self.viewController = viewController
                super.init(frame: .zero)
                heightAnchor.constraint(equalToConstant: 40).isActive = true
                
                let doneButton: UIButton = UIButton()
                addSubview(doneButton)
                doneButton.translatesAutoresizingMaskIntoConstraints = false
                doneButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
                doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
                doneButton.setTitle(NSLocalizedString("Done", comment: ""), for: .normal)
                doneButton.setTitleColor(.systemBlue, for: .normal)
                doneButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
                
                let backButton: UIButton = UIButton()
                addSubview(backButton)
                backButton.translatesAutoresizingMaskIntoConstraints = false
                backButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
                backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
                backButton.setTitle(NSLocalizedString("← Keyboard", comment: ""), for: .normal)
                backButton.setTitleColor(.systemBlue, for: .normal)
                backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        }
        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
        
        @objc private func dismissKeyboard() {
                viewController.resignFirstResponder()
                viewController.dismissKeyboard()
        }
        
        @objc private func back() {
                viewController.keyboardLayout = .numeric
        }
}
*/
