import UIKit

final class CalloutView: UIView {

        let text: String
        private let header: String?
        private let footer: String?
        private let alignments: (header: Alignment, footer: Alignment)

        init(text: String,
             header: String? = nil,
             footer: String? = nil,
             alignments: (header: Alignment, footer: Alignment) = (header: .center, footer: .center)) {
                self.text = text
                self.header = header
                self.footer = footer
                self.alignments = alignments
                super.init(frame: .zero)
                layer.cornerRadius = 5
                layer.cornerCurve = .continuous
                setupHeader()
                setupFooter()
                setupText()
        }
        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }

        override var intrinsicContentSize: CGSize { return CGSize(width: 40, height: 40) }

        private func setupHeader() {
                let headerLabel: UILabel = UILabel()
                addSubview(headerLabel)
                headerLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        headerLabel.topAnchor.constraint(equalTo: topAnchor),
                        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                        headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
                headerLabel.font = .systemFont(ofSize: 11)
                headerLabel.text = header
                switch alignments.header {
                case .center:
                        headerLabel.textAlignment = .center
                case .left:
                        headerLabel.textAlignment = .left
                case .right:
                        headerLabel.textAlignment = .right
                }
        }
        private func setupFooter() {
                let footerLabel: UILabel = UILabel()
                addSubview(footerLabel)
                footerLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        footerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                        footerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                        footerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
                footerLabel.font = .systemFont(ofSize: 9)
                footerLabel.text = footer
                switch alignments.footer {
                case .center:
                        footerLabel.textAlignment = .center
                case .left:
                        footerLabel.textAlignment = .left
                case .right:
                        footerLabel.textAlignment = .right
                }
        }
        private func setupText() {
                let textLabel: UILabel = UILabel()
                addSubview(textLabel)
                textLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
                textLabel.font = .systemFont(ofSize: 17)
                textLabel.textAlignment = .center
                textLabel.text = text
        }
}
