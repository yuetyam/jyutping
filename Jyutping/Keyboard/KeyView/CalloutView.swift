import UIKit

final class CalloutView: UIView {

        let text: String
        private let header: String?
        private let footer: String?

        private let textLabel: UILabel = UILabel()
        private let headerLabel: UILabel = UILabel()
        private let footerLabel: UILabel = UILabel()

        init(text: String, header: String? = nil, footer: String? = nil) {
                self.text = text
                self.header = header
                self.footer = footer
                super.init(frame: .zero)
                layer.cornerRadius = 5
                layer.cornerCurve = .continuous
                setupText()
                if header.hasContent {
                        setupHeader()
                }
                if footer.hasContent {
                        setupFooter()
                }
        }
        required init?(coder: NSCoder) { fatalError("CalloutView.init(coder:) error") }
        override var intrinsicContentSize: CGSize { return CGSize(width: 40, height: 40) }

        func setTextColor(_ color: UIColor) {
                textLabel.textColor = color
                headerLabel.textColor = color.withAlphaComponent(0.9)
                footerLabel.textColor = color.withAlphaComponent(0.8)
        }

        private func setupText() {
                addSubview(textLabel)
                textLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        textLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                        textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                        textLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
                textLabel.font = .systemFont(ofSize: 20)
                textLabel.textAlignment = .center
                textLabel.text = text
        }
        private func setupHeader() {
                addSubview(headerLabel)
                headerLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        headerLabel.topAnchor.constraint(equalTo: topAnchor),
                        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                        headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
                headerLabel.font = .systemFont(ofSize: 10)
                headerLabel.text = header
                headerLabel.textColor = textLabel.textColor.withAlphaComponent(0.9)
                headerLabel.textAlignment = .center
        }
        private func setupFooter() {
                addSubview(footerLabel)
                footerLabel.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                        footerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
                        footerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                        footerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
                footerLabel.font = .systemFont(ofSize: 9)
                footerLabel.text = footer
                footerLabel.textColor = textLabel.textColor.withAlphaComponent(0.8)
                footerLabel.textAlignment = .center
        }
}
