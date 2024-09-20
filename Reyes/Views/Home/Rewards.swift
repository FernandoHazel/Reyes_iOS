//
//  Rewards.swift
//  Reyes
//
//  Created by Fernando Ascencio on 02/06/24.
//

import SwiftUI

struct Rewards: View {
    
    // Get a reference to the managed object context from the environment.
    @Environment(\.managedObjectContext) private var viewContext
    
    // I have "users" but is supposed to exist only one
    @FetchRequest(sortDescriptors: [])
    private var users: FetchedResults<UserData>
    
    @FetchRequest(sortDescriptors: [])
    private var cartProducts: FetchedResults<CartProduct>
    
    @Binding var showRewardOnboarding: Bool
    
    var body: some View {
        
        VStack {
            HStack {
                HStack {
                    Text("Tu Progreso: ")
                    Text(users.first?.firstName ?? "") //Esto dependerá del usuario logueado
                        .bold()
                }
                Spacer()
                HStack {
                    Text("\(String(format: "%.0f", users.first?.rewards ?? 0))")
                        .bold()
                        .foregroundColor(.green)
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
