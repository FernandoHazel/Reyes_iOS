//
//  CartProductRow.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 18/09/24.
//

import SwiftUI

struct CartProductRow: View {
    var cartProduct: CartProduct
    
    var body: some View {
        HStack {
            DownloadedImage(imagePath: cartProduct.imageName ?? "")
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            
            Spacer()
            
            VStack {
                Text(cartProduct.name ?? "")
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
                
                Text("Cantidad: \(cartProduct.quantitySelected)")
                    .bold()
                    .font(.system(size: 14))
                    .frame(maxWidth: .infinity, alignment: .leading)
            
            }
            Spacer()
        }
    }
}
