//
//  Academy.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 20/09/24.
//

import SwiftUI

struct Academy: View {
    @EnvironmentObject var vm: AppViewModel
    let phoneNumber = "3340028670"
    @State private var alreadyDownloaded = false
    
    var body: some View {
        VStack{
            if(!vm.updates.isEmpty){
                let academy = vm.updates[0]
                ArticleImage(imagePath: academy.image, alreadyDownloaded: $alreadyDownloaded)
            }
            
            Spacer()
            
            Button(action: {
                    makePhoneCall()
            }) {
                HStack{
                    Image(systemName: "phone.fill")
                        .foregroundColor(.black)
                    
                    Text("Inscríbete a la Academia!")
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
    
    func makePhoneCall() {
        if let url = URL(string: "tel://\(phoneNumber)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    let academy = Update(id: 0, image: "")
    Academy()
}
