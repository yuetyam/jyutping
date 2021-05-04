import UIKit

extension KeyboardViewController: UITableViewDataSource, UITableViewDelegate {

        func numberOfSections(in tableView: UITableView) -> Int {
                return footnoteStyle < 3 ? 6 : 5
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                switch section {
                case 0:
                        // Audio Feedback & Haptic Feedback
                        // iPad does not support haptic feedback
                        return traitCollection.userInterfaceIdiom == .phone ? 2 : 1
                case 1:
                        // Characters, Logogram, Fonts
                        return 4
                case 2:
                        // Keyboard Arrangement ("keyboard_layout")
                        return 2
                case 3:
                        // Jyutping Display
                        return 3
                case 4 where footnoteStyle < 3:
                        // Jyutping Tones Display
                        return 4
                case 4, 5:
                        // Clear User Lexicon
                        return 1
                default:
                        return 1
                }
        }

        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
                switch section {
                case 1:
                        return NSLocalizedString("Characters", comment: "")
                case 2:
                        return NSLocalizedString("Keyboard Layout", comment: "")
                case 3:
                        return NSLocalizedString("Jyutping Display", comment: "")
                case 4 where footnoteStyle < 3:
                        return NSLocalizedString("Jyutping Tones Display", comment: "")
                case 4, 5:
                        // Zero-width space
                        return "\u{200B}"
                default:
                        return nil
                }
        }
        func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
                switch section {
                case 0:
                        guard traitCollection.userInterfaceIdiom == .phone else { return nil }
                        if hasFullAccess {
                                return nil
                        } else {
                                return NSLocalizedString("Haptic Feedback requires Full Access", comment: "")
                        }
                default:
                        return nil
                }
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                switch indexPath.section {
                case 0:
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell", for: indexPath) as? SwitchTableViewCell else { return UITableViewCell() }
                        switch indexPath.row {
                        case 0:
                                cell.textLabel?.text = NSLocalizedString("Audio Feedback on Click", comment: "")
                                cell.switchView.isOn = UserDefaults.standard.bool(forKey: "audio_feedback")
                                cell.switchView.addTarget(self, action: #selector(handleAudioFeedbackSwitch), for: .valueChanged)
                        case 1:
                                cell.textLabel?.text = NSLocalizedString("Haptic Feedback on Click", comment: "")
                                if hasFullAccess {
                                        cell.switchView.isOn = isHapticFeedbackOn
                                        cell.switchView.addTarget(self, action: #selector(handleHapticFeedbackSwitch), for: .valueChanged)
                                } else {
                                        cell.switchView.isOn = false
                                        cell.switchView.isEnabled = false
                                        cell.textLabel?.isEnabled = false
                                        cell.isUserInteractionEnabled = false
                                }
                        default:
                                break
                        }
                        return cell

                case 1:
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharactersTableViewCell", for: indexPath) as? NormalTableViewCell else { return UITableViewCell() }
                        switch indexPath.row {
                        case 0:
                                cell.textLabel?.text = NSLocalizedString("Traditional", comment: "")
                                cell.accessoryType = logogram < 2 ? .checkmark : .none
                        case 1:
                                cell.textLabel?.text = NSLocalizedString("Traditional, Hong Kong", comment: "")
                                cell.accessoryType = logogram == 2 ? .checkmark : .none
                        case 2:
                                cell.textLabel?.text = NSLocalizedString("Traditional, Taiwan", comment: "")
                                cell.accessoryType = logogram == 3 ? .checkmark : .none
                        case 3:
                                cell.textLabel?.text = NSLocalizedString("Simplified", comment: "")
                                cell.accessoryType = logogram == 4 ? .checkmark : .none
                        default:
                                break
                        }
                        return cell

                case 2:
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: "KeyboardLayoutTableViewCell", for: indexPath) as? NormalTableViewCell else { return UITableViewCell() }
                        switch indexPath.row {
                        case 0:
                                cell.textLabel?.text = NSLocalizedString("QWERTY", comment: "")
                                cell.accessoryType = arrangement < 2 ? .checkmark : .none
                        case 1:
                                cell.textLabel?.text = NSLocalizedString("SaamPing", comment: "")
                                cell.accessoryType = arrangement == 2 ? .checkmark : .none
                        default:
                                break
                        }
                        return cell

                case 3:
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: "JyutpingTableViewCell", for: indexPath) as? NormalTableViewCell else { return UITableViewCell() }
                        switch indexPath.row {
                        case 0:
                                cell.textLabel?.text = NSLocalizedString("Above Candidates", comment: "")
                                cell.accessoryType = (footnoteStyle < 2) ? .checkmark : .none
                        case 1:
                                cell.textLabel?.text = NSLocalizedString("Below Candidates", comment: "")
                                cell.accessoryType = footnoteStyle == 2 ? .checkmark : .none
                        case 2:
                                cell.textLabel?.text = NSLocalizedString("No Jyutpings", comment: "")
                                cell.accessoryType = footnoteStyle == 3 ? .checkmark : .none
                        default:
                                break
                        }
                        return cell

                case 4 where footnoteStyle < 3:
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToneStyleTableViewCell", for: indexPath) as? NormalTableViewCell else { return UITableViewCell() }
                        switch indexPath.row {
                        case 0:
                                cell.textLabel?.text = NSLocalizedString("Normal : jyut6 ping3", comment: "")
                                cell.accessoryType = (toneStyle < 2) ? .checkmark : .none
                        case 1:
                                cell.textLabel?.text = NSLocalizedString("No Tones : jyut ping", comment: "")
                                cell.accessoryType = (toneStyle == 2) ? .checkmark : .none
                        case 2:
                                cell.textLabel?.text = NSLocalizedString("Superscript : jyut⁶ ping³", comment: "")
                                cell.accessoryType = (toneStyle == 3) ? .checkmark : .none
                        case 3:
                                cell.textLabel?.text = NSLocalizedString("Subscript : jyut₆ ping₃", comment: "")
                                cell.accessoryType = (toneStyle == 4) ? .checkmark : .none
                        default:
                                break
                        }
                        return cell

                case 4, 5:
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ClearLexiconTableViewCell", for: indexPath) as? NormalTableViewCell else { return UITableViewCell() }
                        cell.textLabel?.text = NSLocalizedString("Clear User Lexicon", comment: "")
                        cell.textLabel?.textColor = .systemRed
                        cell.textLabel?.textAlignment = .center
                        return cell

                default:
                        return UITableViewCell()
                }
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                switch indexPath.section {
                case 1:
                        tableView.deselectRow(at: indexPath, animated: true)
                        switch indexPath.row {
                        case 0:
                                UserDefaults.standard.set(1, forKey: "logogram")
                        case 1:
                                UserDefaults.standard.set(2, forKey: "logogram")
                        case 2:
                                UserDefaults.standard.set(3, forKey: "logogram")
                        case 3:
                                UserDefaults.standard.set(4, forKey: "logogram")
                        default:
                                break
                        }
                        triggerHapticFeedback()
                        updateConverter()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                tableView.reloadData()
                        }
                case 2:
                        tableView.deselectRow(at: indexPath, animated: true)
                        switch indexPath.row {
                        case 0:
                                UserDefaults.standard.set(1, forKey: "keyboard_layout")
                        case 1:
                                UserDefaults.standard.set(2, forKey: "keyboard_layout")
                        default:
                                break
                        }
                        triggerHapticFeedback()
                        updateArrangement()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                tableView.reloadData()
                        }
                case 3:
                        tableView.deselectRow(at: indexPath, animated: true)
                        switch indexPath.row {
                        case 0:
                                UserDefaults.standard.set(1, forKey: "jyutping_display")
                        case 1:
                                UserDefaults.standard.set(2, forKey: "jyutping_display")
                        case 2:
                                UserDefaults.standard.set(3, forKey: "jyutping_display")
                        default:
                                break
                        }
                        triggerHapticFeedback()
                        updateFootnoteStyle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                tableView.reloadData()
                        }
                case 4 where footnoteStyle < 3:
                        tableView.deselectRow(at: indexPath, animated: true)
                        switch indexPath.row {
                        case 0:
                                UserDefaults.standard.set(1, forKey: "tone_style")
                        case 1:
                                UserDefaults.standard.set(2, forKey: "tone_style")
                        case 2:
                                UserDefaults.standard.set(3, forKey: "tone_style")
                        case 3:
                                UserDefaults.standard.set(4, forKey: "tone_style")
                        default:
                                break
                        }
                        triggerHapticFeedback()
                        updateToneStyle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                tableView.reloadData()
                        }
                case 4, 5:
                        clearUserLexicon()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                                tableView.deselectRow(at: indexPath, animated: true)
                        }
                        guard let cell = tableView.cellForRow(at: indexPath) else { return }
                        let progressLayer: CAShapeLayer = CAShapeLayer()
                        progressLayer.path = CGPath(rect: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height), transform: nil)
                        progressLayer.fillColor = UIColor.clear.cgColor
                        progressLayer.strokeColor = UIColor.systemBlue.cgColor
                        progressLayer.strokeEnd = 0.0
                        progressLayer.lineWidth = 2
                        cell.layer.addSublayer(progressLayer)
                        let animation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
                        animation.fromValue = 0.0
                        animation.toValue = cell.frame.width / ((cell.frame.width + cell.frame.height) * 2)
                        animation.duration = 1.5
                        animation.timingFunction = CAMediaTimingFunction(name: .default)
                        progressLayer.add(animation, forKey: nil)
                default:
                        break
                }
        }

        @objc private func handleAudioFeedbackSwitch() {
                if UserDefaults.standard.bool(forKey: "audio_feedback") {
                        UserDefaults.standard.set(false, forKey: "audio_feedback")
                } else {
                        UserDefaults.standard.set(true, forKey: "audio_feedback")
                }
                AudioFeedback.updateAudioFeedbackStatus()
        }
        @objc private func handleHapticFeedbackSwitch() {
                if isHapticFeedbackOn {
                        UserDefaults.standard.set(false, forKey: "haptic_feedback")
                } else {
                        UserDefaults.standard.set(true, forKey: "haptic_feedback")
                }
                updateHapticFeedbackStatus()
        }
}

final class SwitchTableViewCell: UITableViewCell {

        let switchView: UISwitch = UISwitch()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
                super.init(style: .default, reuseIdentifier: "SwitchTableViewCell")
                selectionStyle = .none
                accessoryView = switchView
        }
        required init?(coder: NSCoder) { fatalError("SwitchTableViewCell.init(coder:) error") }
}
final class NormalTableViewCell: UITableViewCell {

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
                super.init(style: .default, reuseIdentifier: "NormalTableViewCell")
        }
        required init?(coder: NSCoder) { fatalError("NormalTableViewCell.init(coder:) error") }
}
