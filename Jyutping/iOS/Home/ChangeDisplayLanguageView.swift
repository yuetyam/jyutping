#if os(iOS)

import SwiftUI

struct ChangeDisplayLanguageView: View {
        var body: some View {
                List {
                        Section {
                                Text("Keyboard Display Language").font(.significant)
                                Text("Keyboard Display Language Description")
                        }
                        Section {
                                Text("Main App Display Language").font(.significant)
                                Label("Main App Display Language Description 1", systemImage: "1.circle")
                                Label("Main App Display Language Description 2", systemImage: "2.circle")
                        }
                        Section {
                                Link(destination: URL(string: UIApplication.openSettingsURLString)!) {
                                        HStack {
                                                Spacer()
                                                Text("Go to **Settings**")
                                                Spacer()
                                        }
                                }
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("title.change_display_language")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
