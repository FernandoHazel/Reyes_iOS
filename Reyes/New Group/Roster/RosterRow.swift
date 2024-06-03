import SwiftUI

struct RosterRow: View {
    var player: Player
    
    var body: some View {
        HStack {
            Text(String(player.number))
                .bold()
                .font(.system(size: 20))
            
            Image(player.profileImageName)
                .resizable()
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

#Preview {
    RosterRow(player: players[0])
}
