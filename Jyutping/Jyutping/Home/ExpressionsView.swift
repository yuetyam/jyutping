import SwiftUI

@available(iOS 15.0, *)
struct ExpressionsView: View {
        var body: some View {
                List {
                        Text("Expressions Convention")
                }
                .navigationTitle("Expressions")
                .navigationBarTitleDisplayMode(.inline)
        }
}

@available(iOS 15.0, *)
struct ExpressionsView_Previews: PreviewProvider {
        static var previews: some View {
                ExpressionsView()
        }
}
