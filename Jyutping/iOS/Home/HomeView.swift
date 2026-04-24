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
                                                        .contentShape(Rectangle())
                                                }
                                                .buttonStyle(.plain)
                                        } else {
                                                HStack(spacing: 16) {
                                                        Image(systemName: "keyboard").font(.title3).foregroundStyle(Color.accentColor)
                                                        Text("IOSHomeTab.Heading.HowToEnableThisKeyboard").font(.headline)
                                                }
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
                                                Label("IOSHomeTab.LabelTitle.ProblemsWithEnablingKeyboard", systemImage: "info.circle")
                                        }
                                }

                                Group {
                                        Section {
                                                HeadlineLabel(title: "Shared.Guide.AbbreviatedInput.Heading", icon: "sparkles", iconTint: .green)
                                                Text("Shared.Guide.AbbreviatedInput.Body.Row1")
                                                Text("Shared.Guide.AbbreviatedInput.Body.Row2")
                                        }
                                        Section {
                                                HeadlineLabel(title: "Shared.Guide.PinyinReverseLookup.Heading", icon: "r.square", iconTint: .red)
                                                Text("Shared.Guide.PinyinReverseLookup.Body")
                                        }
                                        Section {
                                                HeadlineLabel(title: "Shared.Guide.CangjieReverseLookup.Heading", icon: "v.square", iconTint: .blue)
                                                Text("Shared.Guide.CangjieReverseLookup.Body")
                                        } footer: {
                                                Text("Shared.Guide.CangjieReverseLookup.Note").textCase(nil)
                                        }
                                        Section {
                                                HeadlineLabel(title: "Shared.Guide.StrokeReverseLookup.Heading", icon: "x.square", iconTint: .purple)
                                                Text("Shared.Guide.StrokeReverseLookup.Body")
                                                Text("Shared.Guide.StrokeReverseLookup.Examples").monospaced()
                                        }
                                        Section {
                                                HeadlineLabel(title: "Shared.Guide.StructureReverseLookup.Heading", icon: "q.square", iconTint: .mint)
                                                Text("Shared.Guide.StructureReverseLookup.Body")
                                        }
                                        Section {
                                                HeadlineLabel(title: "Shared.Guide.TonesInput.Heading", icon: "bell", iconTint: .orange)
                                                Text("Shared.Guide.TonesInput.Body").monospaced()
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
                                                Label("IOSHomeTab.LabelTitle.ClipboardFeatures", systemImage: "list.clipboard")
                                        }
                                        NavigationLink(destination: ChangeDisplayLanguageView()) {
                                                Label("IOSHomeTab.LabelTitle.ChangeDisplayLanguage", systemImage: "globe.asia.australia")
                                        }
                                        NavigationLink(destination: FAQView()) {
                                                Label("IOSHomeTab.LabelTitle.FAQ", systemImage: "questionmark.circle")
                                        }
                                }
                                #if DEBUG
                                Section {
                                        NavigationLink(destination: InputTestView()) {
                                                Label("IOSHomeTab.LabelTitle.InputTest", systemImage: "keyboard")
                                        }
                                }
                                #endif
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
