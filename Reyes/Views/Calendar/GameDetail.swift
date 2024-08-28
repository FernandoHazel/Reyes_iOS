import SwiftUI

struct GameDetail: View {
    var reyesLogo: String = "TeamLogos/Reyes_icon.png"
    var game: Game
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("QRT")
                        .bold()
                        .font(.title)
                    Spacer()
                    DownloadedImage(imagePath: reyesLogo)
                        .frame(width: 50, height: 70)
                    Spacer()
                    DownloadedImage(imagePath: game.teamImageName)
                        .frame(width: 50, height: 70)
                }
                Divider()
                HStack {
                    Text("1")
                    Spacer()
                    Text(String(game.qrt_1_reyes))
                    Spacer()
                    Text(String(game.qrt_1_team))
                }
                .padding(.horizontal)
                Divider()
                HStack {
                    Text("2")
                    Spacer()
                    Text(String(game.qrt_2_reyes))
                    Spacer()
                    Text(String(game.qrt_2_team))
                }
                .padding(.horizontal)
                Divider()
                HStack {
                    Text("3")
                    Spacer()
                    Text(String(game.qrt_3_reyes))
                    Spacer()
                    Text(String(game.qrt_3_team))
                }
                .padding(.horizontal)
                Divider()
                HStack {
                    Text("4")
                    Spacer()
                    Text(String(game.qrt_4_reyes))
                    Spacer()
                    Text(String(game.qrt_4_team))
                }
                .padding(.horizontal)
                Text("Resumen del partido")
                    .bold()
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                
                if (game.resumeVideoLink != "") {
                    VideoView(videoURL: URL(string: game.resumeVideoLink)!)
                        .frame(width: 350, height: 250)
                } else {
                    Text("Video no disponible")
                        .padding(20)
                }
                
                Text("Partido completo")
                    .bold()
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                
                if (game.gameVideoLink != "") {
                    VideoView(videoURL: URL(string: game.gameVideoLink)!)
                        .frame(width: 350, height: 250)
                } else {
                    Text("Video no disponible")
                        .padding(20)
                }
                
                Text("Conferencia de prensa")
                    .bold()
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                
                if (game.interviewVideoLink != "") {
                    VideoView(videoURL: URL(string: game.interviewVideoLink)!)
                        .frame(width: 350, height: 250)
                } else {
                    Text("Video no disponible")
                        .padding(20)
                }
                
            }
            .padding()
        }
        
    }
}

struct GameDetail_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @StateObject var vm = AppViewModel()
        
        let game = Game(
            id: 2,
            date: "10 de Marzo 2024",
            team: "RAPTORS",
            hour: "12:00 PM",
            location: "Estadio Reyes Comude",
            reyesRecord: "0 - 1",
            teamRecord: "1 - 0",
            teamImageName: "TeamLogos/raptors-sf.png",
            qrt_1_reyes: 19,
            qrt_1_team: 3,
            qrt_2_reyes: 19,
            qrt_2_team: 9,
            qrt_3_reyes: 27,
            qrt_3_team: 9,
            qrt_4_reyes: 33,
            qrt_4_team: 17,
            resumeVideoLink: "https://www.youtube.com/embed/iw5fZLcq3Oo?si=PNokWOLC20ZB6GWV",
            gameVideoLink: "https://www.youtube.com/embed/BOwH3UyZdaE?si=LS6mKSjkh_ccns_T",
            interviewVideoLink: "https://www.youtube.com/embed/KwUt1keGvyQ?si=KXUAWpkjRnQrXqCG")

        var body: some View {
            GameDetail(game: game)
                .environmentObject(vm)
                .task {
                    await vm.loadAllData()
                }
        }
    }
}
