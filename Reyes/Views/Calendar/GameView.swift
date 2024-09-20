import SwiftUI

struct GameView: View {
    var reyesLogo: String = "TeamLogos/Reyes_icon.png"
    @State private var teamImage: String = ""
    var game: Game
    @State private var alreadyDownloaded = false
    
    var body: some View {
        VStack {
            Text(game.date)
                .bold()
            HStack {
                VStack {
                    DownloadedImage(imagePath: reyesLogo)
                        .frame(width: 80, height: 80)
                    Text(String(game.qrt_4_reyes))
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
                    
                    /*
                    teamImage = (game.teamImageName != "") ? game.teamImageName : $reyesLogo
                    */
                    DownloadedImage(imagePath: game.teamImageName)
                        .frame(width: 80, height: 80)
                    Text(String(game.qrt_4_team))
                }
            }
        }
        Divider()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @StateObject var vm = AppViewModel()

        var body: some View {
            GameView(game: vm.games[4])
                .environmentObject(vm)
                .task {
                    await vm.loadAllData()
                }
        }
    }
}
