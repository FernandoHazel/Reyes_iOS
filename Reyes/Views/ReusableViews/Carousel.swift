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
                DownloadedImage(imagePath: photo)
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal)
                    
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}

#Preview {
    Carousel(photosNames: ["Merch/Playera_Ghost_Azul.png", "Merch/Playera_Ghost_Blanca.png", "Merch/Playera_J_Amarilla.png"])
}
