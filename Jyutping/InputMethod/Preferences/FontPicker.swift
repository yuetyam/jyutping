import SwiftUI

private final class FontPickerDelegate {

        private var picker: FontPicker

        init(_ picker: FontPicker) {
                self.picker = picker
        }

        @objc func changeFont(_ id: Any) {
                picker.performFontSelection()
        }

}

struct FontPicker: View {

        @State private var fontPickerDelegate: FontPickerDelegate?

        @Binding private var familyName: String
        private let size: CGFloat
        private let fallback: String

        /// FontPicker
        /// - Parameters:
        ///   - name: NSFont().familyName
        ///   - size: Font size
        ///   - fallback: Fallback font name
        init(_ name: Binding<String>, size: Int, fallback: String) {
                self._familyName = name
                self.size = CGFloat(size)
                self.fallback = fallback
        }

        private var font: NSFont {
                get {
                        return NSFont(name: familyName, size: size) ?? NSFont(name: fallback, size: size) ?? .systemFont(ofSize: size)
                }
                set {
                        familyName = newValue.familyName ?? newValue.fontName
                }
        }

        var body: some View {
                HStack {
                        Text(verbatim: familyName)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .frame(width: 128, alignment: .leading)
                        Button {
                                guard !(NSFontPanel.shared.isVisible) else {
                                        NSFontPanel.shared.orderOut(nil)
                                        return
                                }
                                fontPickerDelegate = FontPickerDelegate(self)
                                NSFontManager.shared.target = fontPickerDelegate
                                NSFontManager.shared.setSelectedFont(font, isMultiple: false)
                                NSFontPanel.shared.orderBack(nil)
                        } label: {
                                Text("FontPicker.CurrentFont.Change")
                        }
                }
        }

        mutating func performFontSelection() {
                font = NSFontPanel.shared.convert(font)
        }
}
