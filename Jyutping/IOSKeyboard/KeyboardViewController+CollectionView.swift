import UIKit

extension KeyboardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

        func numberOfSections(in collectionView: UICollectionView) -> Int {
                switch collectionView {
                case candidateCollectionView:
                        return 1
                case emojiCollectionView:
                        return 9
                case sidebarCollectionView:
                        return 1
                default:
                        return 1
                }
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                if collectionView == candidateCollectionView {
                        return candidates.count
                } else if collectionView == sidebarCollectionView {
                        return 20
                } else {
                        switch section {
                        case 0: return Emoji.frequent.count
                        case 1: return Emoji.sequences[0].count  // 480 Smileys & People
                        case 2: return Emoji.sequences[1].count  // 204 Animals & Nature
                        case 3: return Emoji.sequences[2].count  // 126 Food & Drink
                        case 4: return Emoji.sequences[3].count  // 118 Activity
                        case 5: return Emoji.sequences[4].count  // 131 Travel & Places
                        case 6: return Emoji.sequences[5].count  // 222 Objects
                        case 7: return Emoji.sequences[6].count  // 293 Symbols
                        case 8: return Emoji.sequences[7].count  // 259 Flags
                        default: return 0
                        }
                }
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                guard collectionView != emojiCollectionView else {
                        guard let cell: EmojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.EmojiCell, for: indexPath) as? EmojiCell else {
                                return UICollectionViewCell()
                        }
                        switch indexPath.section {
                        case 0:
                                let start: String.Index = Emoji.frequent.startIndex
                                let index: String.Index = Emoji.frequent.index(start, offsetBy: indexPath.row)
                                cell.emojiLabel.text = String(Emoji.frequent[index])
                        default:
                                let emoji: String = Emoji.sequences[indexPath.section - 1][indexPath.row]
                                cell.emojiLabel.text = emoji
                        }
                        return cell
                }
                guard collectionView != sidebarCollectionView else {
                        guard let cell: SidebarCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.SidebarCell, for: indexPath) as? SidebarCell else { return UICollectionViewCell() }
                        switch indexPath.row {
                        case 0:
                                cell.textLabel.text = "👍"
                        case 1:
                                cell.textLabel.text = "好"
                        case 2:
                                cell.textLabel.text = "ping"
                        case 3:
                                cell.textLabel.text = "?"
                        case 4...8:
                                let emoji: String = Emoji.sequences[0][indexPath.row]
                                cell.textLabel.text = emoji
                        default:
                                cell.textLabel.text = "row \(indexPath.row)"
                        }
                        return cell
                }

                // FIXME: - Don't know why
                guard candidates.count > indexPath.row else { return UICollectionViewCell() }

                guard let cell: CandidateCell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CandidateCell, for: indexPath) as? CandidateCell else {
                        return UICollectionViewCell()
                }
                if cell.footnoteStyle != self.footnoteStyle {
                        cell.shouldUpdateSubviews = true
                }
                if cell.logogram != Logogram.current {
                        cell.shouldUpdateFonts = true
                }
                cell.textLabel.text = candidates[indexPath.row].text
                switch toneStyle {
                case 2:
                        cell.footnoteLabel.text = candidates[indexPath.row].romanization.removedTones()
                case 3, 4:
                        let footnote: String = candidates[indexPath.row].romanization
                        let attributed: NSAttributedString = attribute(text: footnote, toneStyle: toneStyle)
                        cell.footnoteLabel.attributedText = attributed
                default:
                        cell.footnoteLabel.text = candidates[indexPath.row].romanization
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
                let jyutpings: [String] = text.components(separatedBy: String.space)
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
                                combined.append(NSAttributedString(string: .space))
                                combined.append(attributed[number])
                        }
                }
                return combined
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                guard collectionView != emojiCollectionView else {
                        guard let cell: EmojiCell = collectionView.cellForItem(at: indexPath) as? EmojiCell else { return }
                        let emoji: String = cell.emojiLabel.text ?? "😀"
                        textDocumentProxy.insertText(emoji)
                        triggerHapticFeedback()
                        AudioFeedback.perform(.input)
                        Emoji.updateFrequentEmojis(latest: emoji)
                        return
                }
                guard collectionView != sidebarCollectionView else {
                        insert("\(indexPath.row)")
                        return
                }
                let candidate: Candidate = candidates[indexPath.row]
                operate(.select(candidate))
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                guard collectionView != emojiCollectionView else {
                        return CGSize(width: 42, height: 42)
                }
                guard collectionView != sidebarCollectionView else {
                        return CGSize(width: 500, height: 40)
                }

                let characterCount: Int = candidates[indexPath.row].text.count
                guard footnoteStyle < 3 else {
                        if keyboardIdiom == .candidates {
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
                if keyboardIdiom == .candidates {
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

        // not well
        /*
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
                let visibleCount: Int = emojiCollectionView.visibleCells.count
                guard visibleCount > 0 else { return }
                let medium: Int = visibleCount / 2
                let mediumCell = emojiCollectionView.visibleCells[medium]
                guard let indexPath = emojiCollectionView.indexPath(for: mediumCell) else { return }
                _ = emojiBoard.indicatorsStackView.arrangedSubviews.map { $0.tintColor = .systemGray }
                emojiBoard.indicatorsStackView.arrangedSubviews[indexPath.section].tintColor = isDarkAppearance ? .white : .black
        }
        */
}
