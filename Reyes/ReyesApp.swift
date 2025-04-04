import SwiftUI
import FirebaseCore
import FirebaseAuth


//App delegate used to initialize firebase
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      
    return true
  }
}

@main
struct ReyesApp: App {
    //Register the app delegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Create observable instances for Core Data stack and ViewModels
    @StateObject private var coreDataStack = CoreDataStack.shared
    @StateObject private var appViewModel = AppViewModel()
    @StateObject private var authViewModel = AuthenticationViewModel()
    
    
    init(){
        getStripeKey()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
                .environmentObject(authViewModel)
                // Inject the persistent container's managed object context into the environment.
                .environment(\.managedObjectContext, coreDataStack.persistentContainer.viewContext)
                .task {
                    await appViewModel.loadAllData()
                }
        }
    }
}
