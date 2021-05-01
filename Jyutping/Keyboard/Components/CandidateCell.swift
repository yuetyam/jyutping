import UIKit

final class CandidateCell: UICollectionViewCell {

        let textLabel: UILabel = UILabel()
        let footnoteLabel: UILabel = UILabel()

        private(set) lazy var jyutpingDisplay: Int = UserDefaults.standard.integer(forKey: "jyutping_display")
        lazy var shouldUpdateSubviews: Bool = false

        private(set) lazy var logogram: Int = UserDefaults.standard.integer(forKey: "logogram")
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
                footnoteLabel.font = .systemFont(ofSize: 13)
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
                        jyutpingDisplay = UserDefaults.standard.integer(forKey: "jyutping_display")
                        updateSubviews()
                        shouldUpdateSubviews = false
                }
                if shouldUpdateFonts {
                        logogram = UserDefaults.standard.integer(forKey: "logogram")
                        updateFonts()
                        shouldUpdateFonts = false
                }
        }

        private func updateSubviews() {
                switch jyutpingDisplay {
                case 2:
                        NSLayoutConstraint.deactivate(TopJyutpingConstraints)
                        NSLayoutConstraint.deactivate(NoJyutpingConstraints)
                        NSLayoutConstraint.activate(BottomJyutpingConstraints)
                        footnoteLabel.textColor = textLabel.textColor
                case 3:
                        NSLayoutConstraint.deactivate(TopJyutpingConstraints)
                        NSLayoutConstraint.deactivate(BottomJyutpingConstraints)
                        NSLayoutConstraint.activate(NoJyutpingConstraints)
                        footnoteLabel.textColor = .clear
                default:
                        NSLayoutConstraint.deactivate(BottomJyutpingConstraints)
                        NSLayoutConstraint.deactivate(NoJyutpingConstraints)
                        NSLayoutConstraint.activate(TopJyutpingConstraints)
                        footnoteLabel.textColor = textLabel.textColor
                }
        }
        private lazy var TopJyutpingConstraints: [NSLayoutConstraint] = {
                [textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                 textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                 footnoteLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                 footnoteLabel.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 28)]
        }()
        private lazy var BottomJyutpingConstraints: [NSLayoutConstraint] = {
                [textLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                 textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18),
                 footnoteLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
                 footnoteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)]
        }()
        private lazy var NoJyutpingConstraints: [NSLayoutConstraint] = {
                [textLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                 textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                 footnoteLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),
                 footnoteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)]
        }()

        private func updateFonts() {
                switch logogram {
                case 2:
                        textLabel.font = UIFont(name: "PingFang HK", size: 20) ?? .systemFont(ofSize: 20)
                case 3:
                        textLabel.font = UIFont(name: "PingFang TC", size: 20) ?? .systemFont(ofSize: 20)
                case 4:
                        textLabel.font = UIFont(name: "PingFang SC", size: 20) ?? .systemFont(ofSize: 20)
                default:
                        textLabel.font = UIFont(name: "SourceHanSansK-Regular", size: 20) ?? .systemFont(ofSize: 20)
                }
        }
}
