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
