import SwiftUI
import FirebaseCore

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
    @StateObject private var vm = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
                .task {
                    await vm.loadAllData()
                }
        }
    }
}
