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

        private var shouldExpandGuidView: Bool {
                return isKeyboardEnabled.negative || isGuideViewExpanded
        }
        private var shouldDisplayHapticFeedbackTip: Bool {
                guard Device.isPhone else { return false }
                return isKeyboardEnabled.negative || isGuideViewExpanded
        }

        var body: some View {
                NavigationStack {
                        List {
                                SearchView(placeholder: "TextField.SearchPronunciation", submitLabel: .return, animationState: $animationState)

                                Section {
                                        if isKeyboardEnabled {
                                                Button {
                                                        isGuideViewExpanded.toggle()
                                                } label: {
                                                        HStack {
                                                                Label("IOSHomeTab.Heading.HowToEnableThisKeyboard", systemImage: "keyboard")
                                                                Spacer()
                                                                if isGuideViewExpanded {
                                                                        Image.downChevron
                                                                } else {
                                                                        Image.backwardChevron
                                                                }
                                                        }
                                                        .contentShape(.rect)
                                                }
                                                .buttonStyle(.plain)
                                        } else {
                                                HStack(spacing: 16) {
                                                        Image(systemName: "keyboard").font(.title3).foregroundStyle(Color.accentColor)
                                                        Text("IOSHomeTab.Heading.HowToEnableThisKeyboard").font(.headline)
                                                }
                                        }
                                        if shouldExpandGuidView {
                                                VStack(alignment: .leading, spacing: 10) {
                                                        Label("IOSHomeTab.EnablingKeyboard.Step1", systemImage: "1.circle").labelStyle(.iconTint(.purple))
                                                        Label("IOSHomeTab.EnablingKeyboard.Step2", systemImage: "2.circle").labelStyle(.iconTint(.purple))
                                                        Label("IOSHomeTab.EnablingKeyboard.Step3", systemImage: "3.circle").labelStyle(.iconTint(.purple))
                                                        Label("IOSHomeTab.EnablingKeyboard.Step4", systemImage: "4.circle").labelStyle(.iconTint(.purple))
                                                }
                                        } else {
                                                NavigationLink(destination: EnablingKeyboardView()) {
                                                        Label("IOSHomeTab.LabelTitle.ProblemsWithEnablingKeyboard", systemImage: "hand.raised")
                                                }
                                        }
                                } footer: {
                                        if shouldDisplayHapticFeedbackTip {
                                                Text("IOSHomeTab.EnablingKeyboard.Footer").textCase(nil)
                                        }
                                }
                                if shouldExpandGuidView {
                                        Section {
                                                GoToSettingsLinkView()
                                        }
                                        Section {
                                                NavigationLink(destination: EnablingKeyboardView()) {
                                                        Label("IOSHomeTab.LabelTitle.ProblemsWithEnablingKeyboard", systemImage: "hand.raised")
                                                }
                                        }
                                }
                                Section {
                                        NavigationLink(destination: Text2SpeechView()) {
                                                Label("IOSHomeTab.LabelTitle.TextToSpeech", systemImage: "speaker.wave.2")
                                        }
                                }

                                Group {
                                        Section {
                                                Label("Shared.Guide.AbbreviatedInput.Heading", systemImage: "sparkles").labelStyle(.headline(iconColor: .green))
                                                Text("Shared.Guide.AbbreviatedInput.Body.Row1")
                                                Text("Shared.Guide.AbbreviatedInput.Body.Row2")
                                        }
                                        Section {
                                                Label("Shared.Guide.PinyinReverseLookup.Heading", systemImage: "r.square").labelStyle(.headline(iconColor: .red))
                                                Text("Shared.Guide.PinyinReverseLookup.Body")
                                        }
                                        Section {
                                                Label("Shared.Guide.CangjieReverseLookup.Heading", systemImage: "v.square").labelStyle(.headline(iconColor: .blue))
                                                Text("Shared.Guide.CangjieReverseLookup.Body")
                                        } footer: {
                                                Text("Shared.Guide.CangjieReverseLookup.Note").textCase(nil)
                                        }
                                        Section {
                                                Label("Shared.Guide.StrokeReverseLookup.Heading", systemImage: "x.square").labelStyle(.headline(iconColor: .purple))
                                                Text("Shared.Guide.StrokeReverseLookup.Body")
                                                Text("Shared.Guide.StrokeReverseLookup.Examples").monospaced()
                                        }
                                        Section {
                                                Label("Shared.Guide.StructureReverseLookup.Heading", systemImage: "q.square").labelStyle(.headline(iconColor: .mint))
                                                Text("Shared.Guide.StructureReverseLookup.Body")
                                        }
                                        Section {
                                                Label("Shared.Guide.TonesInput.Heading", systemImage: "bell").labelStyle(.headline(iconColor: .orange))
                                                Text("Shared.Guide.TonesInput.Body").monospaced()
                                                Text("Shared.Guide.TonesInput.Examples")
                                        }
                                }
                                .textSelection(.enabled)

                                Section {
                                        NavigationLink(destination: IntroductionsView()) {
                                                Label("IOSHomeTab.LabelTitle.MoreIntroductions", systemImage: "info.circle")
                                        }
                                        NavigationLink(destination: ClipboardFeaturesView()) {
                                                Label("IOSHomeTab.LabelTitle.ClipboardFeatures", systemImage: "list.clipboard")
                                        }
                                        NavigationLink(destination: ChangeDisplayLanguageView()) {
                                                Label("IOSHomeTab.LabelTitle.ChangeDisplayLanguage", systemImage: "globe.asia.australia")
                                        }
                                        NavigationLink(destination: FAQView()) {
                                                Label("IOSHomeTab.LabelTitle.FAQ", systemImage: "questionmark.circle")
                                        }
                                }
                                Section {
                                        NavigationLink(destination: InputTestView()) {
                                                Label("IOSHomeTab.LabelTitle.InputTest", systemImage: "keyboard")
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
        }
}

#endif
