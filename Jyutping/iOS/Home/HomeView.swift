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
                                                Text("Shared.Guide.AbbreviatedInput.Heading").font(.headline)
                                                Text("Shared.Guide.AbbreviatedInput.Body.Row1")
                                                Text("Shared.Guide.AbbreviatedInput.Body.Row2")
                                        }
                                        Section {
                                                Text("Shared.Guide.PinyinReverseLookup.Heading").font(.headline)
                                                Text("Shared.Guide.PinyinReverseLookup.Body")
                                        }
                                        Section {
                                                Text("Shared.Guide.CangjieReverseLookup.Heading").font(.headline)
                                                Text("Shared.Guide.CangjieReverseLookup.Body")
                                                Text("Shared.Guide.CangjieReverseLookup.Note")
                                        }
                                        Section {
                                                Text("Shared.Guide.StrokeReverseLookup.Heading").font(.headline)
                                                Text("Shared.Guide.StrokeReverseLookup.Body")
                                                Text("Shared.Guide.StrokeReverseLookup.Examples").font(.body.monospaced())
                                        }
                                        Section {
                                                Text("Shared.Guide.StructureReverseLookup.Heading").font(.headline)
                                                Text("Shared.Guide.StructureReverseLookup.Body")
                                        }
                                        Section {
                                                Text("Shared.Guide.TonesInput.Heading").font(.headline)
                                                Text("Shared.Guide.TonesInput.Body").font(.body.monospaced())
                                                Text("Shared.Guide.TonesInput.Examples")
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
