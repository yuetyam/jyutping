import SwiftUI

@available(iOS 15.0, *)
struct DonationView: View {

        var body: some View {
                List {
                        Section {
                                Button {
                                        print("IAP")
                                } label: {
                                        HStack {
                                                Spacer()
                                                Text("Support Author")
                                                Text(verbatim: "$0.99")
                                                Spacer()
                                        }
                                }
                        }
                        Section {
                                Button {
                                        print("IAP")
                                } label: {
                                        HStack {
                                                Spacer()
                                                Text("Support Author Plus")
                                                Text(verbatim: "$1.99")
                                                Spacer()
                                        }
                                }
                        }
                        Section {
                                Button {
                                        print("IAP")
                                } label: {
                                        HStack {
                                                Spacer()
                                                Text("Support Author Max")
                                                Text(verbatim: "$5.99")
                                                Spacer()
                                        }
                                }
                        }
                }
                .navigationTitle("Thank You")
                .navigationBarTitleDisplayMode(.inline)
        }
}

