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
                                VStack(spacing: 16) {
                                        HStack {
                                                Text("Shared.Guide.Heading.PinyinReverseLookup").font(.significant)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.Body.PinyinReverseLookup").font(.master).lineSpacing(6)
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack(spacing: 16) {
                                        HStack {
                                                Text("Shared.Guide.Heading.CangjieReverseLookup").font(.significant)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.Body.CangjieReverseLookup").font(.master).lineSpacing(6)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.Body.CangjieReverseLookup.Note").font(.master).lineSpacing(6)
                                                Spacer()
                                        }
                                }
                                .block()
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
                                VStack(spacing: 16) {
                                        HStack {
                                                Text("Shared.Guide.Heading.ComposeReverseLookup").font(.significant)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.Body.ComposeReverseLookup").font(.master).lineSpacing(6)
                                                Spacer()
                                        }
                                }
                                .block()
                        }
                        .textSelection(.enabled)
                        .padding()
                }
                .navigationTitle("MacSidebar.NavigationTitle.Introductions")
        }
}

#endif
