import SwiftUI
import StoreKit

@available(iOS 15.0, *)
private class DonateViewModel: ObservableObject {

        @Published private(set) var products: [Product] = []

        init() {
                checkUpdates()
        }

        func fetchProducts() {
                Task {
                        let products = try await Product.products(for: [
                                DonationID.supportAuthor,
                                DonationID.supportAuthorPlus,
                                DonationID.supportAuthorMax
                        ])
                        DispatchQueue.main.async {
                                self.products = products
                        }
                }
        }

        func purchase(id: String) {
                Task {
                        guard let product = products.filter({ $0.id == id }).first else { return }
                        let result = try await product.purchase()
                        switch result {
                        case .success(let verification):
                                switch verification {
                                case .verified(let transaction):
                                        await transaction.finish()
                                case .unverified:
                                        break
                                }
                        case .pending:
                                break
                        case .userCancelled:
                                break
                        @unknown default:
                                break
                        }
                }
        }

        private func checkUpdates() {
                Task(priority: .background) {
                        for await _ in Transaction.updates {
                        }
                }
        }
}


private struct DonationID {
        static let supportAuthor: String = "im.cantonese.CantoneseIM.support.author"
        static let supportAuthorPlus: String = "im.cantonese.CantoneseIM.support.author.plus"
        static let supportAuthorMax: String = "im.cantonese.CantoneseIM.support.author.max"
}


@available(iOS 15.0, *)
struct DonationView: View {

        @StateObject private var donateViewModel: DonateViewModel = DonateViewModel()

        var body: some View {
                List {
                        Section {
                                Button {
                                        donateViewModel.purchase(id: DonationID.supportAuthor)
                                } label: {
                                        HStack {
                                                Spacer()
                                                if let item = donateViewModel.products.filter({ $0.id == DonationID.supportAuthor }).first {
                                                        Text(verbatim: item.displayName)
                                                        Text(verbatim: item.displayPrice)
                                                } else {
                                                        Text("Support Author")
                                                }
                                                Spacer()
                                        }
                                }
                        }
                        Section {
                                Button {
                                        donateViewModel.purchase(id: DonationID.supportAuthorPlus)
                                } label: {
                                        HStack {
                                                Spacer()
                                                if let item = donateViewModel.products.filter({ $0.id == DonationID.supportAuthorPlus }).first {
                                                        Text(verbatim: item.displayName)
                                                        Text(verbatim: item.displayPrice)
                                                } else {
                                                        Text("Support Author Plus")
                                                }
                                                Spacer()
                                        }
                                }
                        }
                        Section {
                                Button {
                                        donateViewModel.purchase(id: DonationID.supportAuthorMax)
                                } label: {
                                        HStack {
                                                Spacer()
                                                if let item = donateViewModel.products.filter({ $0.id == DonationID.supportAuthorMax }).first {
                                                        Text(verbatim: item.displayName)
                                                        Text(verbatim: item.displayPrice)
                                                } else {
                                                        Text("Support Author Max")
                                                }
                                                Spacer()
                                        }
                                }
                        }
                }
                .task {
                        donateViewModel.fetchProducts()
                }
                .navigationTitle("Thank You")
                .navigationBarTitleDisplayMode(.inline)
        }
}

