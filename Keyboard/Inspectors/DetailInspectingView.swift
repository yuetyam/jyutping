import SwiftUI
import CommonExtensions
import CoreIME

struct DetailInspectingView: View {
        @EnvironmentObject private var context: KeyboardViewController
        @State private var inputFrequency: Int64 = 0
        @State private var latestDate: String? = nil
        var body: some View {
                let candidate = context.inspectingCandidate
                VStack(spacing: 0) {
                        NavigationBar()
                        ScrollView(.vertical) {
                                LazyVStack(alignment: .leading, spacing: 16) {
                                        switch candidate.lexicon.type {
                                        case .text, .composed:
                                                Text(verbatim: candidate.text).font(.title).padding()
                                        case .emoji, .symbol:
                                                SymbolCandidateDetailView(candidate: candidate)
                                        case .cantonese:
                                                ZStack {
                                                        RoundedRectangle(cornerRadius: PresetConstant.sectionCornerRadius).fill(Material.ultraThick)
                                                        CandidateDetailSummaryView(candidate: candidate, inputFrequency: inputFrequency, latestDate: latestDate).padding(10)
                                                }
                                                .padding(.horizontal, 10)
                                                .padding(.top, 10)
                                                if inputFrequency > 0 {
                                                        Menu {
                                                                Button(role: .destructive) {
                                                                        context.performAudioFeedback(.delete)
                                                                        context.triggerHapticFeedback()
                                                                        InputMemory.forget(candidate.lexicon)
                                                                        inputFrequency = 0
                                                                        latestDate = nil
                                                                } label: {
                                                                        Label("DetailInspectingView.ForgetCandidate.ButtonTitle", systemImage: "trash")
                                                                }
                                                        } label: {
                                                                HStack {
                                                                        Spacer()
                                                                        Text("DetailInspectingView.ForgetCandidate.ButtonTitle").foregroundStyle(Color.red)
                                                                        Spacer()
                                                                }
                                                                .frame(minHeight: 44)
                                                                .background(Material.regular, in: .capsule)
                                                                .contentShape(.rect)
                                                        }
                                                        .padding(.horizontal, 10)
                                                }
                                        }
                                }
                        }
                }
                .task {
                        let inspected = InputMemory.inspect(lexicon: candidate.lexicon)
                        if inspected.frequency > 0 {
                                inputFrequency = inspected.frequency
                                latestDate = convert(latest: inspected.latest)
                        }
                }
        }
        private func convert(latest: Int64) -> String {
                let timestamp: TimeInterval = Double(latest) / 1000.0
                let date = Date(timeIntervalSince1970: timestamp)
                return DateFormatter.humanFriendly.string(from: date)
        }
}
