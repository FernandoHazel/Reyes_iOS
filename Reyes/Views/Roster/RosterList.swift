import SwiftUI

struct RosterList: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var selection = "Jugadores"
    
    var body: some View {
        
        NavigationView {
            VStack {
                Picker("Select", selection: $selection) {
                    Text("Jugadores").tag("Jugadores")
                    Text("Staff").tag("Staff")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                List {
                    if selection == "Jugadores" {
                        if(!vm.players.isEmpty){
                            ForEach(vm.players) { player in
                                NavigationLink {
                                    RosterDetail(player: player)
                                } label: {
                                    RosterRow(player: player)
                                        .cornerRadius(10)
                                }
                            }
                        }else{
                            FetchingView()
                        }
                        
                    } else {
                        if(!vm.staff.isEmpty){
                            ForEach(vm.staff) { staffMember in
                                NavigationLink {
                                    StaffMemberDetail(staffMember: staffMember)
                                } label: {
                                    StaffMemberRow(staffMember: staffMember)
                                        .cornerRadius(10)
                                }
                            }
                        } else {
                            FetchingView()
                        }
                    }
                }
                .listStyle(.inset)
            }
            .navigationBarHidden(true)
        }
    }
}

struct Roster_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        @StateObject var vm = AppViewModel()
        @State private var selection = "Jugadores"
        
        var body: some View {
            RosterList()
                .environmentObject(vm)
                .task {
                    await vm.loadAllData()
                }
        }
    }
}
