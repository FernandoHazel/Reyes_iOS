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
                Image(update.image)
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(contentMode: .fit)
            } label: {
                Image(update.image)
                    .resizable()
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
