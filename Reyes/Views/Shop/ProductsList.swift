import SwiftUI

struct ProductsList: View {
    var body: some View {
        NavigationView {
            List(products) { product in
                NavigationLink {
                    ProductDetail(product: product)
                } label: {
                    ProductRow(product: product)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Tienda")
            .listStyle(.inset)
        }
    }
}

#Preview {
    ProductsList()
}
