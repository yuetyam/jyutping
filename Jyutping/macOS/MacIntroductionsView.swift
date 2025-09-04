#if os(macOS)

import SwiftUI

struct MacIntroductionsView: View {
        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 12) {
                                VStack(spacing: 16) {
                                        HStack {
                                                Text("Shared.Guide.AbbreviatedInput.Heading").font(.significant)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.AbbreviatedInput.Body.Row1").font(.master)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.AbbreviatedInput.Body.Row2").font(.master)
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack(spacing: 16) {
                                        HStack {
                                                Text("Shared.Guide.PinyinReverseLookup.Heading").font(.significant)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.PinyinReverseLookup.Body").font(.master)
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack(spacing: 16) {
                                        HStack {
                                                Text("Shared.Guide.CangjieReverseLookup.Heading").font(.significant)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.CangjieReverseLookup.Body").font(.master)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.CangjieReverseLookup.Note").font(.master)
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack(spacing: 16) {
                                        HStack {
                                                Text("Shared.Guide.StrokeReverseLookup.Heading").font(.significant)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.StrokeReverseLookup.Body").font(.master)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.StrokeReverseLookup.Examples").font(.fixedWidth).lineSpacing(5)
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack(spacing: 16) {
                                        HStack {
                                                Text("Shared.Guide.StructureReverseLookup.Heading").font(.significant)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.StructureReverseLookup.Body").font(.master).lineSpacing(6)
                                                Spacer()
                                        }
                                }
                                .block()
                                VStack(spacing: 16) {
                                        HStack {
                                                Text("Shared.Guide.TonesInput.Heading").font(.significant)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.TonesInput.Body").font(.fixedWidth).lineSpacing(5)
                                                Spacer()
                                        }
                                        HStack {
                                                Text("Shared.Guide.TonesInput.Examples").font(.master)
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
