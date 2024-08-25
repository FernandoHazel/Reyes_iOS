//
//  ErrorFetchingView.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 25/08/24.
//

import SwiftUI

struct FetchingView: View {
    @State private var showImage = false

    var body: some View {
        VStack {
            
            if showImage {
                Image("NoSePudoCargarLaInformacion")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity) // Añade una transición suave
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaledToFit()
            }
        }
        .onAppear {
            // Después de 5 segundos, actualiza `showImage` para mostrar la imagen
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    showImage = true
                }
            }
        }
    }
}

#Preview {
    FetchingView()
}
