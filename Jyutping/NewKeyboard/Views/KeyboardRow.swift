import SwiftUI

struct KeyboardRow: View {

        @EnvironmentObject private var context: KeyboardViewController

        let events: [KeyboardEvent]

        var body: some View {
                HStack(spacing: 0) {
                        ForEach(0..<events.count, id: \.self) { index in
                                KeyView(event: events[index]).environmentObject(context)
                        }
                }
        }
}
