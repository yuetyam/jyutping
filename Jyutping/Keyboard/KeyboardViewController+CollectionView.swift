import UIKit

extension KeyboardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

        func numberOfSections(in collectionView: UICollectionView) -> Int {
                if collectionView == candidateCollectionView {
                        return 1
                } else {
                        return 9
                }
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                if collectionView == candidateCollectionView {
                        return candidates.count
                } else {
                        switch section {
                        case 0: return frequentEmojis.count
                        case 1: return 454  // Smileys & People
                        case 2: return 199  // Animals & Nature
                        case 3: return 123  // Food & Drink
                        case 4: return 117  // Activity
                        case 5: return 128  // Travel & Places
                        case 6: return 217  // Objects
                        case 7: return 290  // Symbols
                        case 8: return 259  // Flags
                        default: return 0
                        }
                }
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                guard collectionView == candidateCollectionView else {
                        guard let cell: EmojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as? EmojiCell else {
                                return UICollectionViewCell()
                        }
                        switch indexPath.section {
                        case 0:
                                let start: String.Index = frequentEmojis.startIndex
                                let index: String.Index = frequentEmojis.index(start, offsetBy: indexPath.row)
                                cell.emojiLabel.text = String(frequentEmojis[index])
                        default:
                                let emoji: Character = Emoji.emojis[indexPath.section - 1][indexPath.row]
                                cell.emojiLabel.text = String(emoji)
                        }
                        return cell
                }

                // FIXME: - Don't know why
                guard candidates.count > indexPath.row else { return UICollectionViewCell() }

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
                        cell.footnoteLabel.text = candidates[indexPath.row].jyutping.removeTones()
                case 3, 4:
                        let footnote: String = candidates[indexPath.row].jyutping
                        let attributed: NSAttributedString = attribute(text: footnote, toneStyle: toneStyle)
                        cell.footnoteLabel.attributedText = attributed
                default:
                        cell.footnoteLabel.text = candidates[indexPath.row].jyutping
                }

                // REASON: In some apps (like QQ), the cell may not showing the correct default colors
                let textColor: UIColor = isDarkAppearance ? .white : .black
                cell.textLabel.textColor = textColor
                cell.footnoteLabel.textColor = jyutpingDisplay == 3 ? .clear : textColor

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
                        guard let cell: EmojiCell = collectionView.cellForItem(at: indexPath) as? EmojiCell else { return }
                        let emoji: String = cell.emojiLabel.text ?? "😀"
                        insert(emoji)
                        triggerHapticFeedback()
                        updateFrequentEmojis(latest: emoji)
                        return
                }
                let candidate: Candidate = candidates[indexPath.row]
                output(candidate.text)
                AudioFeedback.perform(.modify)
                if inputText.hasPrefix("r") {
                        if inputText == "r" + candidate.input {
                                inputText = ""
                        } else {
                                let tail = inputText.dropFirst(candidate.input.count + 1)
                                inputText = "r" + tail
                        }
                } else if inputText.hasPrefix("v") {
                        if inputText == "v" + candidate.input {
                                inputText = ""
                        } else {
                                let tail = inputText.dropFirst(candidate.input.count + 1)
                                inputText = "v" + tail
                        }
                } else {
                        candidateSequence.append(candidate)
                        if arrangement < 2 {
                                let converted: String = candidate.input.replacingOccurrences(of: "4", with: "vv").replacingOccurrences(of: "5", with: "xx").replacingOccurrences(of: "6", with: "qq")
                                let tail = inputText.dropFirst(converted.count)
                                inputText = (tail == "'") ? "" : String(tail)
                        } else {
                                let tail = inputText.dropFirst(candidate.input.count)
                                inputText = (tail == "'") ? "" : String(tail)
                        }
                }
                if keyboardLayout == .candidateBoard && inputText.isEmpty {
                        collectionView.removeFromSuperview()
                        NSLayoutConstraint.deactivate(candidateBoardCollectionViewConstraints)
                        toolBar.reset()
                        keyboardLayout = .cantonese(.lowercased)
                }
                if inputText.isEmpty && !candidateSequence.isEmpty {
                        let concatenatedCandidate: Candidate = candidateSequence.joined()
                        candidateSequence = []
                        handleLexicon(concatenatedCandidate)
                }
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                guard collectionView == candidateCollectionView else {
                        return CGSize(width: 42, height: 42)
                }
                let characterCount: Int = candidates[indexPath.row].text.count
                guard jyutpingDisplay < 3 else {
                        if keyboardLayout == .candidateBoard {
                                let fullWidth: CGFloat = collectionView.bounds.size.width
                                var itemCount: Int {
                                        switch characterCount {
                                        case 0:
                                                return 1
                                        case 1:
                                                return Int(fullWidth) / 40
                                        case 2:
                                                return Int(fullWidth) / 60
                                        case 3:
                                                return Int(fullWidth) / 80
                                        case 4:
                                                return Int(fullWidth) / 100
                                        default:
                                                return Int(fullWidth) / (characterCount * 24)
                                        }
                                }
                                guard itemCount > 1 else {
                                        return CGSize(width: fullWidth - 4, height: 60)
                                }
                                return CGSize(width: fullWidth / CGFloat(itemCount), height: 60)
                        } else {
                                switch characterCount {
                                case 1:
                                        return CGSize(width: 40, height: 60)
                                case 2:
                                        return CGSize(width: 60, height: 60)
                                case 3:
                                        return CGSize(width: 80, height: 60)
                                case 4:
                                        return CGSize(width: 100, height: 60)
                                default:
                                        return CGSize(width: characterCount * 24, height: 60)
                                }
                        }
                }
                if keyboardLayout == .candidateBoard {
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
                                return CGSize(width: fullWidth - 4, height: 60)
                        }
                        return CGSize(width: fullWidth / CGFloat(itemCount), height: 60)
                } else {
                        switch characterCount {
                        case 1:
                                return CGSize(width: 50, height: 60)
                        case 2:
                                return CGSize(width: 80, height: 60)
                        case 3:
                                return CGSize(width: 120, height: 60)
                        case 4:
                                return CGSize(width: 140, height: 60)
                        default:
                                return CGSize(width: characterCount * 35, height: 60)
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
                _ = emojiBoard.indicatorsStackView.arrangedSubviews.map { $0.tintColor = .systemGray }
                emojiBoard.indicatorsStackView.arrangedSubviews[indexPath.section].tintColor = isDarkAppearance ? .white : .black
        }
}
