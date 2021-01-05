import UIKit

final class CandidateCollectionViewCell: UICollectionViewCell {
        
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
                textLabel.adjustsFontForContentSizeCategory = true
                // textLabel.font = .preferredFont(forTextStyle: .title3)
                textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
                textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
                
                footnoteLabel.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(footnoteLabel)
                footnoteLabel.textAlignment = .center
                footnoteLabel.adjustsFontForContentSizeCategory = true
                footnoteLabel.font = .preferredFont(forTextStyle: .footnote)
                footnoteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
                footnoteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
                
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
                        let pingFangTC: UIFont = UIFont(name: "PingFang TC", size: 20) ?? .systemFont(ofSize: 20)
                        textLabel.font = UIFontMetrics(forTextStyle: .title3).scaledFont(for: pingFangTC)
                case 4:
                        let pingFangSC: UIFont = UIFont(name: "PingFang SC", size: 20) ?? .systemFont(ofSize: 20)
                        textLabel.font = UIFontMetrics(forTextStyle: .title3).scaledFont(for: pingFangSC)
                default:
                        let pingFangHK: UIFont = UIFont(name: "PingFang HK", size: 20) ?? .systemFont(ofSize: 20)
                        textLabel.font = UIFontMetrics(forTextStyle: .title3).scaledFont(for: pingFangHK)
                }
        }
}
