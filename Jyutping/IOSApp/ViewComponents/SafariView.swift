import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
        
        let url: URL
        
        func makeUIViewController(context: Context) -> SFSafariViewController {
                return SFSafariViewController(url: url)
        }
        
        func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
