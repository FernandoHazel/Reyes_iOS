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
            if (currentGame.ticketsLink?.isEmpty == false){
                BuyTicketsButton()
            }
            
            //If game video link available show button
            if (currentGame.gameLink?.isEmpty == false){
                WatchGameButton()
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
    
    var body: some View {
        Button(action: {
            // Navigate to buy tickets page
            // ...
        }, label: {
            HStack{
                Spacer()
                Text("COMPRAR BOLETOS")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .lineLimit(1)
                Spacer()
                    
            }.background(
                Color.blue
                    .cornerRadius(10)
                    .shadow(radius: 1)
            )
            .padding(.horizontal)
            
        })
    }
}

struct WatchGameButton: View {
    
    var body: some View {
        Button(action: {
            // Navigate to youtube game
            // ...
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
        }).padding(.horizontal)
    }
}






#Preview {
    NextGameView()
}
