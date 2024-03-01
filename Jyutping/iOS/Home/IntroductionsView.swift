#if os(iOS)

import SwiftUI

struct IntroductionsView: View {
        var body: some View {
                List {
                        Section {
                                Text("IOSHomeTab.IntroductionsView.Heading.SpaceDoubleTapping").font(.significant)
                                Text("IOSHomeTab.IntroductionsView.Body.SpaceDoubleTapping").lineSpacing(6)
                        }
                        Section {
                                Text("IOSHomeTab.IntroductionsView.Heading.ClearPreEdit").font(.significant)
                                Text("IOSHomeTab.IntroductionsView.Body.ClearPreEdit").lineSpacing(6)
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("IOSHomeTab.NavigationTitle.MoreIntroductions")
                .navigationBarTitleDisplayMode(.inline)
        }
}

#endif
