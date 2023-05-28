#if os(iOS)

import SwiftUI

struct HomeView: View {

        @State private var animationState: Int = 0

        @State private var isKeyboardEnabled: Bool = {
                guard let keyboards: [String] = UserDefaults.standard.object(forKey: "AppleKeyboards") as? [String] else { return false }
                return keyboards.contains("im.cantonese.CantoneseIM.Keyboard")
        }()
        @State private var isGuideViewExpanded: Bool = false

        var body: some View {
                NavigationView {
                        List {
                                SearchView(placeholder: "Text Field", submitLabel: .return, animationState: $animationState)

                                Section {
                                        if isKeyboardEnabled {
                                                HStack {
                                                        Text("How to enable this Keyboard")
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
                                                Text("How to enable this Keyboard").font(.significant)
                                        }
                                        if !isKeyboardEnabled || isGuideViewExpanded {
                                                VStack(spacing: 5) {
                                                        HStack {
                                                                Text.dotMark
                                                                Text("Jump to **Settings**")
                                                                Spacer()
                                                        }
                                                        HStack {
                                                                Text.dotMark
                                                                Text("Tap **Keyboards**")
                                                                Spacer()
                                                        }
                                                        HStack {
                                                                Text.dotMark
                                                                Text("Turn on **Jyutping**")
                                                                Spacer()
                                                        }
                                                        HStack {
                                                                Text.dotMark
                                                                Text("Turn on **Allow Full Access**")
                                                                Spacer()
                                                        }
                                                }
                                                .accessibilityLabel("accessibility.how_to_enable_this_keyboard")
                                        }
                                } footer: {
                                        if !isKeyboardEnabled || isGuideViewExpanded {
                                                Text("Haptic Feedback requires Full Access").textCase(nil)
                                        } else {
                                                EmptyView()
                                        }
                                }
                                if !isKeyboardEnabled || isGuideViewExpanded {
                                        Section {
                                                Button {
                                                        guard let url: URL = URL(string: UIApplication.openSettingsURLString) else { return }
                                                        UIApplication.shared.open(url)
                                                } label: {
                                                        HStack{
                                                                Spacer()
                                                                Text("Go to **Settings**")
                                                                Spacer()
                                                        }
                                                }
                                        }
                                }

                                Group {
                                        Section {
                                                Text("Tones Input").font(.significant)
                                                Text("tones.input.description")
                                                        .font(.fixedWidth)
                                                        .lineSpacing(5)
                                                        .fixedSize(horizontal: true, vertical: false)
                                                Text("tones.input.examples")
                                        }
                                        Section {
                                                Text("Lookup Jyutping with Cangjie").font(.significant)
                                                Text("Cangjie Reverse Lookup Description").lineSpacing(6)
                                        }
                                        Section {
                                                Text("Lookup Jyutping with Pinyin").font(.significant)
                                                Text("Pinyin Reverse Lookup Description").lineSpacing(6)
                                        }
                                        Section {
                                                Text("Lookup Jyutping with Stroke").font(.significant)
                                                Text("Stroke Reverse Lookup Description").lineSpacing(6)
                                                Text(verbatim: Constant.strokeKeyDefinitions).font(.fixedWidth).lineSpacing(5)
                                        }
                                        Section {
                                                Text("Lookup Jyutping with Loengfan").font(.significant)
                                                Text("Loengfan Reverse Lookup Description").lineSpacing(6)
                                        }
                                }
                                .textSelection(.enabled)

                                Section {
                                        NavigationLink(destination: IntroductionsView()) {
                                                Label("More Introductions", systemImage: "info.circle")
                                        }
                                        NavigationLink(destination: Text2SpeechView()) {
                                                Label("Text to Speech", systemImage: "speaker.wave.2")
                                        }
                                        NavigationLink(destination: FAQView()) {
                                                Label("FAQ", systemImage: "questionmark.circle")
                                        }
                                        NavigationLink(destination: PrivacyNoticeView()) {
                                                Label("Privacy Notice", systemImage: "lock.circle")
                                        }
                                }
                        }
                        .animation(.default, value: animationState)
                        .animation(.default, value: isGuideViewExpanded)
                        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                                guard let keyboards: [String] = UserDefaults.standard.object(forKey: "AppleKeyboards") as? [String] else { return }
                                let isContained: Bool =  keyboards.contains("im.cantonese.CantoneseIM.Keyboard")
                                if isKeyboardEnabled != isContained {
                                        isKeyboardEnabled = isContained
                                }
                        }
                        .navigationTitle("Home")
                }
                .navigationViewStyle(.stack)
        }
}

#endif
