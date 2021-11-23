import SwiftUI

@available(iOS 14.0, *)
struct FAQView: View {
        var body: some View {
                List {
                        Section {
                                Text("Can I use with external keyboards?").font(.headline)
                                Text("Unfortunately not. Third-party keyboard apps can't communicate with external keyboards due to system limitations.")
                        }
                        Section {
                                Text("What does “Allow Full Access” do?").font(.headline)
                                if UITraitCollection.current.userInterfaceIdiom == .pad {
                                        Text("Enable a button on the keyboard for pasting texts from Clipboard")
                                } else {
                                        HStack {
                                                Text(verbatim: "1.").font(.system(size: 15, design: .monospaced))
                                                Text("Haptic Feedback")
                                        }
                                        HStack {
                                                Text(verbatim: "2.").font(.system(size: 15, design: .monospaced))
                                                Text("Paste texts from Clipboard")
                                        }
                                }
                        } footer: {
                                Text("All other features don't require Full Access").textCase(.none)
                        }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("FAQ")
                .navigationBarTitleDisplayMode(.inline)
        }
}

@available(iOS 14.0, *)
struct FAQView_Previews: PreviewProvider {
        static var previews: some View {
                FAQView()
        }
}
