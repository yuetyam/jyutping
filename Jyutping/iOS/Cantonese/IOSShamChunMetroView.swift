#if os(iOS)

import SwiftUI
import AppDataSource

struct IOSShamChunMetroView: View {

        @State private var lines: [Metro.Line] = []
        @State private var expanded: [Bool] = Array(repeating: false, count: 40)

        var body: some View {
                if #available(iOS 17.0, *) {
                        List {
                                ForEach(lines.indices, id: \.self) { index in
                                        Section {
                                                IOSMetroLineView(line: lines[index], isExpanded: $expanded[index])
                                        }
                                }
                        }
                        .listSectionSpacing(12)
                        .animation(.default, value: expanded)
                        .task {
                                guard lines.isEmpty else { return }
                                lines = Metro.shamchunMetroLines
                        }
                        .navigationTitle("IOSCantoneseTab.NavigationTitle.ShamChunMetro")
                        .navigationBarTitleDisplayMode(.inline)
                } else {
                        List {
                                ForEach(lines.indices, id: \.self) { index in
                                        Section {
                                                IOSMetroLineView(line: lines[index], isExpanded: $expanded[index])
                                        }
                                }
                        }
                        .animation(.default, value: expanded)
                        .task {
                                guard lines.isEmpty else { return }
                                lines = Metro.shamchunMetroLines
                        }
                        .navigationTitle("IOSCantoneseTab.NavigationTitle.ShamChunMetro")
                        .navigationBarTitleDisplayMode(.inline)
                }
        }
}

#endif
