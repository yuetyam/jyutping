import SwiftUI

struct MacAboutView: View {
        var body: some View {
                List {
                        Section {
                                HStack(spacing: 32) {
                                        Label("Version", systemImage: "info.circle")
                                        Text(verbatim: AppMaster.version)
                                        Spacer()
                                }
                        }
                        Section {
                                HStack(spacing: 32) {
                                        Link(destination: URL(string: "https://ososo.io")!) {
                                                Label("Website", systemImage: "globe.asia.australia")
                                        }
                                        Text(verbatim: "https://ososo.io").font(.body.monospaced())
                                        Spacer()
                                }
                                HStack(spacing: 32) {
                                        Link(destination: URL(string: "https://github.com/yuetyam/jyutping")!) {
                                                Label("Source Code", systemImage: "chevron.left.forwardslash.chevron.right")
                                        }
                                        Text(verbatim: "https://github.com/yuetyam/jyutping").font(.body.monospaced())
                                        Spacer()
                                }
                                HStack(spacing: 32) {
                                        Link(destination: URL(string: "https://ososo.io/jyutping/privacy")!) {
                                                Label("Privacy Policy", systemImage: "lock.circle")
                                        }
                                        Text(verbatim: "https://ososo.io/jyutping/privacy").font(.body.monospaced())
                                        Spacer()
                                }
                        }
                        Section {
                                HStack(spacing: 32) {
                                        Link(destination: URL(string: "https://t.me/jyutping")!) {
                                                Label("Telegram Group", systemImage: "paperplane")
                                        }
                                        Text(verbatim: "https://t.me/jyutping").font(.body.monospaced())
                                        Spacer()
                                }
                                HStack(spacing: 32) {
                                        Link(destination: URL(string: #"https://jq.qq.com/?k=4PR17m3t"#)!) {
                                                Label("QQ Group", systemImage: "person.2")
                                        }
                                        Text(verbatim: "293148593").font(.body.monospaced())
                                        Spacer()
                                }
                        }
                        Section {
                                HStack(spacing: 32) {
                                        Link(destination: URL(string: "https://truthsocial.com/@Cantonese")!) {
                                                Label("TRUTH Social", systemImage: "t.square")
                                        }
                                        Text(verbatim: "https://truthsocial.com/@Cantonese").font(.body.monospaced())
                                        Spacer()
                                }
                                HStack(spacing: 32) {
                                        Link(destination: URL(string: "https://twitter.com/JyutpingApp")!) {
                                                Label("Twitter", systemImage: "at")
                                        }
                                        Text(verbatim: "https://twitter.com/JyutpingApp").font(.body.monospaced())
                                        Spacer()
                                }
                                HStack(spacing: 32) {
                                        Link(destination: URL(string: "https://www.instagram.com/jyutping_app")!) {
                                                Label("Instagram", systemImage: "circle.square")
                                        }
                                        Text(verbatim: "https://www.instagram.com/jyutping_app").font(.body.monospaced())
                                        Spacer()
                                }
                        }
                }
                .textSelection(.enabled)
                .navigationTitle("About")
        }
}
