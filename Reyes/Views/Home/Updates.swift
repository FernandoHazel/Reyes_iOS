//
//  Promos.swift
//  Reyes
//
//  Created by Fernando Ascencio on 02/06/24.
//

import SwiftUI

struct Updates: View {
    
    var body: some View {
        
        ForEach(updates) { update in
            NavigationLink {
                DownloadedImage(imagePath: update.image)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(contentMode: .fit)
            } label: {
                DownloadedImage(imagePath: update.image)
                    .scaledToFill()
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                .padding()
            }
            .listStyle(.inset)
        }
    }
}

#Preview {
    Updates()
}
