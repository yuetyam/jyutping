#if os(iOS)

import SwiftUI

struct ClipboardFeaturesView: View {
        @State private var inputText: String = ""
        var body: some View {
                List {
                        Section {
                                Text("ClipboardFeatures.Notice.Row1")
                                Text("ClipboardFeatures.Notice.Row2")
                                Text("ClipboardFeatures.Notice.Row3")
                        }
                        Section {
                                TextField("Input Text Field", text: $inputText)
                        }
                        Section {
                                Text("ClipboardFeatures.Notice.Row4")
                                Text("ClipboardFeatures.Notice.Row5")
                        }
                        Section {
                                GoToSettingsLinkView()
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("Clipboard Features")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#Preview {
        ClipboardFeaturesView()
}

#endif
