#if os(macOS)

import SwiftUI

struct MacIntroductionsView: View {
        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 12) {
                                VStack(spacing: 16) {
                                        HStack {
                                                Image(systemName: "sparkles").font(.title3).foregroundStyle(Color.mint)
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
                                                Image(systemName: "r.square").font(.title3).foregroundStyle(Color.purple)
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
                                                Image(systemName: "v.square").font(.title3).foregroundStyle(Color.blue)
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
                                                Image(systemName: "x.square").font(.title3).foregroundStyle(Color.indigo)
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
                                                Image(systemName: "q.square").font(.title3).foregroundStyle(Color.pink)
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
                                                Image(systemName: "bell").font(.title3).foregroundStyle(Color.orange)
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
