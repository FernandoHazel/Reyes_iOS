import Foundation
import UIKit

@MainActor
class AppViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var games: [Game] = []
    @Published var players: [Player] = []
    @Published var noticias: [Noticia] = []
    @Published var actualGames: [ActualGame] = []
    @Published var rewardsInstructions: [RewardInstruction] = []
    @Published var updates: [Update] = []
    @Published var staff: [StaffMember] = []
    @Published var priceRules: [PriceRule] = []
    @Published var versionUpdateManager = VersionUpdateManager()
    @Published var updateNeeded: Bool = false
    @Published var versionUpdateAlertConfig: VersionUpdateAlertConfig = VersionUpdateAlertConfig(
            title: "title",
             message: "message",
             forcedButton: "versionModel?.forcedButton",
             optionalButton: "versionModel?.optionalButton",
             type: .forced)
    
    //Try to fetch all the data to optimize db calls
    func loadAllData() async {
        do {
            products = try await getData(collection: "Products", as: Product.self)
            games = try await getData(collection: "Games", as: Game.self)
            players = try await getData(collection: "Players", as: Player.self)
            noticias = try await getData(collection: "News", as: Noticia.self)
            actualGames = try await getData(collection: "ActualGame", as: ActualGame.self)
            rewardsInstructions = try await getData(collection: "Reward_Instructions", as: RewardInstruction.self)
            updates = try await getData(collection: "Updates", as: Update.self)
            staff = try await getData(collection: "Staff", as: StaffMember.self)
            priceRules = try await getData(collection: "PriceRules", as: PriceRule.self)
            
            //Print the actual app version
            versionUpdateManager.setDefaultsConfigValues()
            versionUpdateManager.fetchRemoteConfigValues()
            
            // If update is needed change the default alert config
            if(versionUpdateManager.isUpdateNeeded().0){
                updateNeeded = true
                versionUpdateAlertConfig = versionUpdateManager.isUpdateNeeded().1!
            }
        } catch {
            print("Failed to load data: \(error)")
        }
    }
    
    // Used after a purchase
    func loadProducts() async {
        do {
            products = try await getData(collection: "Products", as: Product.self)
        } catch {
            print("Failed to load products data: \(error)")
        }
    }
    
    func openAppStore(url: String) {
        if UIApplication.shared.canOpenURL(URL(string: url)!) {
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
        }
    }
    
    func orderList<T: Identifiable & Comparable>(list: [T]) -> [T] where T.ID: Comparable {
        return list.sorted { $0.id < $1.id }
    }

    
}
