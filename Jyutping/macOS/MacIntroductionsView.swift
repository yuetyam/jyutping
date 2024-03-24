#if os(macOS)

import SwiftUI

struct MacIntroductionsView: View {
        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                VStack(spacing: 16) {
                                        HStack {
                                                Text("Shared.Guide.Heading.TonesInput").font(.significant)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.Body.TonesInput").font(.fixedWidth).lineSpacing(5)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.Example.TonesInput").font(.master)
                                                Spacer()
                                        }
                                }
                                .block()

                                BlockView(heading: "Shared.Guide.Heading.PinyinReverseLookup", content: "Shared.Guide.Body.PinyinReverseLookup")
                                BlockView(heading: "Shared.Guide.Heading.CangjieReverseLookup", content: "Shared.Guide.Body.CangjieReverseLookup")

                                VStack(spacing: 16) {
                                        HStack {
                                                Text("Shared.Guide.Heading.StrokeReverseLookup").font(.significant)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.Body.StrokeReverseLookup").font(.master).lineSpacing(6)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.Example.StrokeReverseLookup").font(.fixedWidth).lineSpacing(5)
                                                Spacer()
                                        }
                                }
                                .block()

                                BlockView(heading: "Shared.Guide.Heading.ComposeReverseLookup", content: "Shared.Guide.Body.ComposeReverseLookup")
                        }
                        .textSelection(.enabled)
                        .padding()
                }
                .navigationTitle("MacSidebar.NavigationTitle.Introductions")
        }
}


private struct BlockView: View {

        let heading: LocalizedStringKey
        let content: LocalizedStringKey

        var body: some View {
                VStack(spacing: 16) {
                        HStack {
                                Text(heading).font(.significant)
                                Spacer()
                        }
                        HStack {
                                Text(content).font(.master).lineSpacing(6)
                                Spacer()
                        }
                }
                .block()
        }
}

#endif
