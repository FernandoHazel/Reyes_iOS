import SwiftUI

struct ProductsList: View {
    var body: some View {
        
        
        NavigationView {
            List(products) { product in
                NavigationLink {
                    ProductDetail(product: product)
                } label: {
                    ProductRow(product: product)
                }
            }
            .navigationTitle("Tienda")
        }
    }
}

#Preview {
    ProductsList()
}
