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
                        .onDelete { indexSet in
                            for index in indexSet {
                                let keyToDelete = selectedProducts.keys.sorted()[index]
                                deleteCartProduct(idAndSize: keyToDelete)
                            }
                        }
                    }.navigationTitle("Mi carrito")
                    CartSummary(products: products, selectedProducts: selectedProducts)
                    CheckoutButton()
                    Spacer()
                }
            }
        } else {
            Text("Aún no has añadido ningún producto")
        }
    }
    
    private func deleteCartProduct(idAndSize: String){
        withAnimation {
            // Delete product from user
            authViewModel.deleteSelectedProduct(idAndSize: idAndSize)
        }
    }
}

struct CheckoutButton: View {
    var body: some View {
        NavigationLink(destination: OrderSummary()) {
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

