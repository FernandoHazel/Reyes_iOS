import SwiftUI

struct RosterRow: View {
    var player: Player
    
    var body: some View {
        HStack {
            Text(String(player.number))
                .bold()
                .font(.title)
            
            Image(player.profileImageName)
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            
            VStack {
                Text(player.name)
                    .bold()
                HStack {
                    Text(String(player.height) + "mts")
                        .font(.caption)
                    Text(String(player.weight) + "Kgs")
                        .font(.caption)
                }
                .offset(x: -10)
            }
            
            Text(player.pos)
                .bold()
                .font(.title)
        }
        Divider()
    }
}

#Preview {
    RosterRow(player: players[0])
}
