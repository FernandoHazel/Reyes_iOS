import SwiftUI

struct NextGameView: View {
    var body: some View {
        Text("Siguiente Partido")
            .bold()
            .font(.title)
        GameView(game: games[4])
            .padding(.horizontal)
        
        //If tikets are available show button
        //...
    }
}

#Preview {
    NextGameView()
}
