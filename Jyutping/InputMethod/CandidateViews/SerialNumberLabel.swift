import SwiftUI

struct SerialNumberLabel: View {
        init(_ index: Int) {
                self.number = (index == 9) ? 0 : (index + 1)
        }
        private let number: Int
        var body: some View {
                HStack(spacing: 0) {
                        Text(verbatim: "\(number)").font(.label)
                        Text(verbatim: ".").font(.labelDot)
                }
        }
}
