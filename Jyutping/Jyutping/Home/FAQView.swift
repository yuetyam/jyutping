import SwiftUI

@available(iOS 14.0, *)
struct FAQView: View {
        var body: some View {
                List {
                        Section {
                                Text("Can I use with external keyboards?").font(.headline)
                                Text("Unfortunately not. Third-party keyboard apps can't communicate with external keyboards due to system limitations.")
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
