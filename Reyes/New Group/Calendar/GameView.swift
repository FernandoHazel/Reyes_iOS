import SwiftUI

struct GameView: View {
    let game: Game
    
    var body: some View {
        VStack {
            Text(game.date)
                .bold()
            HStack {
                VStack {
                    Image("Reyes_icon")
                        .resizable()
                        .frame(width: 100, height: 100)
                    //Text(game.reyesRecord)
                        //.bold()
                }
                
                VStack {
                    Text("REYES @ " + game.team)
                        .bold()
                    Text(game.hour)
                        .bold()
                    Text(game.location)
                        .bold()
                        .multilineTextAlignment(.center)
                        .font(.caption)
                }
                
                VStack {
                    Image(game.teamImageName)
                        .resizable()
                        .frame(width: 100, height: 100)
                    //Text(game.teamRecord)
                        //.bold()
                }
            }
        }
        Divider()
    }
}


#Preview {
    Group {
        // Mock data.
        let gallosGame = Game(
            id: 1,
            date: "1 de Marzo 2024",
            team: "GALLOS",
            hour: "7:00 PM",
            location: "Estadio Olímpico de Qro",
            reyesRecord: "0 - 0",
            teamRecord: "0 - 0",
            teamImageName: "gallos-sf")
        
        GameView(game: gallosGame)
    }
}
