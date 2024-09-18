//
//  CartSummary.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 18/09/24.
//

import SwiftUI

struct CartSummary: View {
    
    // Get a reference to the managed object context from the environment.
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var cartProducts: FetchedResults<CartProduct>
    
    var body: some View {
        HStack{
            Text("Total del carrito")
                .bold()
                .font(.system(size: 20))
                .padding()
            //Summary of all products
            Text("$\(String(format: "%.2f", cartSum()))")
                .bold()
                .padding()
                .font(.system(size: 20))
        }
        .foregroundColor(.white)
        .background(
            Color(red: 0.0, green: 0.30, blue: 0.90)
                .cornerRadius(10)
                .frame(width: 300)
        )
        .padding(.horizontal)
    }
    
    private func cartSum() -> Double{
        var sum: Double = 0
        cartProducts.forEach { cartProduct in
            let priceWithDiscount = cartProduct.price - cartProduct.price * cartProduct.discount / 100
            let productTotal = priceWithDiscount * Double(cartProduct.quantitySelected)
            sum += productTotal
        }
        return sum
    }
}
