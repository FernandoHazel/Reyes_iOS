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
            .navigationTitle("Tienda")
        } detail: {
            Text("Selecciona un producto")
        }
        
        Group {
            NavigationView {
                HStack {
                    Text("¿Ya tienes una cuenta?")
                    NavigationLink(
                        destination: SingIn(),
                        label: {
                            Text("Ingresa")
                        })
                    }
                    .listStyle(.plain)
                    .padding()
                    //.analyticsScreen(name: "\(Self.self)")
            }
        }
        .frame(height: 20)
        }
        
        
}

#Preview {
    ProductsList()
}
