import SwiftUI

struct NextGameView: View {
    
    var body: some View {
        Text("Siguiente Partido")
            .bold()
            .font(.title)
            .padding()
        GameView(game: games[actualGames[0].gameId])
            .padding(.horizontal)
        
        //If tikets are available show button
        //...
    }
}

#Preview {
    NextGameView()
}
