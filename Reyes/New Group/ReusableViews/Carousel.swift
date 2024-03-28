//
//  Carousel.swift
//  Reyes
//
//  Created by Fernando Ascencio on 25/02/24.
//

import SwiftUI

struct Carousel: View {
    let photosNames: [String]
    
    var body: some View {
        TabView {
            ForEach(photosNames, id: \.self) { photo in
                Image(photo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal)
                    
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}

#Preview {
    Carousel(photosNames: ["gorra-azul", "playera-azul", "sudadera-azul"])
}
