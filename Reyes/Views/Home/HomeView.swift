import SwiftUI
import UIKit

struct HomeView: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var showRewardOnboarding = false
    let appStoreURL = URL(string: "https://apps.apple.com/app/id6667093876")! // App store URL
    
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
            .alert(isPresented: $vm.updateNeeded, content: {
                Alert(
                    title: Text(vm.versionUpdateAlertConfig.title ?? ""),
                    message: Text(vm.versionUpdateAlertConfig.message ?? ""),
                    primaryButton: .default(Text(vm.versionUpdateAlertConfig.forcedButton ?? "")) {
                                            openAppStore() // Open app store"
                    },
                    secondaryButton: .destructive(Text(vm.versionUpdateAlertConfig.optionalButton ?? ""))
                )
            })
        }
    }
    
    func openAppStore() {
        if UIApplication.shared.canOpenURL(appStoreURL) {
            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    HomeView()
}
