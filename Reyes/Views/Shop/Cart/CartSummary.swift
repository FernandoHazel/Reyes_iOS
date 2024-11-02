//
//  CartSummary.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 18/09/24.
//

import SwiftUI

struct CartSummary: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var cartProducts: FetchedResults<CartProduct>
    
    var body: some View {
        HStack{
            Text("Total del carrito")
                .bold()
                .font(.system(size: 20))
                .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.90))
                .padding()
            //Summary of all products
            Text("$\(String(format: "%.2f", cartSum()))")
                .bold()
                .padding()
                .font(.system(size: 20))
                .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.90))
        }
        .background(
            Color(.white)
                .cornerRadius(10)
                .shadow(color: Color(red: 0.0, green: 0.30, blue: 0.90), radius: 1)
                .frame(width: 300)
        )
        .padding(.horizontal)
        HStack{
            Text("Recompensas: ")
                .bold()
                .font(.system(size: 20))
                .foregroundColor(.green)
                .padding()
            //Summary of all products
            Text("\(String(format: "%.0f", rewardSum()))")
                .bold()
                .padding()
                .font(.system(size: 20))
                .foregroundColor(.green)
            Image(systemName: "crown.fill")
                .foregroundColor(.yellow)
        }
            .background(
                Color(.white)
                    .cornerRadius(10)
                    .shadow(color: .green, radius: 1)
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
    
    private func rewardSum() -> Double{
        var sum: Double = 0
        cartProducts.forEach { cartProduct in
            sum += cartProduct.reward * Double(cartProduct.quantitySelected)
        }
        return sum
    }
}
