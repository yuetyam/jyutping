import UIKit

/// 九宮格鍵
class GridKeyView: UIView {

        let event: KeyboardEvent
        let returnKeyType: UIReturnKeyType
        let isDarkAppearance: Bool

        private let shape: UIView = UIView()
        init(event: KeyboardEvent, controller: KeyboardViewController) {
                self.event = event
                self.returnKeyType = controller.textDocumentProxy.returnKeyType ?? .default
                self.isDarkAppearance = controller.isDarkAppearance
                super.init(frame: .zero)
                setupShapeView()
                switch event {
                case .backspace:
                        setupKeyImageView()
                default:
                        setupKeyTextLabel()
                }
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) { fatalError() }

        override var intrinsicContentSize: CGSize {
                return CGSize(width: width, height: height)
        }

        private func setupShapeView() {
                addSubview(shape)
                shape.translatesAutoresizingMaskIntoConstraints = false
                let horizontalConstant: CGFloat = 3
                let verticalConstant: CGFloat = 3
                NSLayoutConstraint.activate([
                        shape.topAnchor.constraint(equalTo: topAnchor, constant: verticalConstant),
                        shape.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalConstant),
                        shape.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalConstant),
                        shape.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalConstant)
                ])
                shape.isUserInteractionEnabled = false
                shape.tintColor = foreColor
                shape.layer.cornerRadius = 5
                shape.layer.cornerCurve = .continuous
                shape.layer.shadowColor = UIColor.black.cgColor
                shape.layer.shadowOpacity = 0.3
                shape.layer.shadowOffset = CGSize(width: 0, height: 1)
                shape.layer.shadowRadius = 0.5
                shape.layer.shouldRasterize = true
                shape.layer.rasterizationScale = UIScreen.main.scale

                guard isDarkAppearance else {
                        shape.backgroundColor = backColor
                        return
                }
                let effectView: BlurEffectView = deepDarkFantasy ? BlurEffectView(fraction: 0.48, effectStyle: .light) : BlurEffectView(fraction: 0.44, effectStyle: .extraLight)
                let blurEffectView: UIVisualEffectView = effectView
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
                digitLabel.textColor = foreColor
        }
        private func setupKeyImageView() {
                let keyImageView: UIImageView = UIImageView()
                shape.addSubview(keyImageView)
                keyImageView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        keyImageView.topAnchor.constraint(equalTo: shape.topAnchor, constant: 13),
                        keyImageView.bottomAnchor.constraint(equalTo: shape.bottomAnchor, constant: -13),
                        keyImageView.leadingAnchor.constraint(equalTo: shape.leadingAnchor),
                        keyImageView.trailingAnchor.constraint(equalTo: shape.trailingAnchor)
                ])
                keyImageView.contentMode = .scaleAspectFit
                keyImageView.image = UIImage(systemName: "delete.left")?.withTintColor(foreColor)
        }
}


extension GridKeyView {

        var width: CGFloat {
                switch event {
                case .input:
                        return 50
                case .space:
                        return 150
                default:
                        return 65
                }
        }
        var height: CGFloat {
                switch event {
                case .newLine:
                        return 106
                default:
                        return 53
                }
        }
        var keyText: String? {
                switch event {
                case .input(let seat):
                        return seat.primary.text
                case .space:
                        return Logogram.current == .simplified ? "粤拼" : "粵拼"
                case .newLine:
                        return Logogram.current == .simplified ? returnKeyTextSimplified : returnKeyText
                case .transform(let newLayout):
                        switch newLayout {
                        case .cantoneseNumeric, .numeric:
                                return "123"
                        case .cantoneseSymbolic, .symbolic:
                                return "#@$"
                        case .cantonese:
                                return "todo"
                        case .alphabetic:
                                return "ABC"
                        default:
                                return "??"
                        }
                default:
                        return nil
                }
        }
        private var returnKeyText: String {
                switch returnKeyType {
                case .continue:
                        return "繼續"
                case .default:
                        return "換行"
                case .done:
                        return "完成"
                case .emergencyCall:
                        return "緊急"
                case .go:
                        return "前往"
                case .google:
                        return "谷歌"
                case .join:
                        return "加入"
                case .next:
                        return "下一個"
                case .route:
                        return "路線"
                case .search:
                        return "搜尋"
                case .send:
                        return "傳送"
                case .yahoo:
                        return "雅虎"
                @unknown default:
                        return "換行"
                }
        }
        private var returnKeyTextSimplified: String {
                switch returnKeyType {
                case .continue:
                        return "继续"
                case .default:
                        return "换行"
                case .done:
                        return "完成"
                case .emergencyCall:
                        return "紧急"
                case .go:
                        return "前往"
                case .google:
                        return "谷歌"
                case .join:
                        return "加入"
                case .next:
                        return "下一个"
                case .route:
                        return "路线"
                case .search:
                        return "搜寻"
                case .send:
                        return "传送"
                case .yahoo:
                        return "雅虎"
                @unknown default:
                        return "换行"
                }
        }

        /// Key Shape View background color
        var backColor: UIColor {
                if isDarkAppearance {
                        return deepDarkFantasy ? .darkThick : .darkThin
                } else {
                        return deepDarkFantasy ? .lightEmphatic : .white
                }
        }
        var highlightingBackColor: UIColor {
                // action <=> non-action
                if isDarkAppearance {
                        return deepDarkFantasy ? .darkThin : .black
                } else {
                        return deepDarkFantasy ? .white : .lightEmphatic
                }
        }
        var deepDarkFantasy: Bool {
                switch event {
                case .input, .space:
                        return false
                default:
                        return true
                }
        }
        var foreColor: UIColor {
                return isDarkAppearance ? .white : .black
        }
}