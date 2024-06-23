import UIKit
import CommonExtensions

extension UITextDocumentProxy {

        /// Clear(delete) the text to the left of the cursor.
        func clearAllText() {
                if selectedText != nil {
                        deleteBackward()
                }
                if let textCount = documentContextBeforeInput?.count, textCount > 0 {
                        for _ in 0..<textCount {
                                deleteBackward()
                        }
                }
        }

        /// Copy all text to the system clipboard.
        /// - Returns: Did copy text to the system clipboard?
        func copyAllText() -> Bool {
                let head: String = documentContextBeforeInput ?? String.empty
                let selected: String = selectedText ?? String.empty
                let tail: String = documentContextAfterInput ?? String.empty
                let text: String = head + selected + tail
                guard text.isNotEmpty else { return false }
                UIPasteboard.general.string = text
                return true
        }

        /// Copy all text to the system clipboard, and clear the text-entry object content.
        /// - Returns: Did copy text to the system clipboard?
        func cutAllText() -> Bool {
                if selectedText != nil {
                        adjustTextPosition(byCharacterOffset: 1)
                }
                let head: String = documentContextBeforeInput ?? String.empty
                let tail: String = documentContextAfterInput ?? String.empty
                if head.isNotEmpty {
                        for _ in 0..<head.count {
                                deleteBackward()
                        }
                }
                if tail.isNotEmpty {
                        adjustTextPosition(byCharacterOffset: tail.utf16.count)
                        for _ in 0..<tail.count {
                                deleteBackward()
                        }
                }
                let text: String = head + tail
                guard text.isNotEmpty else { return false }
                UIPasteboard.general.string = text
                return true
        }

        /// Hant ↔ Hans conversion. 簡繁轉換
        func convertAllText() {
                if selectedText != nil {
                        adjustTextPosition(byCharacterOffset: 1)
                }
                let head: String = documentContextBeforeInput ?? String.empty
                let tail: String = documentContextAfterInput ?? String.empty
                if head.isNotEmpty {
                        for _ in 0..<head.count {
                                deleteBackward()
                        }
                }
                if tail.isNotEmpty {
                        adjustTextPosition(byCharacterOffset: tail.utf16.count)
                        for _ in 0..<tail.count {
                                deleteBackward()
                        }
                }
                let text: String = head + tail
                guard text.isNotEmpty else { return }
                let convertedText: String = {
                        let simplified: String = text.convertedT2S()
                        return (simplified == text) ? text.convertedS2T() : simplified
                }()
                insertText(convertedText)
        }

        func moveBackward() {
                let offset: Int = documentContextBeforeInput?.last?.utf16.count ?? 1
                adjustTextPosition(byCharacterOffset: -offset)
        }
        func moveForward() {
                let offset: Int = documentContextAfterInput?.first?.utf16.count ?? 1
                adjustTextPosition(byCharacterOffset: offset)
        }
        func jumpToHead() {
                if selectedText != nil {
                        adjustTextPosition(byCharacterOffset: -1)
                }
                let headOffset: Int = documentContextBeforeInput?.utf16.count ?? 1
                adjustTextPosition(byCharacterOffset: -headOffset)
        }
        func jumpToTail() {
                if selectedText != nil {
                        adjustTextPosition(byCharacterOffset: 1)
                }
                let tailOffset: Int = documentContextAfterInput?.utf16.count ?? 1
                adjustTextPosition(byCharacterOffset: tailOffset)
        }
}
