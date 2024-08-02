import SwiftUI

struct RosterList: View {
    @State private var selection = "Jugadores"
    
    var body: some View {
        
        NavigationView {
            VStack {
                Picker("Select", selection: $selection) {
                    Text("Jugadores").tag("Jugadores")
                    Text("Staff").tag("Staff")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    if selection == "Jugadores" {
                        ForEach(players) { player in
                            NavigationLink {
                                RosterDetail(player: player)
                            } label: {
                                RosterRow(player: player)
                                    .cornerRadius(10)
                            }
                        }
                    } else {
                        ForEach(staff) { staffMember in
                            NavigationLink {
                                StaffMemberDetail(staffMember: staffMember)
                            } label: {
                                StaffMemberRow(staffMember: staffMember)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .navigationTitle("Equipo")
                .listStyle(.inset)

                
            }
        }
    }
}



struct Roster_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        @State private var selection = "Jugadores"
        
        var body: some View {
            RosterList()
        }
    }
}
