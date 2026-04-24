import SwiftUI
import CoreIME

struct ReverseLookupView: View {

        @State private var cangjieVariant: CangjieVariant = AppSettings.cangjieVariant

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                VStack {
                                        HStack {
                                                Image(systemName: "r.square").font(.title3).foregroundStyle(Color.purple)
                                                Text("ReverseLookupView.PinyinReverseLookup.Heading").font(.headline)
                                                Spacer()
                                        }
                                        Divider()
                                        HStack {
                                                Text("ReverseLookupView.PinyinReverseLookup.Body")
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack {
                                        HStack {
                                                Image(systemName: "v.square").font(.title3).foregroundStyle(Color.blue)
                                                Text("ReverseLookupView.CangjieReverseLookup.Heading").font(.headline)
                                                Spacer()
                                        }
                                        Divider()
                                        HStack {
                                                Text("ReverseLookupView.CangjieReverseLookup.Body")
                                                Spacer()
                                        }
                                        Divider()
                                        HStack {
                                                Picker("ReverseLookupView.CangjieVariant.Picker.TitleKey", selection: $cangjieVariant) {
                                                        Text("ReverseLookupView.CangjieVariant.Picker.Option1").tag(CangjieVariant.cangjie5)
                                                        Text("ReverseLookupView.CangjieVariant.Picker.Option2").tag(CangjieVariant.cangjie3)
                                                        Text("ReverseLookupView.CangjieVariant.Picker.Option3").tag(CangjieVariant.quick5)
                                                        Text("ReverseLookupView.CangjieVariant.Picker.Option4").tag(CangjieVariant.quick3)
                                                }
                                                .pickerStyle(.menu)
                                                .fixedSize()
                                                .onChange(of: cangjieVariant) { newVariant in
                                                        AppSettings.updateCangjieVariant(to: newVariant)
                                                }
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack {
                                        HStack {
                                                Image(systemName: "x.square").font(.title3).foregroundStyle(Color.indigo)
                                                Text("ReverseLookupView.StrokeReverseLookup.Heading").font(.headline)
                                                Spacer()
                                        }
                                        Divider()
                                        HStack {
                                                Text("ReverseLookupView.StrokeReverseLookup.Body")
                                                Spacer()
                                        }
                                        Divider()
                                        HStack {
                                                Text("ReverseLookupView.StrokeReverseLookup.Example").monospaced()
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack {
                                        HStack {
                                                Image(systemName: "q.square").font(.title3).foregroundStyle(Color.mint)
                                                Text("ReverseLookupView.StructureReverseLookup.Heading").font(.headline)
                                                Spacer()
                                        }
                                        Divider()
                                        HStack {
                                                Text("ReverseLookupView.StructureReverseLookup.Body")
                                                Spacer()
                                        }
                                }
                                .block()
                        }
                        .textSelection(.enabled)
                        .padding(8)
                }
                .navigationTitle("SettingsView.NavigationTitle.ReverseLookup")
        }
}
