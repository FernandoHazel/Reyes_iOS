import SwiftUI

struct GameDetail: View {
    var game: Game
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("QRT")
                        .bold()
                        .font(.title)
                    Spacer()
                    Image("Reyes_icon")
                        .resizable()
                        .frame(width: 70, height: 70)
                    Spacer()
                    Image(game.teamImageName)
                        .resizable()
                        .frame(width: 70, height: 70)
                }
                Divider()
                HStack {
                    Text("1")
                    Spacer()
                    Text(String(game.qrt_1_reyes))
                    Spacer()
                    Text(String(game.qrt_1_team))
                }
                .padding(.horizontal)
                Divider()
                HStack {
                    Text("2")
                    Spacer()
                    Text(String(game.qrt_2_reyes))
                    Spacer()
                    Text(String(game.qrt_2_team))
                }
                .padding(.horizontal)
                Divider()
                HStack {
                    Text("3")
                    Spacer()
                    Text(String(game.qrt_3_reyes))
                    Spacer()
                    Text(String(game.qrt_3_team))
                }
                .padding(.horizontal)
                Divider()
                HStack {
                    Text("4")
                    Spacer()
                    Text(String(game.qrt_4_reyes))
                    Spacer()
                    Text(String(game.qrt_4_team))
                }
                .padding(.horizontal)
                Text("Resumen del partido")
                    .bold()
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                
                if (game.resumeVideoLink != "") {
                    VideoView(videoURL: URL(string: game.resumeVideoLink)!)
                        .frame(width: 350, height: 250)
                } else {
                    Text("Video no disponible")
                        .padding(20)
                }
                
                Text("Partido completo")
                    .bold()
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                
                if (game.gameVideoLink != "") {
                    VideoView(videoURL: URL(string: game.gameVideoLink)!)
                        .frame(width: 350, height: 250)
                } else {
                    Text("Video no disponible")
                        .padding(20)
                }
                
                Text("Conferencia de prensa")
                    .bold()
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                
                if (game.interviewVideoLink != "") {
                    VideoView(videoURL: URL(string: game.interviewVideoLink)!)
                        .frame(width: 350, height: 250)
                } else {
                    Text("Video no disponible")
                        .padding(20)
                }
                
            }
            .padding()
        }
        
    }
}

struct GameDetail_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @StateObject var vm = AppViewModel()

        var body: some View {
            GameDetail(game: vm.games[0])
                .environmentObject(vm)
                .task {
                    await vm.loadAllData()
                }
        }
    }
}
