import SwiftUI

struct Main: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var showingProfile = false
    @State private var selectedTab: Tab = .house
    @State private var showCart = false
    
    init() {
        // This is to eliminate an extra space wich is automatically created
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        VStack {
            TopBar(showingProfile: $showingProfile, showCart: $showCart)
        
        ZStack {
                // TabView is going to control the views from the tab
                TabView(selection: $selectedTab) {
                    ForEach(Tab.allCases, id: \.rawValue) { tab in
                        HStack {
                            switch tab {
                                case .house:
                                VStack {
                                    HomeView()
                                }
                                case .book:
                                VStack {
                                    Academy()
                                }
                                case .bag:
                                VStack {
                                    ProductsList()
                                }
                                case .calendar:
                                VStack {
                                    Calendar()
                                }
                                case .person:
                                VStack {
                                    RosterList()
                                }
                            }
                            
                            
                        }
                        .tag(tab)
                        .sheet(isPresented: $showingProfile) {
                            AuthenticationView()
                                .environmentObject(viewModel)
                        }
                        .sheet(isPresented: $showCart) {
                            Cart()
                        }
                        
                    }
                    
                }
            }
            
            VStack {
                CustomTabBar(selectedTab: $selectedTab)
                    .environmentObject(viewModel)
            }
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @StateObject var vm = AppViewModel()

        var body: some View {
            Main()
                .environmentObject(vm)
                .task {
                    await vm.loadAllData()
                }
        }
    }
}
