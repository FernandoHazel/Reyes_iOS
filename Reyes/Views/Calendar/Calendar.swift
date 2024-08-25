import SwiftUI

struct Calendar: View {
    @EnvironmentObject var vm: AppViewModel
    
    var body: some View {
        
        if(!vm.games.isEmpty){
            NavigationView {
                List(vm.games) { game in
                    NavigationLink {
                        GameDetail(game: game)
                    } label: {
                        GameView(game: game)
                    }
                }
                .navigationTitle("Calendario")
                .listStyle(.inset)
            }
        } else {
            FetchingView()
        }
    }
}

struct Calendar_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        @StateObject var vm = AppViewModel()
        
        var body: some View {
            Calendar()
                .environmentObject(vm)
                .task {
                    await vm.loadAllData()
                }
        }
    }
}
