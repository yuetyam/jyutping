import SwiftUI

struct VersionLabel: View {
        
        @State private var isBannerPresented: Bool = false
        
        private let versionNumber: String = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "error"
        private let buildNumber: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "error"
        private var versionString: String { versionNumber + " (" + buildNumber + ")" }
        
        var body: some View {
                HStack {
                        Image(systemName: "info.circle")
                        Text("Version")
                        Spacer()
                        Text(versionString)
                }
                .contentShape(Rectangle())
                .padding()
                .onTapGesture {
                        UIPasteboard.general.string = versionString
                        isBannerPresented = true
                }
                .onLongPressGesture {
                        UIPasteboard.general.string = versionString
                        isBannerPresented = true
                }
                .banner(isPresented: $isBannerPresented)
        }
}

struct VersionLabel_Previews: PreviewProvider {
        static var previews: some View {
                VersionLabel()
        }
}

private struct BannerModifier: ViewModifier {
        
        @Binding var isPresented: Bool
        
        func body(content: Content) -> some View {
                ZStack {
                        content
                        if isPresented {
                                Text("Copied")
                                        .animation(.default)
                                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                                        .onAppear {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                                        withAnimation {
                                                                self.isPresented = false
                                                        }
                                                }
                                        }
                        }
                }
        }
        
}

private extension View {
        func banner(isPresented: Binding<Bool>) -> some View {
                self.modifier(BannerModifier(isPresented: isPresented))
        }
}
