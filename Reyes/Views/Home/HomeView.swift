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
                        .padding(.vertical)
                    if !vm.noticias.isEmpty {
                        ScrollView {
                            ForEach(vm.noticias) { noticia in
                                NavigationLink(destination: NewDetail(new: noticia)) {
                                    NewRow(new: noticia)
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .listStyle(.inset)
                    } else {
                        FetchingView()
                    }
                }
                .navigationBarHidden(true)
                .alert(isPresented: $vm.updateNeeded, content: {
                    Alert(
                        title: Text(vm.versionUpdateAlertConfig.title ?? ""),
                        message: Text(vm.versionUpdateAlertConfig.message ?? ""),
                        primaryButton: .default(Text(vm.versionUpdateAlertConfig.forcedButton ?? "")) {
                                                openAppStore()
                        },
                        secondaryButton: .destructive(Text(vm.versionUpdateAlertConfig.optionalButton ?? ""))
                    )
            })
        }.navigationBarHidden(true)
    }
    
    func openAppStore() {
        if UIApplication.shared.canOpenURL(appStoreURL) {
            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @StateObject var vm = AppViewModel()

        var body: some View {
            HomeView()
                .environmentObject(vm)
                .task {
                    await vm.loadAllData()
                }
        }
    }
}
