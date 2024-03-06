#if os(iOS)

import SwiftUI

struct ChangeDisplayLanguageView: View {
        var body: some View {
                List {
                        Section {
                                Text("IOSHomeTab.ChangeDisplayLanguage.Heading.Keyboard").font(.significant)
                                Text("IOSHomeTab.ChangeDisplayLanguage.Body.Keyboard")
                        }
                        Section {
                                Text("IOSHomeTab.ChangeDisplayLanguage.Heading.MainApp").font(.significant)
                                Label("IOSHomeTab.ChangeDisplayLanguage.Body.MainApp.Row1", systemImage: "1.circle")
                                Label("IOSHomeTab.ChangeDisplayLanguage.Body.MainApp.Row2", systemImage: "2.circle")
                        }
                        Section {
                                GoToSettingsLinkView()
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("IOSHomeTab.NavigationTitle.ChangeDisplayLanguage")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
