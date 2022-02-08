import UIKit

/// 九宮格鍵
class GridKeyView: UIView {

        let event: KeyboardEvent
        let isDarkAppearance: Bool

        private let shape: UIView = UIView()
        init(event: KeyboardEvent, controller: KeyboardViewController) {
                self.event = event
                self.isDarkAppearance = controller.isDarkAppearance
                super.init(frame: .zero)
                setupShapeView()
                setupKeyTextLabel()
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) { fatalError() }

        override var intrinsicContentSize: CGSize {
                return CGSize(width: width, height: height)
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
        private func setupKeyTextLabel() {
                let digitLabel: UILabel = UILabel()
                shape.addSubview(digitLabel)
                digitLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        digitLabel.topAnchor.constraint(equalTo: shape.topAnchor),
                        digitLabel.bottomAnchor.constraint(equalTo: shape.bottomAnchor),
                        digitLabel.leadingAnchor.constraint(equalTo: shape.leadingAnchor),
                        digitLabel.trailingAnchor.constraint(equalTo: shape.trailingAnchor)
                ])
                digitLabel.textAlignment = .center
                digitLabel.font = .systemFont(ofSize: 16)
                digitLabel.text = keyText
                digitLabel.textColor = isDarkAppearance ? .white : .black
        }
}


extension GridKeyView {

        var width: CGFloat {
                switch event {
                case .space:
                        return 140
                case .backspace, .newLine:
                        return 70
                default:
                        return 60
                }
        }
        var height: CGFloat {
                switch event {
                case .newLine:
                        return 110
                default:
                        return 55
                }
        }
        var keyText: String? {
                switch event {
                case .input(let seat):
                        return seat.primary.text
                case .space:
                        return "粵拼"
                case .newLine:
                        return "return"
                case .backspace:
                        return "DEL"
                case .transform(let newLayout):
                        switch newLayout {
                        case .cantoneseNumeric, .numeric:
                                return "123"
                        case .cantoneseSymbolic, .symbolic:
                                return "#+="
                        case .cantonese:
                                return "拼"
                        case .alphabetic:
                                return "ABC"
                        default:
                                return "??"
                        }
                default:
                        return "NULL"
                }
        }
        var keyImageName: String? {
                switch event {
                case .globe:
                        return "globe"
                case .backspace:
                        return "delete.left"
                case .newLine:
                        return "return"
                default:
                        return nil
                }
        }
}
