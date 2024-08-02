import SwiftUI

struct RosterDetail: View {
    var player: Player
    
    var body: some View {
        ScrollView {
            DownloadedImage(imagePath: player.profileImageName)
                .scaledToFit()
            
            HStack {
                VStack {
                    Text(player.name)
                        .bold()
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Text(player.pos)
                            .bold()
                            .padding(10)
                            .background(Color(hex: 014791))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                        Text("#"+String(player.number))
                            .font(.title)
                            
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
            
            Text("Información del jugador")
                .bold()
                .font(.title2)
                .padding(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                HStack {
                    VStack {
                        Text("Altura")
                            .bold()
                        Text(String(player.height)+"mts")
                    }
                    Spacer()
                    VStack {
                        Text("Peso")
                            .bold()
                        Text(String(player.weight)+"kgs")
                    }
                    Spacer()
                    VStack {
                        Text("Edad")
                            .bold()
                        Text(String(player.age)+" años")
                    }
                }
                Divider()
                HStack {
                    VStack {
                        Text("Procedencia")
                            .bold()
                        Text(player.procedence)
                            .frame(width: 100)
                            .lineLimit(1)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                    VStack {
                        Text("Años en LFA")
                            .bold()
                        Text(String(player.lfa)+" años")
                    }
                    Spacer()
                    VStack {
                        Text("Grupo")
                            .bold()
                        Text(player.group)
                    }
                }
            }
            .padding()
            Text(player.status)
                .bold()
                .foregroundColor(.white)
                .font(.title)
                .padding()
                .frame(maxWidth: .infinity)
                .background(player.status == "Activo" ? Color.yellow : Color.red)
            
            Text("Sobre mí")
                .bold()
                .font(.title2)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                if(player.about != []){
                    ForEach(player.about, id: \.self) { paragraph in
                        Text(paragraph)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                }else{
                    Text("No hay información disponible")
                }
            }

            
            if(player.imgNames != []){
                Carousel(photosNames: player.imgNames)
                    .frame(width: 400, height: 300)
            } else {
                Text("No hay fotos disponibles")
                    .padding(20)
            }
            
        }
    }
}

#Preview {
    RosterDetail(player: players[22])
}
