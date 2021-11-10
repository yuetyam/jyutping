import UIKit

final class CandidateCell: UICollectionViewCell {

        let textLabel: UILabel = UILabel()
        let footnoteLabel: UILabel = UILabel()

        private(set) lazy var footnoteStyle: Int = UserDefaults.standard.integer(forKey: "jyutping_display")
        lazy var shouldUpdateSubviews: Bool = false

        private(set) lazy var logogram: Logogram = Logogram.current
        lazy var shouldUpdateFonts: Bool = false

        override init(frame: CGRect) {
                super.init(frame: frame)
                contentView.addSubview(textLabel)
                textLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                        textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
                ])
                textLabel.textAlignment = .center
                contentView.addSubview(footnoteLabel)
                footnoteLabel.translatesAutoresizingMaskIntoConstraints = false
                footnoteLabel.font = .systemFont(ofSize: 12)
                NSLayoutConstraint.activate([
                        footnoteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                        footnoteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
                ])
                footnoteLabel.textAlignment = .center
                updateSubviews()
                updateFonts()
        }

        required init?(coder: NSCoder) { fatalError("CandidateCell.init(coder:) error") }

        override func prepareForReuse() {
                super.prepareForReuse()
                if shouldUpdateSubviews {
                        footnoteStyle = UserDefaults.standard.integer(forKey: "jyutping_display")
                        updateSubviews()
                        shouldUpdateSubviews = false
                }
                if shouldUpdateFonts {
                        logogram = Logogram.current
                        updateFonts()
                        shouldUpdateFonts = false
                }
        }

        private func updateSubviews() {
                switch footnoteStyle {
                case 2:
                        NSLayoutConstraint.deactivate(TopJyutpingConstraints)
                        NSLayoutConstraint.deactivate(centerTextConstraints)
                        NSLayoutConstraint.activate(BottomJyutpingConstraints)
                        footnoteLabel.textColor = textLabel.textColor
                case 3:
                        NSLayoutConstraint.deactivate(TopJyutpingConstraints)
                        NSLayoutConstraint.deactivate(BottomJyutpingConstraints)
                        NSLayoutConstraint.activate(centerTextConstraints)
                        footnoteLabel.textColor = .clear
                default:
                        NSLayoutConstraint.deactivate(BottomJyutpingConstraints)
                        NSLayoutConstraint.deactivate(centerTextConstraints)
                        NSLayoutConstraint.activate(TopJyutpingConstraints)
                        footnoteLabel.textColor = textLabel.textColor
                }
        }
        private lazy var TopJyutpingConstraints: [NSLayoutConstraint] = [
                textLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 4),
                footnoteLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -18)
        ]
        private lazy var BottomJyutpingConstraints: [NSLayoutConstraint] = [
                textLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -8),
                footnoteLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 14)
        ]
        private lazy var centerTextConstraints: [NSLayoutConstraint] = [
                textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                footnoteLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 14)
        ]

        private func updateFonts() {
                switch logogram {
                case .traditional:
                        let preferSC: Bool = Locale.preferredLanguages.first?.hasPrefix("zh-Hans") ?? false
                        let fontName: String = preferSC ? "PingFang SC" : "PingFang HK"
                        textLabel.font = UIFont(name: fontName, size: 20)
                case .hongkong:
                        textLabel.font = UIFont(name: "PingFang HK", size: 20)
                case .taiwan:
                        textLabel.font = UIFont(name: "PingFang TC", size: 20)
                case .simplified:
                        textLabel.font = UIFont(name: "PingFang SC", size: 20)
                }
        }
}
