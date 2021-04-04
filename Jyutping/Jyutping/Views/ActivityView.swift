import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
        
        let activityItems: [Any]
        
        func makeUIViewController(context: Context) -> UIActivityViewController {
                return UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        }
        
        func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct ActivityView_Previews: PreviewProvider {
        static var previews: some View {
                ActivityView(activityItems: ["bonjour"])
        }
}
