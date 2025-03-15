import SwiftUI
import Foundation

struct ProductsList: View {
    @EnvironmentObject var vm: AppViewModel
    
    var body: some View {
        
        if (!vm.products.isEmpty){
            NavigationView {
                List(vm.products) { product in
                    NavigationLink {
                        ProductDetail(product: product)
                    } label: {
                        ProductRow(product: product)
                            
                    }
                }
                .navigationTitle("Tienda")
                .listStyle(.inset)
            }
        } else {
            FetchingView()
        }
        
    }
}

struct ProductsList_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @StateObject var vm = AppViewModel()

        var body: some View {
            ProductsList()
                .environmentObject(vm)
                .task {
                    await vm.loadAllData()
                }
        }
    }
}
