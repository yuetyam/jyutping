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
                textLabel.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(textLabel)
                textLabel.textAlignment = .center
                NSLayoutConstraint.activate([
                        textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                        textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
                ])
                footnoteLabel.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(footnoteLabel)
                footnoteLabel.textAlignment = .center
                footnoteLabel.font = .systemFont(ofSize: 13)
                NSLayoutConstraint.activate([
                        footnoteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                        footnoteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
                ])
                updateSubviews()
                updateFonts()
        }
        
        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
        
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
                [textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
                 textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                 footnoteLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                 footnoteLabel.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 22)]
        }()
        private lazy var BottomJyutpingConstraints: [NSLayoutConstraint] = {
                [textLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                 textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                 footnoteLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
                 footnoteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)]
        }()
        private lazy var NoJyutpingConstraints: [NSLayoutConstraint] = {
                [textLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                 textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                 footnoteLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
                 footnoteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)]
        }()
        
        private func updateFonts() {
                switch logogram {
                case 3:
                        textLabel.font = UIFont(name: "PingFang TC", size: 20) ?? .systemFont(ofSize: 20)
                case 4:
                        textLabel.font = UIFont(name: "PingFang SC", size: 20) ?? .systemFont(ofSize: 20)
                default:
                        textLabel.font = UIFont(name: "PingFang HK", size: 20) ?? .systemFont(ofSize: 20)
                }
        }
}
