#if os(iOS)

import SwiftUI

struct ChangeDisplayLanguageView: View {
        @State private var inputText: String = ""
        var body: some View {
                List {
                        Section {
                                TextField("TextField.InputTextField", text: $inputText)
                        }
                        Section {
                                Text("IOSHomeTab.ChangeDisplayLanguage.Heading.Keyboard").font(.headline)
                                Label("IOSHomeTab.ChangeDisplayLanguage.Body.Keyboard.Row1", systemImage: "1.circle")
                                Label("IOSHomeTab.ChangeDisplayLanguage.Body.Keyboard.Row2", systemImage: "2.circle")
                        }
                        Section {
                                Text("IOSHomeTab.ChangeDisplayLanguage.Heading.MainApp").font(.headline)
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
