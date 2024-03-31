import SwiftUI

struct NextGameView: View {
    var body: some View {
        Text("Siguiente Partido")
            .bold()
            .font(.title)
        GameView(game: games[4])
            .padding(.horizontal)
        Button("COMPRAR BOLETO"){
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .foregroundColor(Color.white)
        .background(Color(hex: 014791))
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

#Preview {
    NextGameView()
}
