#if os(iOS)

import SwiftUI

struct HomeView: View {

        @State private var animationState: Int = 0

        @State private var isKeyboardEnabled: Bool = {
                guard let keyboards: [String] = UserDefaults.standard.object(forKey: "AppleKeyboards") as? [String] else { return false }
                return keyboards.contains("im.cantonese.CantoneseIM.Keyboard")
        }()
        @State private var isGuideViewExpanded: Bool = false

        private var shouldDisplayHapticFeedbackTip: Bool {
                guard Device.isPhone else { return false }
                return !isKeyboardEnabled || isGuideViewExpanded
        }

        private let clipboardImageName: String = {
                if #available(iOS 16.0, *) {
                        return "list.clipboard"
                } else {
                        return "doc.on.doc"
                }
        }()

        var body: some View {
                NavigationView {
                        List {
                                SearchView(placeholder: "TextField.SearchPronunciation", submitLabel: .return, animationState: $animationState)

                                Section {
                                        if isKeyboardEnabled {
                                                HStack {
                                                        Text("IOSHomeTab.Heading.HowToEnableThisKeyboard")
                                                        Spacer()
                                                        if isGuideViewExpanded {
                                                                Image.downChevron
                                                        } else {
                                                                Image.backwardChevron
                                                        }
                                                }
                                                .contentShape(Rectangle())
                                                .onTapGesture {
                                                        isGuideViewExpanded.toggle()
                                                }
                                        } else {
                                                Text("IOSHomeTab.Heading.HowToEnableThisKeyboard").font(.significant)
                                        }
                                        if !isKeyboardEnabled || isGuideViewExpanded {
                                                VStack(spacing: 5) {
                                                        HStack {
                                                                Text.dotMark
                                                                Text("IOSHomeTab.EnablingKeyboard.Step1")
                                                                Spacer()
                                                        }
                                                        HStack {
                                                                Text.dotMark
                                                                Text("IOSHomeTab.EnablingKeyboard.Step2")
                                                                Spacer()
                                                        }
                                                        HStack {
                                                                Text.dotMark
                                                                Text("IOSHomeTab.EnablingKeyboard.Step3")
                                                                Spacer()
                                                        }
                                                        HStack {
                                                                Text.dotMark
                                                                Text("IOSHomeTab.EnablingKeyboard.Step4")
                                                                Spacer()
                                                        }
                                                }
                                        }
                                } footer: {
                                        if shouldDisplayHapticFeedbackTip {
                                                Text("IOSHomeTab.EnablingKeyboard.Footer").textCase(nil)
                                        } else {
                                                EmptyView()
                                        }
                                }
                                if !isKeyboardEnabled || isGuideViewExpanded {
                                        Section {
                                                GoToSettingsLinkView()
                                        }
                                }
                                Section {
                                        NavigationLink(destination: EnablingKeyboardView()) {
                                                Label("IOSHomeTab.LabelTitle.ProblemsWithEnablingKeyboard", systemImage: "info.circle").labelStyle(.titleOnly)
                                        }
                                }

                                Group {
                                        Section {
                                                Text("Shared.Guide.Heading.TonesInput").font(.significant)
                                                Text("Shared.Guide.Body.TonesInput").font(.fixedWidth).lineSpacing(5)
                                                Text("Shared.Guide.Example.TonesInput")
                                        }
                                        Section {
                                                Text("Shared.Guide.Heading.PinyinReverseLookup").font(.significant)
                                                Text("Shared.Guide.Body.PinyinReverseLookup").lineSpacing(6)
                                        }
                                        Section {
                                                Text("Shared.Guide.Heading.CangjieReverseLookup").font(.significant)
                                                Text("Shared.Guide.Body.CangjieReverseLookup").lineSpacing(6)
                                                Text("Shared.Guide.Body.CangjieReverseLookup.Note").lineSpacing(6)
                                        }
                                        Section {
                                                Text("Shared.Guide.Heading.StrokeReverseLookup").font(.significant)
                                                Text("Shared.Guide.Body.StrokeReverseLookup").lineSpacing(6)
                                                Text("Shared.Guide.Example.StrokeReverseLookup").font(.fixedWidth).lineSpacing(5)
                                        }
                                        Section {
                                                Text("Shared.Guide.Heading.StructureReverseLookup").font(.significant)
                                                Text("Shared.Guide.Body.StructureReverseLookup").lineSpacing(6)
                                        }
                                }
                                .textSelection(.enabled)

                                Section {
                                        NavigationLink(destination: IntroductionsView()) {
                                                Label("IOSHomeTab.LabelTitle.MoreIntroductions", systemImage: "info.circle")
                                        }
                                        NavigationLink(destination: Text2SpeechView()) {
                                                Label("IOSHomeTab.LabelTitle.TextToSpeech", systemImage: "speaker.wave.2")
                                        }
                                        NavigationLink(destination: ClipboardFeaturesView()) {
                                                Label("IOSHomeTab.LabelTitle.ClipboardFeatures", systemImage: clipboardImageName)
                                        }
                                        NavigationLink(destination: ChangeDisplayLanguageView()) {
                                                Label("IOSHomeTab.LabelTitle.ChangeDisplayLanguage", systemImage: "globe.asia.australia")
                                        }
                                        NavigationLink(destination: FAQView()) {
                                                Label("IOSHomeTab.LabelTitle.FAQ", systemImage: "questionmark.circle")
                                        }
                                        NavigationLink(destination: PrivacyNoticeView()) {
                                                Label("IOSHomeTab.LabelTitle.PrivacyNotice", systemImage: "lock.circle")
                                        }
                                }
                        }
                        .animation(.default, value: animationState)
                        .animation(.default, value: isGuideViewExpanded)
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                                guard let keyboards: [String] = UserDefaults.standard.object(forKey: "AppleKeyboards") as? [String] else { return }
                                let isContained: Bool = keyboards.contains("im.cantonese.CantoneseIM.Keyboard")
                                if isKeyboardEnabled != isContained {
                                        isKeyboardEnabled = isContained
                                }
                        }
                        .navigationTitle("IOSTabView.NavigationTitle.Home")
                }
                .navigationViewStyle(.stack)
        }
}

#endif
