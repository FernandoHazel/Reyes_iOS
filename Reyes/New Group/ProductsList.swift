import SwiftUI

struct ProductsList: View {
    var body: some View {
        
        
        NavigationSplitView {
            List(products) { product in
                NavigationLink {
                    ProductDetail(product: product)
                } label: {
                    ProductRow(product: product)
                }
            }
            .navigationTitle("Productos")
        } detail: {
            Text("Selecciona un producto")
        }
    }
}

#Preview {
    ProductsList()
}
