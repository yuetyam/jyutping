import SwiftUI

struct MacContentView: View {
        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        NavigationLink(destination: Text("Introductions")) {
                                                Label("Introductions", systemImage: "book")
                                        }
                                        NavigationLink(destination: Text("Home")) {
                                                Label("label.title.expressions", systemImage: "text.quote")
                                        }
                                } header: {
                                        Text("Keyboard").textCase(.none)
                                }
                                Section {
                                        NavigationLink(destination: Text("About")) {
                                                Label("Search", systemImage: "magnifyingglass")
                                        }
                                        NavigationLink(destination: Text("About")) {
                                                Label("Initials", systemImage: "rectangle.leadingthird.inset.filled")
                                        }
                                        NavigationLink(destination: Text("About")) {
                                                Label("Finals", systemImage: "rectangle.trailingthird.inset.filled")
                                        }
                                        NavigationLink(destination: Text("About")) {
                                                Label("Tones", systemImage: "bell")
                                        }
                                        NavigationLink(destination: Text("About")) {
                                                Label("Resources", systemImage: "square.3.stack.3d")
                                        }
                                } header: {
                                        Text("Jyutping").textCase(.none)
                                }
                                Section {
                                        NavigationLink(destination: Text("About")) {
                                                Label("About", systemImage: "globe.asia.australia")
                                        }
                                        NavigationLink(destination: Text("About")) {
                                                Label("FAQ", systemImage: "questionmark.circle")
                                        }
                                        NavigationLink(destination: Text("About")) {
                                                Label("Version", systemImage: "info.circle")
                                        }
                                } header: {
                                        Text("About").textCase(.none)
                                }
                        }
                        .listStyle(.sidebar)
                        .navigationTitle("Jyutping")
                }
        }
}
