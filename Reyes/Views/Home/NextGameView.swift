import SwiftUI

struct NextGameView: View {
    @EnvironmentObject var vm: AppViewModel
    
    var body: some View {
        
        if (!vm.games.isEmpty && !vm.actualGames.isEmpty){
            Text("Siguiente Partido")
                .bold()
                .font(.title)
                .padding()
            //GameView(game: vm.games[vm.actualGames[0].gameId-1])
                //.padding(.horizontal)
            CurrentGameView(game: vm.games[vm.actualGames[0].gameId-1])
                .padding(.horizontal)
            
            //If tikets are available show button
            //...
        } else {
            FetchingView()
        }
        
    }
}

struct CurrentGameView: View {
    var reyesLogo: String = "TeamLogos/Reyes_icon.png"
    @State private var teamImage: String = ""
    var game: Game
    @State private var alreadyDownloaded = false
    
    var body: some View {
        VStack {
            Text(game.date)
                .bold()
            HStack {
                VStack {
                    Image("Reyes_logo")
                      .resizable()
                      .frame(width: 80, height: 80)
                    Text(String(game.reyesRecord))
                        .bold()
                }
                Spacer()
                VStack {
                    Text((game.team != "") ? "REYES @ " + game.team : "")
                        .font(.system(size: 12))
                        .bold()
                    Text((game.hour != "") ? game.hour : "BYE WEEK")
                        .bold()
                    Text(game.location)
                        .bold()
                        .multilineTextAlignment(.center)
                        .font(.caption)
                }
                Spacer()
                VStack {
                    DownloadedImage(imagePath: game.teamImageName)
                        .frame(width: 80, height: 80)
                    Text(String(game.teamRecord))
                        .bold()
                }
            }
        }
        Divider()
    }
}

#Preview {
    NextGameView()
}
