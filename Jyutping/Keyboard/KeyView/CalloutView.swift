import UIKit

final class CalloutView: UIView {

        let text: String
        private let header: String?
        private let footer: String?
        private let isPhoneInterface: Bool

        private let textLabel: UILabel = UILabel()
        private let headerLabel: UILabel = UILabel()
        private let footerLabel: UILabel = UILabel()

        init(text: String, header: String? = nil, footer: String? = nil, isPhoneInterface: Bool) {
                self.text = text
                self.header = header
                self.footer = footer
                self.isPhoneInterface = isPhoneInterface
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
                textLabel.font = isPhoneInterface ? .systemFont(ofSize: 20) : .systemFont(ofSize: 22)
                textLabel.textAlignment = .center
                textLabel.text = text
        }
        private func setupHeader() {
                addSubview(headerLabel)
                headerLabel.translatesAutoresizingMaskIntoConstraints = false
                let inset: CGFloat = isPhoneInterface ? 0 : 2
                NSLayoutConstraint.activate([
                        headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
                        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                        headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
                headerLabel.font = isPhoneInterface ? .systemFont(ofSize: 10) : .systemFont(ofSize: 11)
                headerLabel.text = header
                headerLabel.textColor = textLabel.textColor.withAlphaComponent(0.9)
                headerLabel.textAlignment = .center
        }
        private func setupFooter() {
                addSubview(footerLabel)
                footerLabel.translatesAutoresizingMaskIntoConstraints = false
                let inset: CGFloat = isPhoneInterface ? 0 : 2
                NSLayoutConstraint.activate([
                        footerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
                        footerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                        footerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
                ])
                footerLabel.font = isPhoneInterface ? .systemFont(ofSize: 9) : .systemFont(ofSize: 10)
                footerLabel.text = footer
                footerLabel.textColor = textLabel.textColor.withAlphaComponent(0.8)
                footerLabel.textAlignment = .center
        }
}
