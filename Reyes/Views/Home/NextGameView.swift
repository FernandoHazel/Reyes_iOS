import SwiftUI

struct NextGameView: View {
    @EnvironmentObject var vm: AppViewModel
    
    var body: some View {
        
        if (!vm.games.isEmpty && !vm.actualGames.isEmpty){
            Text("Siguiente Partido")
                .bold()
                .font(.title)
                .padding()
            GameView(game: vm.games[vm.actualGames[0].gameId])
                .padding(.horizontal)
            
            //If tikets are available show button
            //...
        } else {
            FetchingView()
        }
        
    }
}

#Preview {
    NextGameView()
}
