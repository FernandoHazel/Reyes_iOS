//
//  CartSummary.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 18/09/24.
//

import SwiftUI

struct CartSummary: View {
    let products: [Product]
    let selectedProducts: [String : Int]
    
    private var cartSum: Double {
        selectedProducts.reduce(0.0) { sum, entry in
            let (idAndSize, quantity) = entry
            let parts = idAndSize.split(separator: "-")
            guard let id = Int(parts[0]), parts.count > 1,
                  let product = products.first(where: { $0.id == id }) else { return sum }
            
            let productTotal = product.price * (1 - product.discount / 100.0) * Double(quantity)
            return sum + productTotal
        }
    }
    
    private var rewardSum: Double {
        selectedProducts.reduce(0.0) { sum, entry in
            let (idAndSize, quantity) = entry
            let parts = idAndSize.split(separator: "-")
            guard let id = Int(parts[0]), parts.count > 1,
                  let product = products.first(where: { $0.id == id }) else { return sum }
            
            return sum + (product.reward * Double(quantity))
        }
    }
    
    var body: some View {
        HStack{
            Text("Total del carrito")
                .bold()
                .font(.system(size: 20))
                .foregroundColor(Color(red: 0.0, green: 0.30, blue: 0.90))
                .padding()
            //Summary of all products
            Text("$\(String(format: "%.2f", cartSum))")
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
            Text("\(String(format: "%.0f", rewardSum))")
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
}
