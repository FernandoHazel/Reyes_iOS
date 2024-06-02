//
//  Promos.swift
//  Reyes
//
//  Created by Fernando Ascencio on 02/06/24.
//

import SwiftUI

struct Promos: View {
    var body: some View {
        
        //Vamos a reutilizar el código de NewList
        
        NewRow(new: noticias[1])
        NewRow(new: noticias[2])
        NewRow(new: noticias[3])
        NewRow(new: noticias[4])
    }
}

#Preview {
    Promos()
}
