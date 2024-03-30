import SwiftUI

struct RosterList: View {
    var body: some View {

        NavigationView {
            List(players) { player in
                NavigationLink {
                    RosterDetail(player: player)
                } label: {
                    RosterRow(player: player)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Roster")
            .listStyle(.inset)
        }
    }
}

#Preview {
    RosterList()
}
