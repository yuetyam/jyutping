import UIKit

/// 九宮格鍵
final class GridKeyView: UIView {

        let event: KeyboardEvent
        let controller: KeyboardViewController
        let keyboardIdiom: KeyboardIdiom
        let needsInputModeSwitchKey: Bool
        let returnKeyType: UIReturnKeyType
        let isDarkAppearance: Bool

        private let shape: UIView = UIView()
        init(event: KeyboardEvent, controller: KeyboardViewController) {
                self.event = event
                self.controller = controller
                self.keyboardIdiom = controller.keyboardIdiom
                self.needsInputModeSwitchKey = controller.needsInputModeSwitchKey
                self.returnKeyType = controller.textDocumentProxy.returnKeyType ?? .default
                self.isDarkAppearance = controller.isDarkAppearance
                super.init(frame: .zero)
                setupShapeView()
                switch event {
                case .sidebar:
                        break
                case .backspace:
                        setupKeyImageView(.backspace)
                case .globe:
                        setupKeyImageView(.globe)
                default:
                        setupKeyTextLabel()
                }
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) { fatalError() }

        override var intrinsicContentSize: CGSize {
                return CGSize(width: width, height: height)
        }

        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
                controller.triggerHapticFeedback()
                switch self.event {
                case .backspace:
                        shape.backgroundColor = highlightingBackColor
                        controller.operate(.backspace)
                case .newLine:
                        shape.backgroundColor = highlightingBackColor
                case .space:
                        shape.backgroundColor = highlightingBackColor
                        controller.operate(.space)
                case .combine(let combination):
                        shape.backgroundColor = highlightingBackColor
                        controller.operate(.tenKey(combination))
                case .input(let seat):
                        shape.backgroundColor = highlightingBackColor
                        let text: String = seat.primary.text
                        controller.operate(.input(text))
                default:
                        break
                }
        }
        override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
                revertBackground()
        }
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
                revertBackground()
                controller.prepareHapticFeedback()
                switch self.event {
                case .newLine:
                        controller.operate(.return)
                case .transform(let idiom):
                        controller.operate(.transform(idiom))
                default:
                        break
                }
        }
        private func revertBackground() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) { [weak self] in
                        guard let self = self else { return }
                        self.shape.backgroundColor = self.backColor
                }
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
                digitLabel.font = keyFont
                digitLabel.text = keyText
                digitLabel.textColor = foreColor
        }
        private func setupKeyImageView(_ keyboardEvent: KeyboardEvent) {
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
                let imageName: String = {
                        switch keyboardEvent {
                        case .backspace:
                                return "delete.left"
                        case .globe:
                                return "globe"
                        case .newLine:
                                return "return"
                        default:
                                return "textformat.abc"
                        }
                }()
                keyImageView.image = UIImage(systemName: imageName)?.withTintColor(foreColor)
        }
}


private extension GridKeyView {

        var width: CGFloat {
                guard needsInputModeSwitchKey else {
                        return 70
                }
                switch event {
                case .space where keyboardIdiom == .tenKeyCantonese:
                        return 140
                default:
                        return 70
                }
        }
        var height: CGFloat {
                let base: CGFloat = 53
                switch event {
                case .sidebar:
                        return base * 3
                case .newLine:
                        return base * 2
                default:
                        return base
                }
        }
        var keyFont: UIFont {
                switch event {
                case .combine:
                        return .systemFont(ofSize: 16)
                case .input(let seat):
                        let isSingular: Bool = seat.primary.text.count == 1
                        return .systemFont(ofSize: isSingular ? 22 : 16)
                default:
                        return .systemFont(ofSize: 16)
                }
        }
        var keyText: String? {
                switch event {
                case .combine(let combination):
                        return combination.isPunctuation ? combination.text : combination.text.uppercased()
                case .input(let seat):
                        return seat.primary.text
                case .space:
                        if keyboardIdiom == .tenKeyNumeric {
                                return "空格"
                        } else if Logogram.current == .simplified {
                                return "粤拼"
                        } else {
                                return "粵拼"
                        }
                case .newLine:
                        return Logogram.current == .simplified ? returnKeyTextSimplified : returnKeyText
                case .transform(let newLayout):
                        switch newLayout {
                        case .cantoneseNumeric:
                                return "#@$"
                        case .tenKeyNumeric:
                                return "123"
                        case .tenKeyCantonese:
                                return "拼"
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
                case .combine, .input, .space:
                        return false
                default:
                        return true
                }
        }
        var foreColor: UIColor {
                return isDarkAppearance ? .white : .black
        }
}


enum Combination {

        case punctuation
        case ABC
        case DEF
        case GHI
        case JKL
        case MNO
        case PQRS
        case TUV
        case WXYZ

        var text: String {
                switch self {
                case .punctuation:
                        return "，。？"
                case .ABC:
                        return "abc"
                case .DEF:
                        return "def"
                case .GHI:
                        return "ghi"
                case .JKL:
                        return "jkl"
                case .MNO:
                        return "mno"
                case .PQRS:
                        return "pqrs"
                case .TUV:
                        return "tuv"
                case .WXYZ:
                        return "wxyz"
                }
        }

        var letters: [String] {
                return self.text.map({ String($0) })
        }

        var isPunctuation: Bool {
                return self == .punctuation
        }
}
