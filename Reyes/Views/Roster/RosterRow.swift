import SwiftUI

struct RosterRow: View {
    var player: Player
    
    var body: some View {
        HStack {
            Text(String(player.number))
                .bold()
                .font(.system(size: 20))
            
            DownloadedImage(imagePath: player.profileImageName)
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            
            VStack {
                Text(player.name)
                    .bold()
                    .font(.system(size: 14))
                
                HStack {
                    Text(String(player.height) + "mts")
                        .font(.caption)
                    
                    Text(String(player.weight) + "Kgs")
                        .font(.caption)
                }
                .padding(.top)
                
            }
            
            Spacer()
            
            Text(player.pos)
                .bold()
                .font(.system(size: 20))
        }
        Divider()
    }
}

struct RosterRow_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @StateObject var vm = AppViewModel()

        var body: some View {
            RosterRow(player: vm.players[0])
                .environmentObject(vm)
                .task {
                    await vm.loadAllData()
                }
        }
    }
}
