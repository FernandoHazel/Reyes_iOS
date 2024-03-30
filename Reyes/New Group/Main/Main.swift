import SwiftUI

struct Main: View {
    @State private var selectedTab: Tab = .house
    @State private var showingProfile = false
    
    init() {
        // This is to eliminate an extra space wich is automatically created
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        VStack {
            TopBar(showingProfile: $showingProfile)
        
        ZStack {
                // TabView is going to control the views from the tab
                TabView(selection: $selectedTab) {
                    ForEach(Tab.allCases, id: \.rawValue) { tab in
                        HStack {
                            switch tab {
                                case .house:
                                    Text("Home")
                                case .storefront:
                                    ProductsList()
                                case .calendar:
                                    Calendar()
                                case .person:
                                    Text("Rooster")
                            }
                            
                        }
                        .tag(tab)
                        .sheet(isPresented: $showingProfile) {
                            SingIn()
                        }
                    }
                    
                }
            }
            
            VStack {
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    Main()
}
