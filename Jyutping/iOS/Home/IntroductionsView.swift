#if os(iOS)

import SwiftUI

struct IntroductionsView: View {
        var body: some View {
                List {
                        Section {
                                Text("IOSHomeTab.IntroductionsView.Heading.SpaceDoubleTapping").font(.headline)
                                Text("IOSHomeTab.IntroductionsView.Body.SpaceDoubleTapping")
                        }
                        Section {
                                Text("IOSHomeTab.IntroductionsView.Heading.PositionInsertionPoint").font(.headline)
                                Text("IOSHomeTab.IntroductionsView.Body.PositionInsertionPoint")
                        }
                        Section {
                                Text("IOSHomeTab.IntroductionsView.Heading.ClearPreEdit").font(.headline)
                                Text("IOSHomeTab.IntroductionsView.Body.ClearPreEdit")
                        }
                        Section {
                                Text("IOSHomeTab.IntroductionsView.Heading.RemoveCandidateFromUserLexicon").font(.headline)
                                Text("IOSHomeTab.IntroductionsView.Body.RemoveCandidateFromUserLexicon")
                        }
                        Section {
                                Text("IOSHomeTab.IntroductionsView.Heading.TripleStrokeKeyboard").font(.headline)
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
