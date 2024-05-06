import UIKit

extension UITextDocumentProxy {

        /// Clear(delete) the text to the left of the cursor.
        func clearAllText() {
                guard hasText else { return }
                if selectedText != nil {
                        deleteBackward()
                }
                for _ in 0..<5 {
                        guard hasText else { break }
                        if let text = documentContextBeforeInput {
                                for _ in 0..<text.count {
                                        deleteBackward()
                                }
                        } else {
                                deleteBackward()
                        }
                }
        }

        /// Copy all text to the system clipboard.
        /// - Returns: Did copy text to the system clipboard?
        func copyAllText() -> Bool {
                guard hasText else { return false }
                let head: String = documentContextBeforeInput ?? String.empty
                let selected: String = selectedText ?? String.empty
                let tail: String = documentContextAfterInput ?? String.empty
                let text: String = head + selected + tail
                guard !(text.isEmpty) else { return false }
                UIPasteboard.general.string = text
                return true
        }

        /// Copy all text to the system clipboard, and clear the text-entry object content.
        /// - Returns: Did copy text to the system clipboard?
        func cutAllText() -> Bool {
                guard hasText else { return false }
                if selectedText != nil {
                        adjustTextPosition(byCharacterOffset: 1)
                }
                let head: String = {
                        var parts: [String] = []
                        for _ in 0..<5 {
                                guard hasText else { break }
                                if let text = documentContextBeforeInput {
                                        parts.append(text)
                                        for _ in 0..<text.count {
                                                deleteBackward()
                                        }
                                } else {
                                        insertText(String.zeroWidthSpace)
                                        deleteBackward()
                                        if let text = documentContextBeforeInput {
                                                parts.append(text)
                                                for _ in 0..<text.count {
                                                        deleteBackward()
                                                }
                                        }
                                }
                        }
                        return parts.joined()
                }()
                let tail: String = {
                        var parts: [String] = []
                        for _ in 0..<5 {
                                guard hasText else { break }
                                if let text = documentContextAfterInput {
                                        parts.append(text)
                                        adjustTextPosition(byCharacterOffset: text.utf16.count)
                                        for _ in 0..<text.count {
                                                deleteBackward()
                                        }
                                } else {
                                        insertText(String.zeroWidthSpace)
                                        if let text = documentContextAfterInput {
                                                parts.append(text)
                                                adjustTextPosition(byCharacterOffset: text.utf16.count)
                                                for _ in 0..<text.count {
                                                        deleteBackward()
                                                }
                                        }
                                        deleteBackward()
                                }
                        }
                        return parts.joined()
                }()
                let text: String = head + tail
                guard !(text.isEmpty) else { return false }
                UIPasteboard.general.string = text
                return true
        }

        /// Hant ↔ Hans conversion. 簡繁轉換
        func convertAllText() {
                guard hasText else { return }
                if selectedText != nil {
                        adjustTextPosition(byCharacterOffset: 1)
                }
                let head: String = {
                        var parts: [String] = []
                        for _ in 0..<5 {
                                guard hasText else { break }
                                if let text = documentContextBeforeInput {
                                        parts.append(text)
                                        for _ in 0..<text.count {
                                                deleteBackward()
                                        }
                                } else {
                                        insertText(String.zeroWidthSpace)
                                        deleteBackward()
                                        if let text = documentContextBeforeInput {
                                                parts.append(text)
                                                for _ in 0..<text.count {
                                                        deleteBackward()
                                                }
                                        }
                                }
                        }
                        return parts.joined()
                }()
                let tail: String = {
                        var parts: [String] = []
                        for _ in 0..<5 {
                                guard hasText else { break }
                                if let text = documentContextAfterInput {
                                        parts.append(text)
                                        adjustTextPosition(byCharacterOffset: text.utf16.count)
                                        for _ in 0..<text.count {
                                                deleteBackward()
                                        }
                                } else {
                                        insertText(String.zeroWidthSpace)
                                        if let text = documentContextAfterInput {
                                                parts.append(text)
                                                adjustTextPosition(byCharacterOffset: text.utf16.count)
                                                for _ in 0..<text.count {
                                                        deleteBackward()
                                                }
                                        }
                                        deleteBackward()
                                }
                        }
                        return parts.joined()
                }()
                let text: String = head + tail
                guard !(text.isEmpty) else { return }
                let convertedText: String = {
                        let simplified: String = text.traditional2SimplifiedConverted()
                        guard simplified == text else { return simplified }
                        return text.simplified2TraditionalConverted()
                }()
                insertText(convertedText)
        }
}
