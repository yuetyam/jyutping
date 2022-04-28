import SwiftUI

struct MacContentView: View {
        var body: some View {
                NavigationView {
                        List {
                                Section {
                                        NavigationLink(destination: Text("Home")) {
                                                Label("Home", systemImage: "house")
                                        }
                                }
                                Section {
                                        NavigationLink(destination: Text("About")) {
                                                Label("About", systemImage: "info.circle")
                                        }
                                }
                        }
                        .navigationTitle("Home")
                }
        }
}
