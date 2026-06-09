#if os(iOS)

import SwiftUI

struct IntroductionsView: View {
        var body: some View {
                List {
                        Section {
                                Label("IOSHomeTab.IntroductionsView.Heading.ClearPreEdit", systemImage: "clear").labelStyle(.headline(iconColor: .green))
                                Text("IOSHomeTab.IntroductionsView.Body.ClearPreEdit")
                        }
                        Section {
                                Label("IOSHomeTab.IntroductionsView.Heading.ForgetCandidate", systemImage: "trash").labelStyle(.headline(iconColor: .red))
                                Text("IOSHomeTab.IntroductionsView.Body.ForgetCandidate")
                        }
                        Section {
                                Label("IOSHomeTab.IntroductionsView.Heading.PositionInsertionPoint", systemImage: "arrow.left.and.line.vertical.and.arrow.right").labelStyle(.headline(iconColor: .blue))
                                Text("IOSHomeTab.IntroductionsView.Body.PositionInsertionPoint")
                        }
                        Section {
                                Label("IOSHomeTab.IntroductionsView.Heading.TripleStrokeKeyboard", systemImage: "t.square").labelStyle(.headline(iconColor: .purple))
                                Text("IOSHomeTab.IntroductionsView.Body.TripleStrokeKeyboard.Row1")
                                Text("IOSHomeTab.IntroductionsView.Body.TripleStrokeKeyboard.Row2")
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("IOSHomeTab.NavigationTitle.MoreIntroductions")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
