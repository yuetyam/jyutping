import UIKit

final class CandidateCollectionViewCell: UICollectionViewCell {
        
        let textLabel: UILabel = UILabel()
        let footnoteLabel: UILabel = UILabel()
        
        override init(frame: CGRect) {
                super.init(frame: frame)
                textLabel.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(textLabel)
                textLabel.textAlignment = .center
                textLabel.adjustsFontForContentSizeCategory = true
                textLabel.font = .preferredFont(forTextStyle: .title3)
                textLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
                textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
                textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
                textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
                
                footnoteLabel.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(footnoteLabel)
                footnoteLabel.textAlignment = .center
                footnoteLabel.adjustsFontForContentSizeCategory = true
                footnoteLabel.font = .preferredFont(forTextStyle: .caption2)
                footnoteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
                footnoteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
                footnoteLabel.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20).isActive = true
                footnoteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }
        
        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
        
        override func prepareForReuse() {
                super.prepareForReuse()
                self.textLabel.text = nil
        }
}
