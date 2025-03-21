import SwiftUI

struct NextGameView: View {
    @EnvironmentObject var vm: AppViewModel
    
    var body: some View {
        
        
        if (!vm.games.isEmpty && !vm.actualGames.isEmpty){
            let game = vm.games[vm.actualGames[0].gameId-1]
            let currentGame = vm.actualGames[0]
            
            Text("Siguiente Partido")
                .bold()
                .font(.title)
                .padding()
            CurrentGameView(game: game)
                .padding(.horizontal)
            
            //If tikets are available show button
            if let ticketsURL = currentGame.ticketsLink, !ticketsURL.isEmpty {
                BuyTicketsButton(currentGame: currentGame)
            }
            
            //If live video stream is available show video view
            if let gameURL = currentGame.gameLink, !gameURL.isEmpty {
                VStack {
                    Text("Ver partido en vivo")
                        .bold()
                        .font(.title)
                        .padding(.top)
                        .padding(.horizontal)
                    VideoView(videoURL: URL(string: currentGame.gameLink!)!)
                        .frame(width: 350, height: 250)
                }
            }
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

struct BuyTicketsButton: View {
    var currentGame: ActualGame
    @State private var showTicketsView = false
    
    
    var body: some View {
        Button(action: {
            // Navigate to buy tickets page
            showTicketsView = true
        }, label: {
            HStack{
                Spacer()
                Text("COMPRAR BOLETOS")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .lineLimit(1)
                Spacer()
                    
            }.background(
                Color(red: 0.0, green: 0.30, blue: 0.90)
                    .cornerRadius(10)
                    .shadow(radius: 1)
            )
            .padding(.horizontal)
            
        })
        .sheet(isPresented: $showTicketsView){
            SafariViewWrapper(url: URL(string: currentGame.ticketsLink ?? "https://lfa.mx/reyes/")!)
        }
    }
}


struct WatchGameButton: View {
    var currentGame: ActualGame
    @State private var showWatchGameView = false
    
    var body: some View {
        Button(action: {
            // Navigate to youtube game
            showWatchGameView = true
        }, label: {
            Text("Ver partido")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding()
                .frame(maxWidth: .infinity)
                .lineLimit(1)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                        .shadow(radius: 1)
                )
        })
        .padding(.horizontal)
        .sheet(isPresented: $showWatchGameView ){
            SafariViewWrapper(url: URL(string: currentGame.gameLink ?? "https://lfa.mx/reyes/")!)
        }
    }
}






#Preview {
    NextGameView()
}
