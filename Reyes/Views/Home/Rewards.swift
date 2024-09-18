//
//  Rewards.swift
//  Reyes
//
//  Created by Fernando Ascencio on 02/06/24.
//

import SwiftUI

struct Rewards: View {
    
    @Binding var showRewardOnboarding: Bool
    
    var body: some View {
        
        VStack {
            HStack {
                HStack {
                    Text("Tu Progreso: ")
                    Text("Fernando") //Esto dependerá del usuario logueado
                        .bold()
                }
                Spacer()
                HStack {
                    Text("0")
                    Image(systemName: "crown.fill")
                        .foregroundColor(.yellow)
                }
            }
            .padding()
            
            //Add the progress bar here
            //..
            
            Button(action: {
                showRewardOnboarding.toggle()
            }, label: {
                Text("Detalles de recompensas")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding()
                    .lineLimit(1)
                    .background(
                        Color.white
                            .cornerRadius(10)
                            .shadow(radius: 1)
                            .frame(width: 370)
                    )
        })
            
            
        }
    }
}

struct Rewards_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State private var showRewardOnboarding = false

        var body: some View {
            Rewards(showRewardOnboarding: $showRewardOnboarding)
        }
    }
}
