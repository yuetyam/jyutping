import UIKit

extension KeyboardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
                if collectionView == candidateCollectionView {
                        return 1
                } else {
                        return 8
                }
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                if collectionView == candidateCollectionView {
                        return candidates.count
                } else {
                        switch section {
                        case 0: return 454  // Smileys & People
                        case 1: return 199  // Animals & Nature
                        case 2: return 123  // Food & Drink
                        case 3: return 117  // Activity
                        case 4: return 128  // Travel & Places
                        case 5: return 217  // Objects
                        case 6: return 290  // Symbols
                        case 7: return 259  // Flags
                        default: return 0
                        }
                }
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                guard collectionView == candidateCollectionView else {
                        guard let cell: EmojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as? EmojiCell else {
                                return UICollectionViewCell()
                        }
                        cell.emojiLabel.text = String(Emoji.emojis[indexPath.section][indexPath.row])
                        return cell
                }

                guard let cell: CandidateCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CandidateCell", for: indexPath) as? CandidateCell else {
                        return UICollectionViewCell()
                }
                if cell.jyutpingDisplay != self.jyutpingDisplay {
                        cell.shouldUpdateSubviews = true
                }
                if cell.logogram != self.logogram {
                        cell.shouldUpdateFonts = true
                }
                cell.textLabel.text = candidates[indexPath.row].text
                switch toneStyle {
                case 2:
                        cell.footnoteLabel.text = candidates[indexPath.row].jyutping.filter { !$0.isNumber }
                case 3, 4:
                        let footnote: String = candidates[indexPath.row].jyutping
                        let attributed: NSAttributedString = attribute(text: footnote, toneStyle: toneStyle)
                        cell.footnoteLabel.attributedText = attributed
                default:
                        cell.footnoteLabel.text = candidates[indexPath.row].jyutping
                }

                // REASON: In some apps (like QQ), may not showing the correct default colors
                cell.textLabel.textColor = isDarkAppearance ? .white : .black

                return cell
        }
        private func attribute(text: String, toneStyle: Int) -> NSAttributedString {
                let jyutpings: [String] = text.components(separatedBy: " ")
                let attributed: [NSMutableAttributedString] = jyutpings.map { (jyutping) -> NSMutableAttributedString in
                        let font: UIFont = .systemFont(ofSize: 10)
                        let newText = NSMutableAttributedString(string: jyutping)
                        newText.addAttribute(NSAttributedString.Key.font,
                                             value: font,
                                             range: NSRange(location: jyutping.count - 1, length: 1))
                        newText.addAttribute(NSAttributedString.Key.baselineOffset,
                                             value: toneStyle == 3 ? 3 : -3,
                                             range: NSRange(location: jyutping.count - 1, length: 1))
                        return newText
                }
                guard !attributed.isEmpty else { return NSAttributedString(string: text) }
                let combined: NSMutableAttributedString = attributed[0]
                if attributed.count > 1 {
                        for number in 1..<attributed.count {
                                combined.append(NSAttributedString(string: " "))
                                combined.append(attributed[number])
                        }
                }
                return combined
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                guard collectionView == candidateCollectionView else {
                        textDocumentProxy.insertText(String(Emoji.emojis[indexPath.section][indexPath.row]))
                        hapticFeedback?.impactOccurred()
                        AudioFeedback.perform(.input)
                        return
                }

                let candidate: Candidate = candidates[indexPath.row]
                textDocumentProxy.insertText(candidate.text)
                AudioFeedback.perform(.modify)
                if inputText.hasPrefix("r") {
                        if inputText == "r" + candidate.input {
                                inputText = ""
                        } else {
                                inputText = "r" + processingText.dropFirst(candidate.input.count + 1)
                        }
                } else if inputText.hasPrefix("v") {
                        if inputText == "v" + candidate.input {
                                inputText = ""
                        } else {
                                inputText = "v" + processingText.dropFirst(candidate.input.count + 1)
                        }
                } else {
                        candidateSequence.append(candidate)
                        inputText = String(processingText.dropFirst(candidate.input.count))
                }
                if keyboardLayout == .candidateBoard && inputText.isEmpty {
                        collectionView.removeFromSuperview()
                        NSLayoutConstraint.deactivate(candidateBoardCollectionViewConstraints)
                        toolBar.reinit()
                        keyboardLayout = .cantonese(.lowercased)
                }
                if inputText.isEmpty && !candidateSequence.isEmpty {
                        let concatenatedCandidate: Candidate = candidateSequence.joined()
                        candidateSequence = []
                        imeQueue.async {
                                self.lexiconManager?.handle(candidate: concatenatedCandidate)
                        }
                }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                guard collectionView == candidateCollectionView else {
                        return CGSize(width: 42, height: 42)
                }
                let characterCount: Int = candidates[indexPath.row].text.count
                if self.keyboardLayout == .candidateBoard {
                        let fullWidth: CGFloat = collectionView.bounds.size.width
                        var itemCount: Int {
                                switch characterCount {
                                case 0:
                                        return 1
                                case 1:
                                        return Int(fullWidth) / 50
                                case 2:
                                        return Int(fullWidth) / 80
                                case 3:
                                        return Int(fullWidth) / 120
                                case 4:
                                        return Int(fullWidth) / 140
                                default:
                                        return Int(fullWidth) / (characterCount * 35)
                                }
                        }
                        guard itemCount > 1 else {
                                return CGSize(width: fullWidth - 4, height: 55)
                        }
                        return CGSize(width: fullWidth / CGFloat(itemCount), height: 55)
                } else {
                        switch characterCount {
                        case 1:
                                return CGSize(width: 50, height: 55)
                        case 2:
                                return CGSize(width: 80, height: 55)
                        case 3:
                                return CGSize(width: 120, height: 55)
                        case 4:
                                return CGSize(width: 140, height: 55)
                        default:
                                return CGSize(width: characterCount * 35, height: 55)
                        }
                }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
                return 0
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
                return 0
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
                if collectionView == self.emojiCollectionView {
                        return UIEdgeInsets(top: 4, left: 8, bottom: 0, right: 8)
                } else {
                        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                }
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
                let visibleCount: Int = emojiCollectionView.visibleCells.count
                guard visibleCount > 0 else { return }
                let medium: Int = visibleCount / 2
                let mediumCell = emojiCollectionView.visibleCells[medium]
                guard let indexPath = emojiCollectionView.indexPath(for: mediumCell) else { return }
                _ = emojiBoard.indicatorsStackView.arrangedSubviews.map({ $0.tintColor = .systemGray })
                emojiBoard.indicatorsStackView.arrangedSubviews[indexPath.section].tintColor = isDarkAppearance ? .white : .black
        }
}
