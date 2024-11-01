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
                    Text(users.first?.firstName ?? "")
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
            
            //PROGRESS BAR
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Fondo de la barra de progreso
                    Rectangle()
                        .frame(height: 5)
                        .foregroundColor(Color.gray)
                        .cornerRadius(10)

                    // Barra de progreso que se llena
                    Rectangle()
                        .frame(width: progressBarWidth(totalWidth: geometry.size.width), height: 10)
                        .foregroundColor(Color.green)
                        .cornerRadius(10)
                        .animation(.easeInOut, value: users.first?.rewards ?? 0)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
            }
            .frame(height: 20)
            
            Button(action: {
                showRewardOnboarding.toggle()
            }, label: {
                HStack{
                    Spacer()
                    Text("¿Cómo funcionan las recompensas?")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding()
                        .lineLimit(1)
                    Spacer()
                        
                }.background(
                    Color.white
                        .cornerRadius(10)
                        .shadow(radius: 1)
                )
                .padding(.horizontal)
                
            })
        }
    }
    
    private func progressBarWidth(totalWidth: CGFloat) -> CGFloat {
        let rewards = users.first?.rewards ?? 0
        
        // Hay un problema al llegar a 100 que hace que la barra verde salga de la pantalla, por eso dejo el límite en 95, seguramente es por el padding horizontal de la barra gris
        return rewards >= 95 ? (95 / 100) * totalWidth : (rewards / 100) * totalWidth
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
