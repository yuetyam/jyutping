import UIKit

final class EmojiCell: UICollectionViewCell {

        let emojiLabel: UILabel = UILabel()

        override init(frame: CGRect) {
                super.init(frame: frame)
                self.addSubview(emojiLabel)
                emojiLabel.translatesAutoresizingMaskIntoConstraints = false
                emojiLabel.adjustsFontForContentSizeCategory = true
                emojiLabel.font = .preferredFont(forTextStyle: .title1)
                NSLayoutConstraint.activate([
                        emojiLabel.topAnchor.constraint(equalTo: topAnchor),
                        emojiLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                        emojiLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                        emojiLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
        }

        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
}

/*
final class EmojiCollectionViewHeader: UICollectionReusableView {

        let textLabel: UILabel = UILabel()

        override init(frame: CGRect) {
                super.init(frame: frame)
                textLabel.adjustsFontForContentSizeCategory = true
                textLabel.font = .preferredFont(forTextStyle: .body)
                addSubview(textLabel)
                textLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        textLabel.topAnchor.constraint(equalTo: topAnchor),
                        textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
        }

        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
}
*/
