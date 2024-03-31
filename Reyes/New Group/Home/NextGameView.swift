import SwiftUI

struct NextGameView: View {
    var body: some View {
        Text("Siguiente Partido")
            .bold()
            .font(.title)
        GameView(game: games[4])
        Button("Comprar boleto"){
            
        }
        .padding()
        .frame(width: 300)
        .foregroundColor(Color.white)
        .background(Color.yellow)
        .cornerRadius(20)
    }
}

#Preview {
    NextGameView()
}
