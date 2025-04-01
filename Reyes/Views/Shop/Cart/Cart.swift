//
//  Cart.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 17/09/24.
//

import SwiftUI
import Foundation

struct Cart: View {
    @EnvironmentObject var vm: AppViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    //@Environment(\.managedObjectContext) private var viewContext
    //@FetchRequest(sortDescriptors: [])
    //private var cartProducts: FetchedResults<CartProduct>
    
    var body: some View {
        
        let products = vm.products
        let selectedProducts = authViewModel.selectedProducts
        
        if !selectedProducts.isEmpty && !products.isEmpty{
            NavigationView {
                VStack {
                    List {
                        ForEach(selectedProducts.keys.sorted(), id: \.self) { idAndSize in
                            if let quantity = selectedProducts[idAndSize] {
                                let parts = idAndSize.split(separator: "-")
                                if let id = Int(parts[0]), parts.count > 1 {
                                    let size = String(parts[1])
                                    
                                    if let product = products.first(where: { $0.id == id }) {
                                        CartProductRow(cartProduct: product, quantity: quantity, size: size)
                                    }
                                }
                            }
                        }

                        .onDelete(perform: deleteCartProduct)
                    }.navigationTitle("Mi carrito")
                    CartSummary()
                    CheckoutButton()
                    Spacer()
                }
            }
        } else {
            Text("Aún no has añadido ningún producto")
        }
    }
    
    private func deleteCartProduct(offsets: IndexSet){
        withAnimation {
            /*
            offsets.map { cartProducts[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let error = error as NSError
                fatalError("Could't save context while adding cart product: \(error.localizedDescription)")
            }*/
            
        }
    }
}

struct CheckoutButton: View {
    var body: some View {
        NavigationLink(destination: UserInfo()) {
            Text("Checkout")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .lineLimit(1)
                .background(
                    Color.yellow
                        .cornerRadius(10)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .frame(width: 300)
                )
        }
    }
}

struct Cart_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {

        var body: some View {
            Cart()
        }
    }
}

