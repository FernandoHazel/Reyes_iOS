import SwiftUI

struct Home: View {
    @State private var selectedTab: Tab = .house
    @State private var showingProfile = false
    
    init() {
        // This is to eliminate an extra space wich is automatically created
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding()
                    .foregroundColor(.white)
                    .onTapGesture {
                        showingProfile.toggle()
                    }

                Spacer()
                Image("Reyes_icon")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .offset(x: -30)

                Spacer()
            }
            .padding(.bottom)
            .background(Color.blue)
        
        ZStack {
                // TabView is going to control the views from the tab
                TabView(selection: $selectedTab) {
                    
                    ProductsList()
                        .sheet(isPresented: $showingProfile) {
                            SingIn()
                        }
                    /*
                    ForEach(Tab.allCases, id: \.rawValue) { tab in
                        HStack {
                            
                            Image(systemName: tab.rawValue)
                            Text("\(tab.rawValue.capitalized)")
                                .bold()
                                .animation(nil, value: selectedTab)
                            
                        }
                        .tag(tab)
                        .sheet(isPresented: $showingProfile) {
                            SingIn()
                        }
                    }
                    */
                    
                }
            }
            
            VStack {
                CustomTabBar(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    Home()
}
