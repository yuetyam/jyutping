import UIKit

extension KeyboardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
                return 1
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                return candidates.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                guard let cell: CandidateCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CandidateCell", for: indexPath) as? CandidateCollectionViewCell else {
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
                        let toneDigits: String = "123456"
                        cell.footnoteLabel.text = candidates[indexPath.row].footnote.filter { !toneDigits.contains($0) }
                case 3, 4, 5:
                        let footnote: String = candidates[indexPath.row].footnote
                        let attributed: NSAttributedString = attribute(text: footnote, toneStyle: toneStyle)
                        cell.footnoteLabel.attributedText = attributed
                default:
                        cell.footnoteLabel.text = candidates[indexPath.row].footnote
                }
                return cell
        }
        private func attribute(text: String, toneStyle: Int) -> NSAttributedString {
                let jyutpings: [String] = text.components(separatedBy: " ")
                let attributed: [NSMutableAttributedString] = jyutpings.map { (jyutping) -> NSMutableAttributedString in
                        guard let tone = jyutping.last else { return NSMutableAttributedString(string: jyutping) }
                        let offset: NSNumber = {
                                switch toneStyle {
                                case 3:
                                        return 3
                                case 4:
                                        return -3
                                default:
                                        return ("123".contains(tone)) ? 3 : -3
                                }
                        }()
                        let font: UIFont = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: .systemFont(ofSize: 10))
                        let newText = NSMutableAttributedString(string: jyutping)
                        newText.addAttribute(NSAttributedString.Key.font,
                                             value: font,
                                             range: NSRange(location: jyutping.count - 1, length: 1))
                        newText.addAttribute(NSAttributedString.Key.baselineOffset,
                                             value: offset,
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
                let candidate: Candidate = candidates[indexPath.row]
                textDocumentProxy.insertText(candidate.text)
                AudioFeedback.perform(audioFeedback: .modify)
                selectionFeedback?.selectionChanged()
                candidateSequence.append(candidate)
                currentInputText = String(currentInputText.dropFirst(candidate.input.count))
                if keyboardLayout == .candidateBoard && currentInputText.isEmpty {
                        collectionView.removeFromSuperview()
                        NSLayoutConstraint.deactivate(candidateBoardCollectionViewConstraints)
                        toolBar.reinit()
                        keyboardLayout = .jyutping
                }
                if currentInputText.isEmpty {
                        var combinedCandidate: Candidate = candidateSequence[0]
                        _ = candidateSequence.dropFirst().map { oneCandidate in
                                combinedCandidate += oneCandidate
                        }
                        candidateSequence = []
                        imeQueue.async {
                                self.lexiconManager.handle(candidate: combinedCandidate)
                        }
                }
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
                // FIXME: - don't know why
                guard candidates.count > indexPath.row else { return CGSize(width: 55, height: 55) }
                
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
                return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
}
