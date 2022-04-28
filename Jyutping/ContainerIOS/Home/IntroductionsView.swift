import SwiftUI

struct IntroductionsView: View {
        var body: some View {
                List {
                        Section {
                                Text("Lookup Jyutping with Loengfan").font(.headline)
                                Text("Loengfan Reverse Lookup Description").lineSpacing(6)
                        }
                        Section {
                                Text("Period (Full Stop) Shortcut").font(.headline)
                                Text("Double tapping the space bar will insert a period followed by a space").lineSpacing(6)
                        }
                        Section {
                                Text("Clear the input buffer syllables").font(.headline)
                                Text("Swipe from right to left on the Delete key will clear the pre-edited syllables").lineSpacing(6)
                        }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("title.introductions")
                .navigationBarTitleDisplayMode(.inline)
        }
}
