#if os(iOS)

import SwiftUI

struct ClipboardFeaturesView: View {
        @State private var inputText: String = ""
        var body: some View {
                List {
                        Section {
                                Text("IOSHomeTab.ClipboardFeaturesView.Notice0")
                        }
                        Section {
                                Text("IOSHomeTab.ClipboardFeaturesView.Notice1")
                                Text("IOSHomeTab.ClipboardFeaturesView.Notice2")
                                Text("IOSHomeTab.ClipboardFeaturesView.Notice3")
                        }
                        Section {
                                TextField("TextField.InputTextField", text: $inputText)
                        }
                        Section {
                                Text("IOSHomeTab.ClipboardFeaturesView.Notice4")
                                Text("IOSHomeTab.ClipboardFeaturesView.Notice5")
                        }
                        Section {
                                GoToSettingsLinkView()
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("IOSHomeTab.NavigationTitle.ClipboardFeatures")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#Preview {
        ClipboardFeaturesView()
}

#endif
