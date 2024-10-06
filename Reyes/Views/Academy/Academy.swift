//
//  Academy.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 20/09/24.
//

import SwiftUI

struct Academy: View {
    let phoneNumber = "3340028670"
    @State private var alreadyDownloaded = false
    
    var body: some View {
        VStack{
            ArticleImage(imagePath: "Updates/Academia.png", alreadyDownloaded: $alreadyDownloaded)
            if(alreadyDownloaded){
                Spacer()
                
                Button(action: {
                        makePhoneCall()
                }) {
                    HStack{
                        Image(systemName: "phone.fill")
                            .foregroundColor(.black)
                        
                        Text("Inscríbete!")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                            .lineLimit(1)
                    }
                    .padding()
                    .background(
                        Color.white
                            .cornerRadius(10)
                            .shadow(radius: 1)
                    )
                    
                }
                Spacer()
            }
            
        }
    }
    
    func makePhoneCall() {
        if let url = URL(string: "tel://\(phoneNumber)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    Academy()
}
