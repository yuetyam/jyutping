#if os(macOS)

import SwiftUI

struct MacIntroductionsView: View {
        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 12) {
                                VStack(spacing: 16) {
                                        HStack {
                                                Text("Shared.Guide.Heading.ToneInput").font(.significant)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.Body.ToneInput").font(.fixedWidth).lineSpacing(5)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.Example.ToneInput").font(.master)
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
                                                Text("Shared.Guide.Heading.StructureReverseLookup").font(.significant)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.Body.StructureReverseLookup").font(.master).lineSpacing(6)
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
