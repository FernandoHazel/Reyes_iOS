import SwiftUI

struct Calendar: View {
    var body: some View {
        ScrollView {
            ForEach(games) { game in
                GameView(game: game)
            }
        }
    }
}

#Preview {
    Calendar()
}
