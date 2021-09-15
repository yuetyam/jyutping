import SwiftUI

struct AcknowledgementsView: View {
        var body: some View {
                if #available(iOS 15.0, *) {
                        List {
                                Section {
                                        LinkSafariView(url: URL(string: "https://github.com/rime/rime-cantonese")!) {
                                                FootnoteLabelView(icon: "book", title: Text(verbatim: "Rime Cantonese"), footnote: "© CanCLID. CC BY 4.0")
                                        }
                                }
                                Section {
                                        LinkSafariView(url: URL(string: "https://github.com/BYVoid/OpenCC")!) {
                                                FootnoteLabelView(icon: "briefcase", title: Text(verbatim: "OpenCC"), footnote: "© Carbo Kuo. Apache 2.0")
                                        }
                                }
                        }
                        .navigationTitle("Acknowledgements")
                        .navigationBarTitleDisplayMode(.inline)
                } else if #available(iOS 14.0, *) {
                        List {
                                Section {
                                        LinkSafariView(url: URL(string: "https://github.com/rime/rime-cantonese")!) {
                                                FootnoteLabelView(icon: "book", title: Text(verbatim: "Rime Cantonese"), footnote: "© CanCLID. CC BY 4.0")
                                        }
                                }
                                Section {
                                        LinkSafariView(url: URL(string: "https://github.com/BYVoid/OpenCC")!) {
                                                FootnoteLabelView(icon: "briefcase", title: Text(verbatim: "OpenCC"), footnote: "© Carbo Kuo. Apache 2.0")
                                        }
                                }
                        }
                        .listStyle(.insetGrouped)
                        .navigationTitle("Acknowledgements")
                        .navigationBarTitleDisplayMode(.inline)
                } else {
                        List {
                                Section {
                                        LinkSafariView(url: URL(string: "https://github.com/rime/rime-cantonese")!) {
                                                FootnoteLabelView(icon: "book", title: Text(verbatim: "Rime Cantonese"), footnote: "© CanCLID. CC BY 4.0")
                                        }
                                }
                                Section {
                                        LinkSafariView(url: URL(string: "https://github.com/BYVoid/OpenCC")!) {
                                                FootnoteLabelView(icon: "briefcase", title: Text(verbatim: "OpenCC"), footnote: "© Carbo Kuo. Apache 2.0")
                                        }
                                }
                        }
                        .listStyle(.grouped)
                        .navigationBarTitle("Acknowledgements", displayMode: .inline)
                }
        }
}
