//
//  CartProductRow.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 18/09/24.
//

import SwiftUI

struct CartProductRow: View {
    var cartProduct: Product
    let quantity: Int
    let size: String
    
    var body: some View {
        HStack {
            DownloadedImage(imagePath: cartProduct.imgNames[0])
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            
            Spacer()
            
            VStack {
                Text(cartProduct.name)
                    .bold()
                    .font(.system(size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if(cartProduct.discount > 0){
                    Text("Regular: $\(String(format: "%.2f", cartProduct.price))")
                        .font(.caption)
                        .strikethrough(true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                         
                    Text("$\(String(format: "%.2f", cartProduct.price - cartProduct.price * cartProduct.discount / 100))")
                        .bold()
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                } else {
                    Text("$\(String(format: "%.2f", cartProduct.price - cartProduct.price * cartProduct.discount / 100))")
                        .bold()
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Text("Cantidad: \(quantity)")
                    .bold()
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Talla: \(size)")
                    .bold()
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack{
                    Text("Coronas: \(String(format: "%.2f", cartProduct.reward * Double(quantity)))")
                        .bold()
                        .font(.system(size: 14))
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                }
                
            
            }
            Spacer()
        }
    }
}
