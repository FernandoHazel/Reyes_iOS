import SwiftUI

struct Calendar: View {
    var body: some View {
        NavigationView {
            List(games) { game in
                NavigationLink {
                    Text("Detalle del partido")
                } label: {
                    GameView(game: game)
                }
            }
            .navigationTitle("Calendario")
            .listStyle(.inset)
        }
    }
}

#Preview {
    Calendar()
}
