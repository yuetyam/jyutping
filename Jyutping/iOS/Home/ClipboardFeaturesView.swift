#if os(iOS)

import SwiftUI

struct ClipboardFeaturesView: View {
        @State private var inputText: String = ""
        var body: some View {
                List {
                        Section {
                                Label("IOSHomeTab.ClipboardFeaturesView.Notice1", systemImage: "checkmark.seal.text.page").labelStyle(.iconTint(.purple))
                        }
                        Section {
                                Label("IOSHomeTab.ClipboardFeaturesView.Notice2", systemImage: "bell").labelStyle(.iconTint(.orange))
                        }
                        Section {
                                Label("IOSHomeTab.ClipboardFeaturesView.Notice3", systemImage: "checkmark.circle").labelStyle(.iconTint(.green))
                                HStack {
                                        Spacer()
                                        Image(.pasteFromOtherApps)
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(.rect(cornerRadius: 20))
                                                .frame(maxWidth: 300)
                                        Spacer()
                                }
                        }
                        Section {
                                GoToSettingsLinkView()
                        }
                        Section {
                                Color.clear.frame(height: 144)
                        }
                        .listRowBackground(Color.clear)
                }
                .textSelection(.enabled)
                .navigationTitle("IOSHomeTab.NavigationTitle.ClipboardFeatures")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
