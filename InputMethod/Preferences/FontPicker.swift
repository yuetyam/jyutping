import SwiftUI

@MainActor
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

        @Binding private var name: String
        private let size: CGFloat
        private let fallback: String
        private let adoptFormStyle: Bool

        init(_ name: Binding<String>, size: Int, fallback: String, adoptFormStyle: Bool = false) {
                self._name = name
                self.size = CGFloat(size)
                self.fallback = fallback
                self.adoptFormStyle = adoptFormStyle
        }

        private var font: NSFont {
                get {
                        return NSFont(name: name, size: size) ?? NSFont(name: fallback, size: size) ?? NSFont.systemFont(ofSize: size)
                }
                set {
                        name = newValue.fontName
                }
        }

        var body: some View {
                HStack {
                        // TODO: Remove adoptFormStyle when dropping support for macOS 12
                        if adoptFormStyle {
                                Text(verbatim: name)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.4)
                                Spacer()
                        } else {
                                Text(verbatim: name)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.4)
                                        .frame(width: 160, alignment: .leading)
                        }
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
                                Text("Preferences.FontPicker.ChangeCurrentFont")
                        }
                }
        }

        mutating func performFontSelection() {
                font = NSFontPanel.shared.convert(font)
        }
}
