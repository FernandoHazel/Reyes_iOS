import SwiftUI
import UIKit

struct HomeView: View {
    @EnvironmentObject var vm: AppViewModel
    @State private var showRewardOnboarding = false
    @State private var showNew = false
    
    let appStoreURL = "https://apps.apple.com/app/id6667093876" // App store URL
    
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
                    var newURL = ""
                    let orderdedList = vm.orderList(list: vm.noticias)
                    
                    ScrollView {
                        ForEach(orderdedList.reversed()) { noticia in
                            
                            if (noticia.postLink != ""){
                                Button {
                                    newURL = noticia.postLink ?? ""
                                    showNew = true
                                } label: {
                                    NewRow(new: noticia)
                                        .cornerRadius(10)
                                        .padding(5)
                                }
                                .sheet(isPresented: $showNew){
                                    if (newURL != ""){
                                        SafariViewWrapper(url: URL(string: newURL)!)
                                    }
                                    
                                }
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
                        vm.openAppStore(url: appStoreURL)
                    },
                    secondaryButton: .destructive(Text(vm.versionUpdateAlertConfig.optionalButton ?? ""))
                )
            })
        }.navigationBarHidden(true)
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
