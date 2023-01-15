import SwiftUI
import CommonExtensions

struct CandidateFontPreferencesView: View {

        private let minusImage: Image = Image(systemName: "minus")
        private let plusImage: Image = Image(systemName: "plus")

        @AppStorage(SettingsKeys.CandidateFontSize) private var candidateFontSize: Int = Int(AppSettings.candidateFontSize)
        @AppStorage(SettingsKeys.CommentFontSize) private var commentFontSize: Int = Int(AppSettings.commentFontSize)
        @AppStorage(SettingsKeys.LabelFontSize) private var labelFontSize: Int = Int(AppSettings.labelFontSize)

        @AppStorage(SettingsKeys.CandidateFontMode) private var candidateFontMode: Int = AppSettings.candidateFontMode.rawValue
        @AppStorage(SettingsKeys.CommentFontMode) private var commentFontMode: Int = AppSettings.commentFontMode.rawValue
        @AppStorage(SettingsKeys.LabelFontMode) private var labelFontMode: Int = AppSettings.labelFontMode.rawValue

        @AppStorage(SettingsKeys.CustomCandidateFontList) private var customCandidateFontList: String = AppSettings.customCandidateFonts.joined(separator: ",")
        @AppStorage(SettingsKeys.CustomCommentFontList) private var customCommentFontList: String = AppSettings.customCommentFonts.joined(separator: ",")
        @AppStorage(SettingsKeys.CustomLabelFontList) private var customLabelFontList: String = AppSettings.customLabelFonts.joined(separator: ",")

        @State private var availableFonts: [String] = [Constant.HelveticaNeue, Constant.Menlo, Constant.PingFangHK]
        @State private var customCandidateFonts: [String] = AppSettings.customCandidateFonts
        @State private var customCommentFonts: [String] = AppSettings.customCommentFonts
        @State private var customLabelFonts: [String] = AppSettings.customLabelFonts

        var body: some View {
                ScrollView {
                        LazyVStack(spacing: 16) {
                                VStack {
                                        HStack {
                                                Picker("Candidate Font Size", selection: $candidateFontSize) {
                                                        ForEach(12..<23, id: \.self) {
                                                                Text(verbatim: "\($0)").tag($0)
                                                        }
                                                }
                                                .scaledToFit()
                                                .onChange(of: candidateFontSize) { newFontSize in
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateCandidateFontSize(to: newFontSize)
                                                        }
                                                }
                                                Spacer()
                                        }
                                        HStack {
                                                Picker("Candidate Font", selection: $candidateFontMode) {
                                                        Text("Default").tag(1)
                                                        Text("System").tag(2)
                                                        Text("Custom").tag(3)
                                                }
                                                .pickerStyle(.radioGroup)
                                                .scaledToFit()
                                                .onChange(of: candidateFontMode) { newValue in
                                                        let newMode: FontMode = FontMode.mode(of: newValue)
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateCandidateFontMode(to: newMode)
                                                        }
                                                }
                                                Spacer()
                                        }
                                        if candidateFontMode == 3 {
                                                VStack {
                                                        ForEach(0..<customCandidateFonts.count, id: \.self) { index in
                                                                HStack {
                                                                        Button {
                                                                                customCandidateFonts.remove(at: index)
                                                                        } label: {
                                                                                minusImage
                                                                        }
                                                                        Picker("Font", selection: $customCandidateFonts[index]) {
                                                                                ForEach(0..<availableFonts.count, id: \.self) {
                                                                                        let fontName: String = availableFonts[$0]
                                                                                        Text(verbatim: fontName)
                                                                                                .font(.footnote)
                                                                                                .tag(fontName)
                                                                                }
                                                                        }
                                                                        .scaledToFit()
                                                                        .labelsHidden()
                                                                        Spacer()
                                                                }
                                                        }
                                                        HStack {
                                                                Button {
                                                                        customCandidateFonts.append(Constant.PingFangHK)
                                                                } label: {
                                                                        plusImage
                                                                }
                                                                Spacer()
                                                        }
                                                        Spacer()
                                                }
                                                .onChange(of: customCandidateFonts) { newFontNames in
                                                        let newList: [String] = newFontNames.map({ $0.trimmed() }).filter({ !($0.isEmpty) }).uniqued()
                                                        customCandidateFontList = newList.joined(separator: ",")
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateCustomCandidateFonts(to: newList)
                                                        }
                                                }
                                        }
                                }
                                .block()
                                VStack {
                                        HStack {
                                                Picker("Comment Font Size", selection: $commentFontSize) {
                                                        ForEach(12..<23, id: \.self) {
                                                                Text(verbatim: "\($0)").tag($0)
                                                        }
                                                }
                                                .scaledToFit()
                                                .onChange(of: commentFontSize) { newFontSize in
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateCommentFontSize(to: newFontSize)
                                                        }
                                                }
                                                Spacer()
                                        }
                                        HStack {
                                                Picker("Comment Font", selection: $commentFontMode) {
                                                        Text("Default").tag(1)
                                                        Text("System").tag(2)
                                                        Text("Custom").tag(3)
                                                }
                                                .pickerStyle(.radioGroup)
                                                .scaledToFit()
                                                .onChange(of: commentFontMode) { newValue in
                                                        let newMode: FontMode = FontMode.mode(of: newValue)
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateCommentFontMode(to: newMode)
                                                        }
                                                }
                                                Spacer()
                                        }
                                        if commentFontMode == 3 {
                                                VStack {
                                                        ForEach(0..<customCommentFonts.count, id: \.self) { index in
                                                                HStack {
                                                                        Button {
                                                                                customCommentFonts.remove(at: index)
                                                                        } label: {
                                                                                minusImage
                                                                        }
                                                                        Picker("Font", selection: $customCommentFonts[index]) {
                                                                                ForEach(0..<availableFonts.count, id: \.self) {
                                                                                        let fontName: String = availableFonts[$0]
                                                                                        Text(verbatim: fontName)
                                                                                                .font(.footnote)
                                                                                                .tag(fontName)
                                                                                }
                                                                        }
                                                                        .scaledToFit()
                                                                        .labelsHidden()
                                                                        Spacer()
                                                                }
                                                        }
                                                        HStack {
                                                                Button {
                                                                        customCommentFonts.append(Constant.HelveticaNeue)
                                                                } label: {
                                                                        plusImage
                                                                }
                                                                Spacer()
                                                        }
                                                        Spacer()
                                                }
                                                .onChange(of: customCommentFonts) { newFontNames in
                                                        let newList: [String] = newFontNames.map({ $0.trimmed() }).filter({ !($0.isEmpty) }).uniqued()
                                                        customCommentFontList = newList.joined(separator: ",")
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateCustomCommentFonts(to: newList)
                                                        }
                                                }
                                        }
                                }
                                .block()
                                VStack {
                                        HStack {
                                                Picker("Serial Number Font Size", selection: $labelFontSize) {
                                                        ForEach(12..<23, id: \.self) {
                                                                Text(verbatim: "\($0)").tag($0)
                                                        }
                                                }
                                                .scaledToFit()
                                                .onChange(of: labelFontSize) { newFontSize in
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateLabelFontSize(to: newFontSize)
                                                        }
                                                }
                                                Spacer()
                                        }
                                        HStack {
                                                Picker("Serial Number Font", selection: $labelFontMode) {
                                                        Text("Default").tag(1)
                                                        Text("System").tag(2)
                                                        Text("Custom").tag(3)
                                                }
                                                .pickerStyle(.radioGroup)
                                                .scaledToFit()
                                                .onChange(of: labelFontMode) { newValue in
                                                        let newMode: FontMode = FontMode.mode(of: newValue)
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateLabelFontMode(to: newMode)
                                                        }
                                                }
                                                Spacer()
                                        }
                                        if labelFontMode == 3 {
                                                VStack {
                                                        ForEach(0..<customLabelFonts.count, id: \.self) { index in
                                                                HStack {
                                                                        Button {
                                                                                customLabelFonts.remove(at: index)
                                                                        } label: {
                                                                                minusImage
                                                                        }
                                                                        Picker("Font", selection: $customLabelFonts[index]) {
                                                                                ForEach(0..<availableFonts.count, id: \.self) {
                                                                                        let fontName: String = availableFonts[$0]
                                                                                        Text(verbatim: fontName)
                                                                                                .font(.footnote)
                                                                                                .tag(fontName)
                                                                                }
                                                                        }
                                                                        .scaledToFit()
                                                                        .labelsHidden()
                                                                        Spacer()
                                                                }
                                                        }
                                                        HStack {
                                                                Button {
                                                                        customLabelFonts.append(Constant.Menlo)
                                                                } label: {
                                                                        plusImage
                                                                }
                                                                Spacer()
                                                        }
                                                        Spacer()
                                                }
                                                .onChange(of: customLabelFonts) { newFontNames in
                                                        let newList: [String] = newFontNames.map({ $0.trimmed() }).filter({ !($0.isEmpty) }).uniqued()
                                                        customLabelFontList = newList.joined(separator: ",")
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateCustomLabelFonts(to: newList)
                                                        }
                                                }
                                        }
                                }
                                .block()
                        }
                        .textSelection(.enabled)
                        .padding()
                }
                .task {
                        let noGoodList: Set<String> = [
                                "Bodoni Ornaments",
                                "GB18030 Bitmap",
                                "Toppan Bunkyu Midashi Gothic",
                                "Toppan Bunkyu Midashi Mincho",
                                "Webdings",
                                "Wingdings",
                                "Wingdings 2",
                                "Wingdings 3",
                                "Zapf Dingbats",
                                "Zapfino"
                        ]
                        availableFonts = {
                                let allAvailableFonts: [String] = NSFontManager.shared.availableFontFamilies
                                let filtered: [String] = allAvailableFonts
                                        .map({ $0.trimmed() })
                                        .filter({ !($0.isEmpty || $0.hasPrefix(".") || noGoodList.contains($0)) })
                                        .uniqued()
                                return filtered
                        }()
                        customCandidateFonts = customCandidateFontList.components(separatedBy: ",").map({ $0.trimmed() }).filter({ !($0.isEmpty) }).uniqued()
                        customCommentFonts = customCommentFontList.components(separatedBy: ",").map({ $0.trimmed() }).filter({ !($0.isEmpty) }).uniqued()
                        customLabelFonts = customLabelFontList.components(separatedBy: ",").map({ $0.trimmed() }).filter({ !($0.isEmpty) }).uniqued()
                }
                .navigationTitle("PreferencesView.NavigationTitle.Fonts")
        }
}
