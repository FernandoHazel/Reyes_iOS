import SwiftUI

struct HomeView: View {
    @State private var showRewardOnboarding = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                NextGameView()
                Rewards(showRewardOnboarding: $showRewardOnboarding)
                    .sheet(isPresented: $showRewardOnboarding){
                        RewardsOnboarding()
                    }
                Updates()
                    .padding(.horizontal)
            }
        }
    }
}

#Preview {
    HomeView()
}
