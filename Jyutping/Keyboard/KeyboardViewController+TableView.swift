import UIKit

struct Identifiers {
        static let CandidateCell: String = "CandidateCell"
        static let EmojiCell: String = "EmojiCell"
        static let SidebarCell: String = "SidebarCell"

        static let switchSettingsCell: String = "SettingsTableViewSwitchCell"
        static let selectionSettingsCell: String = "SettingsTableViewSelectionCell"
        static let clearLexiconSettingsCell: String = "SettingsTableViewClearLexiconCell"
}


extension KeyboardViewController: UITableViewDataSource, UITableViewDelegate {

        func numberOfSections(in tableView: UITableView) -> Int {
                return 8
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                let isPhone: Bool = {
                        switch traitCollection.userInterfaceIdiom {
                        case .phone, .unspecified:
                                return true
                        default:
                                return false
                        }
                }()
                switch section {
                case 0:
                        // Characters, Logogram
                        return 4
                case 1:
                        // Audio Feedback & Haptic Feedback
                        // iPad does not support haptic feedback
                        return isPhone ? 2 : 1
                case 2:
                        // Emoji Suggestions
                        return 1
                case 3:
                        // Keyboard Layouts (Arrangements)
                        // No TenKey keyboards for iPad
                        return isPhone ? 3 : 2
                case 4:
                        // Jyutping Display
                        return 3
                case 5:
                        // Jyutping Tones Display
                        return 4
                case 6:
                        // Space double tapping shortcut
                        return 4
                case 7:
                        // Clear User Lexicon
                        return 1
                default:
                        return 1
                }
        }

        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
                switch section {
                case 0:
                        return nil
                case 1:
                        return nil
                case 2:
                        return nil
                case 3:
                        return NSLocalizedString("Keyboard Layout", comment: .empty)
                case 4:
                        return NSLocalizedString("Jyutping Display", comment: .empty)
                case 5:
                        return NSLocalizedString("Jyutping Tones Display", comment: .empty)
                case 6:
                        return NSLocalizedString("Space Double Tapping Shortcut", comment: .empty)
                case 7:
                        return .zeroWidthSpace
                default:
                        return nil
                }
        }
        func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
                switch section {
                case 1:
                        guard !hasFullAccess else { return nil }
                        guard traitCollection.userInterfaceIdiom == .phone else { return nil }
                        return NSLocalizedString("Haptic Feedback requires Full Access", comment: .empty)
                default:
                        return nil
                }
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                switch indexPath.section {
                case 0:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.selectionSettingsCell, for: indexPath)
                        switch indexPath.row {
                        case 0:
                                cell.textLabel?.text = NSLocalizedString("Traditional Characters", comment: .empty)
                        case 1:
                                cell.textLabel?.text = NSLocalizedString("Traditional Characters, Hong Kong", comment: .empty)
                        case 2:
                                cell.textLabel?.text = NSLocalizedString("Traditional Characters, Taiwan", comment: .empty)
                        case 3:
                                cell.textLabel?.text = NSLocalizedString("Simplified Characters", comment: .empty)
                        default:
                                break
                        }
                        cell.accessoryType = Logogram.current.rawValue == (indexPath.row + 1) ? .checkmark : .none
                        return cell
                case 1:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.switchSettingsCell, for: indexPath)
                        cell.selectionStyle = .none
                        switch indexPath.row {
                        case 0:
                                cell.isUserInteractionEnabled = true
                                cell.textLabel?.isEnabled = true
                                cell.textLabel?.text = NSLocalizedString("Audio Feedback on Click", comment: .empty)
                                cell.accessoryView = UISwitch()
                                (cell.accessoryView as? UISwitch)?.isOn = AudioFeedback.isAudioFeedbackOn
                                (cell.accessoryView as? UISwitch)?.addTarget(self, action: #selector(handleAudioFeedbackSwitch), for: .valueChanged)
                        case 1:
                                cell.textLabel?.text = NSLocalizedString("Haptic Feedback on Click", comment: .empty)
                                cell.accessoryView = UISwitch()
                                if hasFullAccess {
                                        cell.isUserInteractionEnabled = true
                                        cell.textLabel?.isEnabled = true
                                        (cell.accessoryView as? UISwitch)?.isOn = isHapticFeedbackOn
                                        (cell.accessoryView as? UISwitch)?.addTarget(self, action: #selector(handleHapticFeedbackSwitch), for: .valueChanged)
                                } else {
                                        cell.isUserInteractionEnabled = false
                                        cell.textLabel?.isEnabled = false
                                        (cell.accessoryView as? UISwitch)?.isOn = false
                                        (cell.accessoryView as? UISwitch)?.isEnabled = false
                                }
                        default:
                                break
                        }
                        return cell
                case 2:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.switchSettingsCell, for: indexPath)
                        cell.selectionStyle = .none
                        cell.isUserInteractionEnabled = true
                        cell.textLabel?.isEnabled = true
                        cell.textLabel?.text = NSLocalizedString("Emoji Suggestions", comment: .empty)
                        cell.accessoryView = UISwitch()
                        (cell.accessoryView as? UISwitch)?.isOn = needsEmojiCandidates
                        (cell.accessoryView as? UISwitch)?.addTarget(self, action: #selector(handleEmojiCandidatesSwitch), for: .valueChanged)
                        return cell
                case 3:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.selectionSettingsCell, for: indexPath)
                        switch indexPath.row {
                        case 0:
                                cell.textLabel?.text = NSLocalizedString("QWERTY", comment: .empty)
                                cell.accessoryType = (keyboardLayout == .qwerty) ? .checkmark : .none
                        case 1:
                                cell.textLabel?.text = NSLocalizedString("SaamPing", comment: .empty)
                                cell.accessoryType = (keyboardLayout == .saamPing) ? .checkmark : .none
                        case 2:
                                cell.textLabel?.text = NSLocalizedString("10 Key", comment: .empty)
                                cell.accessoryType = (keyboardLayout == .tenKey) ? .checkmark : .none
                        default:
                                break
                        }
                        return cell
                case 4:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.selectionSettingsCell, for: indexPath)
                        switch indexPath.row {
                        case 0:
                                cell.textLabel?.text = NSLocalizedString("Above Candidates", comment: .empty)
                                cell.accessoryType = footnoteStyle < 2 ? .checkmark : .none
                        case 1:
                                cell.textLabel?.text = NSLocalizedString("Below Candidates", comment: .empty)
                                cell.accessoryType = footnoteStyle == 2 ? .checkmark : .none
                        case 2:
                                cell.textLabel?.text = NSLocalizedString("No Jyutpings", comment: .empty)
                                cell.accessoryType = footnoteStyle == 3 ? .checkmark : .none
                        default:
                                break
                        }
                        return cell
                case 5:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.selectionSettingsCell, for: indexPath)
                        switch indexPath.row {
                        case 0:
                                cell.textLabel?.text = NSLocalizedString("ToneDisplayStyle.Option1", comment: .empty)
                                cell.accessoryType = (toneStyle < 2) ? .checkmark : .none
                        case 1:
                                cell.textLabel?.text = NSLocalizedString("ToneDisplayStyle.Option2", comment: .empty)
                                cell.accessoryType = (toneStyle == 2) ? .checkmark : .none
                        case 2:
                                cell.textLabel?.text = NSLocalizedString("ToneDisplayStyle.Option3", comment: .empty)
                                cell.accessoryType = (toneStyle == 3) ? .checkmark : .none
                        case 3:
                                cell.textLabel?.text = NSLocalizedString("ToneDisplayStyle.Option4", comment: .empty)
                                cell.accessoryType = (toneStyle == 4) ? .checkmark : .none
                        default:
                                break
                        }
                        return cell
                case 6:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.selectionSettingsCell, for: indexPath)
                        switch indexPath.row {
                        case 0:
                                cell.textLabel?.text = NSLocalizedString("Insert a period", comment: .empty)
                                cell.accessoryType = doubleSpaceShortcut < 2 ? .checkmark : .none
                        case 1:
                                cell.textLabel?.text = NSLocalizedString("Insert an ideographic comma", comment: .empty)
                                cell.accessoryType = doubleSpaceShortcut == 3 ? .checkmark : .none
                        case 2:
                                cell.textLabel?.text = NSLocalizedString("Insert an ideographic space", comment: .empty)
                                cell.accessoryType = doubleSpaceShortcut == 4 ? .checkmark : .none
                        case 3:
                                cell.textLabel?.text = NSLocalizedString("No Double Space Shortcut", comment: .empty)
                                cell.accessoryType = doubleSpaceShortcut == 2 ? .checkmark : .none
                        default:
                                break
                        }
                        return cell
                case 7:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.clearLexiconSettingsCell, for: indexPath)
                        cell.textLabel?.text = NSLocalizedString("Clear User Lexicon", comment: .empty)
                        cell.textLabel?.textColor = .systemRed
                        cell.textLabel?.textAlignment = .center
                        return cell
                default:
                        return UITableViewCell()
                }
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                switch indexPath.section {
                case 0:
                        tableView.deselectRow(at: indexPath, animated: true)
                        let selected: Logogram = {
                                switch indexPath.row {
                                case 0: return .traditional
                                case 1: return .hongkong
                                case 2: return .taiwan
                                case 3: return .simplified
                                default: return .traditional
                                }
                        }()
                        Logogram.updateCurrent(to: selected)
                        triggerHapticFeedback()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                tableView.reloadData()
                        }
                case 1:
                        break
                case 2:
                        break
                case 3:
                        tableView.deselectRow(at: indexPath, animated: true)
                        let selectedLayout: KeyboardLayout = {
                                switch indexPath.row {
                                case 0: return .qwerty
                                case 1: return .saamPing
                                case 2: return .tenKey
                                default: return .qwerty
                                }
                        }()
                        updateKeyboardLayout(to: selectedLayout)
                        triggerHapticFeedback()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                tableView.reloadData()
                        }
                case 4:
                        tableView.deselectRow(at: indexPath, animated: true)
                        let value: Int = {
                                switch indexPath.row {
                                case 0: return 1
                                case 1: return 2
                                case 2: return 3
                                default: return 1
                                }
                        }()
                        updateFootnoteStyle(to: value)
                        triggerHapticFeedback()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                tableView.reloadData()
                        }
                case 5:
                        tableView.deselectRow(at: indexPath, animated: true)
                        let value: Int = {
                                switch indexPath.row {
                                case 0: return 1
                                case 1: return 2
                                case 2: return 3
                                case 3: return 4
                                default: return 1
                                }
                        }()
                        updateToneStyle(to: value)
                        triggerHapticFeedback()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                tableView.reloadData()
                        }
                case 6:
                        tableView.deselectRow(at: indexPath, animated: true)
                        let value: Int = {
                                switch indexPath.row {
                                case 0: return 1  // Full Stop
                                case 1: return 3  // Ideographic Comma
                                case 2: return 4  // Fullwidth Space
                                case 3: return 2  // None
                                default: return 1
                                }
                        }()
                        updateDoubleSpaceShortcut(to: value)
                        triggerHapticFeedback()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                tableView.reloadData()
                        }
                case 7:
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
                let newState: Bool = !AudioFeedback.isAudioFeedbackOn
                AudioFeedback.updateAudioFeedbackStatus(to: newState)
        }
        @objc private func handleHapticFeedbackSwitch() {
                let newState: Bool = !isHapticFeedbackOn
                updateHapticFeedbackStatus(to: newState)
        }

        @objc private func handleEmojiCandidatesSwitch() {
                let newState: Bool = !needsEmojiCandidates
                updateNeedsEmojiCandidates(to: newState)
        }
}
