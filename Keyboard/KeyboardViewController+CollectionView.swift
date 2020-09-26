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
                cell.textLabel.text = candidates[indexPath.row].text
                switch toneStyle {
                case 2:
                        cell.footnoteLabel.font = .preferredFont(forTextStyle: .footnote)
                        let toneDigits: String = "123456"
                        cell.footnoteLabel.text = candidates[indexPath.row].footnote.filter { !toneDigits.contains($0) }
                case 3:
                        cell.footnoteLabel.font = .preferredFont(forTextStyle: .subheadline)
                        cell.footnoteLabel.text = superscriptText(from: candidates[indexPath.row].footnote)
                case 4:
                        cell.footnoteLabel.font = .preferredFont(forTextStyle: .subheadline)
                        cell.footnoteLabel.text = subscriptText(from: candidates[indexPath.row].footnote)
                case 5:
                        cell.footnoteLabel.font = .preferredFont(forTextStyle: .subheadline)
                        cell.footnoteLabel.text = mixYamYeung(from: candidates[indexPath.row].footnote)
                default:
                        cell.footnoteLabel.font = .preferredFont(forTextStyle: .footnote)
                        cell.footnoteLabel.text = candidates[indexPath.row].footnote
                }
                return cell
        }
        private func superscriptText(from text: String) -> String {
                return text.replacingOccurrences(of: "1", with: "¹")
                        .replacingOccurrences(of: "2", with: "²")
                        .replacingOccurrences(of: "3", with: "³")
                        .replacingOccurrences(of: "4", with: "⁴")
                        .replacingOccurrences(of: "5", with: "⁵")
                        .replacingOccurrences(of: "6", with: "⁶")
        }
        private func subscriptText(from text: String) -> String {
                return text.replacingOccurrences(of: "1", with: "₁")
                        .replacingOccurrences(of: "2", with: "₂")
                        .replacingOccurrences(of: "3", with: "₃")
                        .replacingOccurrences(of: "4", with: "₄")
                        .replacingOccurrences(of: "5", with: "₅")
                        .replacingOccurrences(of: "6", with: "₆")
        }
        private func mixYamYeung(from text: String) -> String {
                return text.replacingOccurrences(of: "1", with: "¹")
                        .replacingOccurrences(of: "2", with: "²")
                        .replacingOccurrences(of: "3", with: "³")
                        .replacingOccurrences(of: "4", with: "₄")
                        .replacingOccurrences(of: "5", with: "₅")
                        .replacingOccurrences(of: "6", with: "₆")
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                let candidate: Candidate = candidates[indexPath.row]
                textDocumentProxy.insertText(candidate.text)
                AudioFeedback.perform(audioFeedback: .modify)
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
                                        return Int(fullWidth) / 60
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
                                return CGSize(width: 60, height: 55)
                        case 2:
                                return CGSize(width: 85, height: 55)
                        case 3:
                                return CGSize(width: 125, height: 55)
                        case 4:
                                return CGSize(width: 145, height: 55)
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
