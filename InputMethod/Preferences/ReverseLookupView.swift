import SwiftUI
import CoreIME

struct ReverseLookupView: View {

        @State private var cangjieVariant: CangjieVariant = AppSettings.cangjieVariant

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                HStack {
                                        Picker("ReverseLookupView.CangjieVariant.Picker.TitleKey", selection: $cangjieVariant) {
                                                Text("ReverseLookupView.CangjieVariant.Picker.Option1").tag(CangjieVariant.cangjie5)
                                                Text("ReverseLookupView.CangjieVariant.Picker.Option2").tag(CangjieVariant.cangjie3)
                                                Text("ReverseLookupView.CangjieVariant.Picker.Option3").tag(CangjieVariant.quick5)
                                                Text("ReverseLookupView.CangjieVariant.Picker.Option4").tag(CangjieVariant.quick3)
                                        }
                                        .pickerStyle(.menu)
                                        .scaledToFit()
                                        .onChange(of: cangjieVariant) { newVariant in
                                                AppSettings.updateCangjieVariant(to: newVariant)
                                        }
                                        Spacer()
                                }
                                .block()
                        }
                        .textSelection(.enabled)
                        .padding()
                }
                .navigationTitle("PreferencesView.NavigationTitle.ReverseLookup")
        }
}
