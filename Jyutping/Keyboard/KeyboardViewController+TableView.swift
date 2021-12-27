import UIKit

struct Identifiers {
        static let CandidateCell: String = "CandidateCell"
        static let EmojiCell: String = "EmojiCell"

        static let feedbacksSettingsCell: String = "SettingsTableViewFeedbacksCell"
        static let charactersSettingsCell: String = "SettingsTableViewCharactersCell"
        static let keyboardLayoutSettingsCell: String = "SettingsTableViewKeyboardLayoutCell"
        static let candidateFootnoteSettingsCell: String = "SettingsTableViewCandidateFootnoteCell"
        static let candidateToneStyleSettingsCell: String = "SettingsTableViewCandidateToneStyleCell"
        static let spaceShortcutSettingsCell: String = "SettingsTableViewSpaceShortcutCell"
        static let clearLexiconSettingsCell: String = "SettingsTableViewClearLexiconCell"
}


extension KeyboardViewController: UITableViewDataSource, UITableViewDelegate {

        func numberOfSections(in tableView: UITableView) -> Int {
                return footnoteStyle < 3 ? 7 : 6
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
                        // Keyboard Layouts
                        return 2
                case 3:
                        // Jyutping Display
                        return 3
                case 4 where footnoteStyle < 3:
                        // Jyutping Tones Display
                        return 4
                case 4 where footnoteStyle >= 3, 5 where footnoteStyle < 3:
                        // Space double tapping shortcut
                        return 4
                case 5 where footnoteStyle >= 3, 6:
                        // Clear User Lexicon
                        return 1
                default:
                        return 1
                }
        }

        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
                switch section {
                case 1:
                        return NSLocalizedString("Characters", comment: .empty)
                case 2:
                        return NSLocalizedString("Keyboard Layout", comment: .empty)
                case 3:
                        return NSLocalizedString("Jyutping Display", comment: .empty)
                case 4 where footnoteStyle < 3:
                        return NSLocalizedString("Jyutping Tones Display", comment: .empty)
                case 4 where footnoteStyle >= 3, 5 where footnoteStyle < 3:
                        return NSLocalizedString("Space Double Tapping Shortcut", comment: .empty)
                case 5 where footnoteStyle >= 3, 6:
                        return .zeroWidthSpace
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
                                return NSLocalizedString("Haptic Feedback requires Full Access", comment: .empty)
                        }
                default:
                        return nil
                }
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                switch indexPath.section {
                case 0:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.feedbacksSettingsCell, for: indexPath)
                        switch indexPath.row {
                        case 0:
                                cell.textLabel?.text = NSLocalizedString("Audio Feedback on Click", comment: .empty)
                                cell.accessoryView = UISwitch()
                                (cell.accessoryView as? UISwitch)?.isOn = AudioFeedback.isAudioFeedbackOn
                                (cell.accessoryView as? UISwitch)?.addTarget(self, action: #selector(handleAudioFeedbackSwitch), for: .valueChanged)
                        case 1:
                                cell.textLabel?.text = NSLocalizedString("Haptic Feedback on Click", comment: .empty)
                                cell.accessoryView = UISwitch()
                                if hasFullAccess {
                                        (cell.accessoryView as? UISwitch)?.isOn = isHapticFeedbackOn
                                        (cell.accessoryView as? UISwitch)?.addTarget(self, action: #selector(handleHapticFeedbackSwitch), for: .valueChanged)
                                } else {
                                        (cell.accessoryView as? UISwitch)?.isOn = false
                                        (cell.accessoryView as? UISwitch)?.isEnabled = false
                                        cell.textLabel?.isEnabled = false
                                        cell.isUserInteractionEnabled = false
                                }
                        default:
                                break
                        }
                        return cell
                case 1:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.charactersSettingsCell, for: indexPath)
                        switch indexPath.row {
                        case 0:
                                cell.textLabel?.text = NSLocalizedString("Traditional", comment: .empty)
                        case 1:
                                cell.textLabel?.text = NSLocalizedString("Traditional, Hong Kong", comment: .empty)
                        case 2:
                                cell.textLabel?.text = NSLocalizedString("Traditional, Taiwan", comment: .empty)
                        case 3:
                                cell.textLabel?.text = NSLocalizedString("Simplified", comment: .empty)
                        default:
                                break
                        }
                        cell.accessoryType = Logogram.current.rawValue == (indexPath.row + 1) ? .checkmark : .none
                        return cell

                case 2:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.keyboardLayoutSettingsCell, for: indexPath)
                        switch indexPath.row {
                        case 0:
                                cell.textLabel?.text = NSLocalizedString("QWERTY", comment: .empty)
                                cell.accessoryType = keyboardLayout < 2 ? .checkmark : .none
                        case 1:
                                cell.textLabel?.text = NSLocalizedString("SaamPing", comment: .empty)
                                cell.accessoryType = keyboardLayout == 2 ? .checkmark : .none
                        default:
                                break
                        }
                        return cell

                case 3:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.candidateFootnoteSettingsCell, for: indexPath)
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

                case 4 where footnoteStyle < 3:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.candidateToneStyleSettingsCell, for: indexPath)
                        switch indexPath.row {
                        case 0:
                                cell.textLabel?.text = NSLocalizedString("Normal : jyut6 ping3", comment: .empty)
                                cell.accessoryType = (toneStyle < 2) ? .checkmark : .none
                        case 1:
                                cell.textLabel?.text = NSLocalizedString("No Tones : jyut ping", comment: .empty)
                                cell.accessoryType = (toneStyle == 2) ? .checkmark : .none
                        case 2:
                                cell.textLabel?.text = NSLocalizedString("Superscript : jyut⁶ ping³", comment: .empty)
                                cell.accessoryType = (toneStyle == 3) ? .checkmark : .none
                        case 3:
                                cell.textLabel?.text = NSLocalizedString("Subscript : jyut₆ ping₃", comment: .empty)
                                cell.accessoryType = (toneStyle == 4) ? .checkmark : .none
                        default:
                                break
                        }
                        return cell
                case 4 where footnoteStyle >= 3, 5 where footnoteStyle < 3:
                        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.spaceShortcutSettingsCell, for: indexPath)
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
                case 5 where footnoteStyle >= 3, 6:
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
                case 1:
                        tableView.deselectRow(at: indexPath, animated: true)
                        switch indexPath.row {
                        case 0:
                                Logogram.changeCurrent(to: .traditional)
                        case 1:
                                Logogram.changeCurrent(to: .hongkong)
                        case 2:
                                Logogram.changeCurrent(to: .taiwan)
                        case 3:
                                Logogram.changeCurrent(to: .simplified)
                        default:
                                break
                        }
                        Logogram.updatePreference()
                        triggerHapticFeedback()
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
                        updateKeyboardLayout()
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
                case 4 where footnoteStyle >= 3, 5 where footnoteStyle < 3:
                        tableView.deselectRow(at: indexPath, animated: true)
                        switch indexPath.row {
                        case 0:
                                UserDefaults.standard.set(1, forKey: "double_space_shortcut")
                        case 1:
                                UserDefaults.standard.set(3, forKey: "double_space_shortcut")
                        case 2:
                                UserDefaults.standard.set(4, forKey: "double_space_shortcut")
                        case 3:
                                UserDefaults.standard.set(2, forKey: "double_space_shortcut")
                        default:
                                break
                        }
                        triggerHapticFeedback()
                        updateDoubleSpaceShortcut()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                tableView.reloadData()
                        }
                case 5 where footnoteStyle >= 3, 6:
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
