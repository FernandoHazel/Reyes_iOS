import SwiftUI

struct NewDetail: View {
    var new: Noticia
    
    var body: some View {
        ScrollView {
            Image(new.mainImageName)
                .resizable()
                .scaledToFit()
            
            HStack {
                Text("Por: ")
                    .bold()
                    .font(.title2)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(new.by)
            }
            Text(new.description)
                .padding(.horizontal)
        }
    }
}

#Preview {
    RosterDetail(player: players[0])
}
