import UIKit

extension KeyboardViewController: UITableViewDataSource, UITableViewDelegate {
        
        func numberOfSections(in tableView: UITableView) -> Int {
                4
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                switch section {
                case 0:
                        return 1
                case 1:
                        return 4
                case 2:
                        return 5
                case 3:
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
                        return NSLocalizedString("Jyutping Tones Display", comment: "")
                case 3:
                        // Zero-width space
                        return "\u{200B}"
                default:
                        return nil
                }
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                switch indexPath.section {
                case 0:
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell", for: indexPath) as? SwitchTableViewCell {
                                cell.switchView.isOn = UserDefaults.standard.bool(forKey: "audio_feedback")
                                cell.switchView.addTarget(self, action: #selector(handleAudioFeedbackSwitch), for: .allTouchEvents)
                                cell.textLabel?.text = NSLocalizedString("Audio feedback on click", comment: "")
                                return cell
                        }
                case 1:
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "CharactersTableViewCell", for: indexPath) as? NormalTableViewCell {
                                let logogram: Int = UserDefaults.standard.integer(forKey: "logogram")
                                switch indexPath.row {
                                case 0:
                                        cell.textLabel?.text = NSLocalizedString("Traditional", comment: "")
                                        cell.accessoryType = (logogram == 0 || logogram == 1) ? .checkmark : .none
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
                                        cell.textLabel?.text = "__error__"
                                }
                                return cell
                        }
                case 2:
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "ToneStyleTableViewCell", for: indexPath) as? NormalTableViewCell {
                                switch indexPath.row {
                                case 0:
                                        cell.textLabel?.text = NSLocalizedString("Normal : jyut6 ping3", comment: "")
                                        cell.accessoryType = (toneStyle == 0 || toneStyle == 1) ? .checkmark : .none
                                case 1:
                                        cell.textLabel?.text = NSLocalizedString("No Tones : jyut ping", comment: "")
                                        cell.accessoryType = (toneStyle == 2) ? .checkmark : .none
                                case 2:
                                        cell.textLabel?.text = NSLocalizedString("Superscript : jyut⁶ ping³", comment: "")
                                        cell.accessoryType = (toneStyle == 3) ? .checkmark : .none
                                case 3:
                                        cell.textLabel?.text = NSLocalizedString("Subscript : jyut₆ ping₃", comment: "")
                                        cell.accessoryType = (toneStyle == 4) ? .checkmark : .none
                                case 4:
                                        cell.textLabel?.text = NSLocalizedString("Mix : jyut₆ ping³", comment: "")
                                        cell.accessoryType = (toneStyle == 5) ? .checkmark : .none
                                default:
                                        cell.textLabel?.text = "__error__"
                                }
                                return cell
                        }
                case 3:
                        if let cell = tableView.dequeueReusableCell(withIdentifier: "ClearLexiconTableViewCell", for: indexPath) as? NormalTableViewCell {
                                cell.textLabel?.text = NSLocalizedString("Clear user lexicon", comment: "")
                                cell.textLabel?.textColor = .systemRed
                                cell.textLabel?.textAlignment = .center
                                return cell
                        }
                default:
                        return UITableViewCell()
                }
                return UITableViewCell()
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
                        updateConverter()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                tableView.reloadData()
                        }
                case 2:
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
                        case 4:
                                UserDefaults.standard.set(5, forKey: "tone_style")
                        default:
                                break
                        }
                        updateToneStyle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                tableView.reloadData()
                        }
                case 3:
                        imeQueue.async {
                                self.lexiconManager.deleteAll()
                        }
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
        }
}

final class SwitchTableViewCell: UITableViewCell {
        
        let switchView: UISwitch = UISwitch()
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
                super.init(style: .default, reuseIdentifier: "SwitchTableViewCell")
                selectionStyle = .none
                accessoryView = switchView
        }
        
        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
}
final class NormalTableViewCell: UITableViewCell {
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
                super.init(style: .default, reuseIdentifier: "NormalTableViewCell")
        }
        
        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
}
