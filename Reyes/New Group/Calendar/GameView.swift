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
                        .frame(width: 80, height: 80)
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
                    Image((game.teamImageName != "") ? game.teamImageName : "Reyes_icon")
                        .resizable()
                        .frame(width: 80, height: 80)
                }
            }
        }
        Divider()
    }
}


#Preview {
    GameView(game: games[8])
}
