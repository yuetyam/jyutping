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
                        case 1: return 461  // Smileys & People
                        case 2: return 199  // Animals & Nature
                        case 3: return 123  // Food & Drink
                        case 4: return 117  // Activity
                        case 5: return 128  // Travel & Places
                        case 6: return 217  // Objects
                        case 7: return 292  // Symbols
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
                if cell.footnoteStyle != self.footnoteStyle {
                        cell.shouldUpdateSubviews = true
                }
                if cell.logogram != self.logogram {
                        cell.shouldUpdateFonts = true
                }
                cell.textLabel.text = candidates[indexPath.row].text
                switch toneStyle {
                case 2:
                        cell.footnoteLabel.text = candidates[indexPath.row].jyutping.removedTones()
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
                cell.footnoteLabel.textColor = footnoteStyle == 3 ? .clear : textColor

                return cell
        }
        private func attribute(text: String, toneStyle: Int) -> NSAttributedString {
                let font: UIFont = .systemFont(ofSize: 10)
                let offset: NSNumber = toneStyle == 3 ? 2 : -2
                let jyutpings: [String] = text.components(separatedBy: " ")
                let attributed: [NSMutableAttributedString] = jyutpings.map { (jyutping) -> NSMutableAttributedString in
                        let newString: NSMutableAttributedString = NSMutableAttributedString(string: jyutping)
                        let range: NSRange = NSRange(location: newString.length - 1, length: 1)
                        newString.addAttribute(NSAttributedString.Key.font, value: font, range: range)
                        newString.addAttribute(NSAttributedString.Key.baselineOffset, value: offset, range: range)
                        return newString
                }
                guard let combined: NSMutableAttributedString = attributed.first else { return NSAttributedString(string: text) }
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

                switch inputText.first {
                case .none:
                        break
                case .some("r"), .some("v"), .some("x"):
                        if inputText.count == candidate.input.count + 1 {
                                inputText = ""
                        } else {
                                let first: String = String(inputText.first!)
                                let tail = inputText.dropFirst(candidate.input.count + 1)
                                inputText = first + tail
                        }
                default:
                        candidateSequence.append(candidate)
                        let inputCount: Int = {
                                if arrangement > 1 {
                                        return candidate.input.count
                                } else {
                                        let converted: String = candidate.input.replacingOccurrences(of: "4", with: "vv").replacingOccurrences(of: "5", with: "xx").replacingOccurrences(of: "6", with: "qq")
                                        return converted.count
                                }
                        }()
                        let leading = inputText.dropLast(inputText.count - inputCount)
                        let filtered = leading.replacingOccurrences(of: "'", with: "")
                        var tail: String.SubSequence = {
                                if filtered.count == leading.count {
                                        return inputText.dropFirst(inputCount)
                                } else {
                                        let separatorsCount: Int = leading.count - filtered.count
                                        return inputText.dropFirst(inputCount + separatorsCount)
                                }
                        }()
                        while tail.hasPrefix("'") {
                                tail = tail.dropFirst()
                        }
                        inputText = String(tail)
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
                guard footnoteStyle < 3 else {
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
                                        return CGSize(width: fullWidth - 4, height: 45)
                                }
                                return CGSize(width: fullWidth / CGFloat(itemCount), height: 45)
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
                                        return Int(fullWidth) / 45
                                case 2:
                                        return Int(fullWidth) / 75
                                case 3:
                                        return Int(fullWidth) / 100
                                case 4:
                                        return Int(fullWidth) / 125
                                default:
                                        return Int(fullWidth) / (characterCount * 30)
                                }
                        }
                        guard itemCount > 1 else {
                                return CGSize(width: fullWidth - 4, height: 55)
                        }
                        return CGSize(width: fullWidth / CGFloat(itemCount), height: 55)
                } else {
                        switch characterCount {
                        case 1:
                                return CGSize(width: 45, height: 60)
                        case 2:
                                return CGSize(width: 75, height: 60)
                        case 3:
                                return CGSize(width: 100, height: 60)
                        case 4:
                                return CGSize(width: 125, height: 60)
                        default:
                                return CGSize(width: characterCount * 30, height: 60)
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
                if collectionView == emojiCollectionView {
                        return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
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
