#if os(iOS)

import SwiftUI
import CommonExtensions

struct HomeView: View {

        @State private var animationState: Int = 0

        @State private var isKeyboardEnabled: Bool = {
                guard let keyboards: [String] = UserDefaults.standard.object(forKey: "AppleKeyboards") as? [String] else { return false }
                return keyboards.contains(PresetConstant.KeyboardIdentifier)
        }()
        @State private var isGuideViewExpanded: Bool = false

        private var shouldDisplayHapticFeedbackTip: Bool {
                guard Device.isPhone else { return false }
                return isKeyboardEnabled.negative || isGuideViewExpanded
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
                                                Text("IOSHomeTab.Heading.HowToEnableThisKeyboard").font(.headline)
                                        }
                                        if (isKeyboardEnabled.negative || isGuideViewExpanded) {
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
                                if (isKeyboardEnabled.negative || isGuideViewExpanded) {
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
                                                Text("Shared.Guide.Heading.ToneInput").font(.headline)
                                                Text("Shared.Guide.Body.ToneInput").font(.body.monospaced())
                                                Text("Shared.Guide.Example.ToneInput")
                                        }
                                        Section {
                                                Text("Shared.Guide.Heading.PinyinReverseLookup").font(.headline)
                                                Text("Shared.Guide.Body.PinyinReverseLookup")
                                        }
                                        Section {
                                                Text("Shared.Guide.Heading.CangjieReverseLookup").font(.headline)
                                                Text("Shared.Guide.Body.CangjieReverseLookup")
                                                Text("Shared.Guide.Body.CangjieReverseLookup.Note")
                                        }
                                        Section {
                                                Text("Shared.Guide.Heading.StrokeReverseLookup").font(.headline)
                                                Text("Shared.Guide.Body.StrokeReverseLookup")
                                                Text("Shared.Guide.Example.StrokeReverseLookup").font(.body.monospaced())
                                        }
                                        Section {
                                                Text("Shared.Guide.Heading.StructureReverseLookup").font(.headline)
                                                Text("Shared.Guide.Body.StructureReverseLookup")
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
                                }
                        }
                        .animation(.default, value: animationState)
                        .animation(.default, value: isGuideViewExpanded)
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                                guard let keyboards: [String] = UserDefaults.standard.object(forKey: "AppleKeyboards") as? [String] else { return }
                                let isContaining: Bool = keyboards.contains(PresetConstant.KeyboardIdentifier)
                                if isKeyboardEnabled != isContaining {
                                        isKeyboardEnabled = isContaining
                                }
                        }
                        .navigationTitle("IOSTabView.NavigationTitle.Home")
                }
                .navigationViewStyle(.stack)
        }
}

#endif
