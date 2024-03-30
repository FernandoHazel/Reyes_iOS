import SwiftUI

struct Calendar: View {
    var body: some View {
        NavigationView {
            List(games) { game in
                NavigationLink {
                    GameDetail(game: game)
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
