#if os(iOS)

import SwiftUI

struct IntroductionsView: View {
        var body: some View {
                List {
                        Section {
                                Text("Lookup Jyutping with Loengfan").font(.significant)
                                Text("Loengfan Reverse Lookup Description").lineSpacing(6)
                        }
                        Section {
                                Text("Period (Full Stop) Shortcut").font(.significant)
                                Text("Double tapping the space bar will insert a period followed by a space").lineSpacing(6)
                        }
                        Section {
                                Text("Clear the input buffer syllables").font(.significant)
                                Text("Swipe from right to left on the Delete key will clear the pre-edited syllables").lineSpacing(6)
                        }
                }
                .navigationTitle("title.introductions")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
