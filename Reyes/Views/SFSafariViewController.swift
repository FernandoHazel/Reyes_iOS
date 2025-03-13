//
//  SFSafariViewController.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 12/03/25.
//

import Foundation
import SwiftUI
import SafariServices

struct SafariViewWrapper: View {
    var url: URL

    var body: some View {
        SafariView(url: url)
            .edgesIgnoringSafeArea(.all) // Para pantalla completa (opcional)
            .navigationBarHidden(true) // Oculta la barra de navegación
            .navigationBarBackButtonHidden(true) // Oculta el botón de regreso
    }
}


struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
