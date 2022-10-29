import SwiftUI
import CommonExtensions

struct CandidateFontPreferencesView: View {

        @AppStorage(SettingsKeys.CandidateFontSize) private var candidateFontSize: Int = Int(AppSettings.candidateFontSize)
        @AppStorage(SettingsKeys.CommentFontSize) private var commentFontSize: Int = Int(AppSettings.commentFontSize)
        @AppStorage(SettingsKeys.LabelFontSize) private var labelFontSize: Int = Int(AppSettings.labelFontSize)

        @AppStorage(SettingsKeys.CandidateFontMode) private var candidateFontMode: Int = AppSettings.candidateFontMode.rawValue
        @AppStorage(SettingsKeys.CommentFontMode) private var commentFontMode: Int = AppSettings.commentFontMode.rawValue
        @AppStorage(SettingsKeys.LabelFontMode) private var labelFontMode: Int = AppSettings.labelFontMode.rawValue

        @AppStorage(SettingsKeys.CustomCandidateFontList) private var customCandidateFontList: String = AppSettings.customCandidateFonts.joined(separator: ",")
        @AppStorage(SettingsKeys.CustomCommentFontList) private var customCommentFontList: String = AppSettings.customCommentFonts.joined(separator: ",")
        @AppStorage(SettingsKeys.CustomLabelFontList) private var customLabelFontList: String = AppSettings.customLabelFonts.joined(separator: ",")

        @State private var availableFonts: [String] = ["PingFang HK", "Helvetica Neue", "Menlo"]
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
                                                        AppSettings.updateCandidateFontSize(to: newFontSize)
                                                        DispatchQueue.preferences.async {
                                                                Font.updateCandidateFont(size: CGFloat(newFontSize))
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
                                                        AppSettings.updateCandidateFontMode(to: newMode)
                                                        DispatchQueue.preferences.async {
                                                                switch newMode {
                                                                case .default:
                                                                        Font.updateCandidateFont()
                                                                case .system:
                                                                        Font.updateCandidateFont(isSystemFontPreferred: true)
                                                                case .custom:
                                                                        Font.updateCandidateFont()
                                                                }
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
                                                                                Image(systemName: "minus")
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
                                                                        customCandidateFonts.append("PingFang HK")
                                                                } label: {
                                                                        Image(systemName: "plus")
                                                                }
                                                                Spacer()
                                                        }
                                                        Spacer()
                                                }
                                                .onChange(of: customCandidateFonts) { newFontNames in
                                                        customCandidateFontList = newFontNames.filter({ !($0.isEmpty) }).map({ $0.trimmed() }).uniqued().joined(separator: ",")
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateCustomCandidateFonts(to: newFontNames)
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
                                                        AppSettings.updateCommentFontSize(to: newFontSize)
                                                        DispatchQueue.preferences.async {
                                                                Font.updateCommentFont(size: CGFloat(newFontSize))
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
                                                        AppSettings.updateCommentFontMode(to: newMode)
                                                        DispatchQueue.preferences.async {
                                                                switch newMode {
                                                                case .default:
                                                                        Font.updateCommentFont()
                                                                case .system:
                                                                        Font.updateCommentFont()
                                                                case .custom:
                                                                        Font.updateCommentFont()
                                                                }
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
                                                                                Image(systemName: "minus")
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
                                                                        customCommentFonts.append("Helvetica Neue")
                                                                } label: {
                                                                        Image(systemName: "plus")
                                                                }
                                                                Spacer()
                                                        }
                                                        Spacer()
                                                }
                                                .onChange(of: customCommentFonts) { newFontNames in
                                                        customCommentFontList = newFontNames.filter({ !($0.isEmpty) }).map({ $0.trimmed() }).uniqued().joined(separator: ",")
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateCustomCommentFonts(to: newFontNames)
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
                                                        AppSettings.updateLabelFontSize(to: newFontSize)
                                                        DispatchQueue.preferences.async {
                                                                Font.updateLabelFont(size: CGFloat(newFontSize))
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
                                                        AppSettings.updateLabelFontMode(to: newMode)
                                                        DispatchQueue.preferences.async {
                                                                switch newMode {
                                                                case .default:
                                                                        Font.updateLabelFont()
                                                                case .system:
                                                                        Font.updateLabelFont()
                                                                case .custom:
                                                                        Font.updateLabelFont()
                                                                }
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
                                                                                Image(systemName: "minus")
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
                                                                        customLabelFonts.append("Menlo")
                                                                } label: {
                                                                        Image(systemName: "plus")
                                                                }
                                                                Spacer()
                                                        }
                                                        Spacer()
                                                }
                                                .onChange(of: customLabelFonts) { newFontNames in
                                                        customLabelFontList = newFontNames.filter({ !($0.isEmpty) }).map({ $0.trimmed() }).uniqued().joined(separator: ",")
                                                        DispatchQueue.preferences.async {
                                                                AppSettings.updateCustomLabelFonts(to: newFontNames)
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
                                        .filter({ !($0.isEmpty || $0.hasPrefix(".") || noGoodList.contains($0)) })
                                        .map({ $0.trimmed() })
                                        .uniqued()
                                return filtered
                        }()
                        customCandidateFonts = customCandidateFontList.components(separatedBy: ",").filter({ !($0.isEmpty) }).map({ $0.trimmed() }).uniqued()
                        customCommentFonts = customCommentFontList.components(separatedBy: ",").filter({ !($0.isEmpty) }).map({ $0.trimmed() }).uniqued()
                        customLabelFonts = customLabelFontList.components(separatedBy: ",").filter({ !($0.isEmpty) }).map({ $0.trimmed() }).uniqued()
                }
                .navigationTitle("PreferencesView.NavigationTitle.Fonts")
        }
}
