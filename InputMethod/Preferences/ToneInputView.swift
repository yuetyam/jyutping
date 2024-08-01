import SwiftUI

struct ToneInputView: View {
        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                VStack {
                                        HStack {
                                                Text("ToneInputView.ToneInput.Heading").font(.headline)
                                                Spacer()
                                        }
                                        Divider()
                                        HStack {
                                                Text("ToneInputView.ToneInput.Body").font(.body.monospaced())
                                                Spacer()
                                        }
                                        Divider()
                                        HStack {
                                                Text("ToneInputView.ToneInput.Example")
                                                Spacer()
                                        }
                                }
                                .block()
                        }
                        .textSelection(.enabled)
                        .padding()
                }
                .navigationTitle("PreferencesView.NavigationTitle.ToneInput")
        }
}
