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
                VideoView(videoURL: URL(string: game.resumeVideoLink)!)
                    .frame(width: 350, height: 250)
                Text("Partido completo")
                    .bold()
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                VideoView(videoURL: URL(string: game.gameVideoLink)!)
                    .frame(width: 350, height: 250)
                Text("Conferencia de prensa")
                    .bold()
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                VideoView(videoURL: URL(string: game.interviewVideoLink)!)
                    .frame(width: 350, height: 250)
            }
            .padding()
        }
        
    }
}

#Preview {
    GameDetail(game: games[0])
}
