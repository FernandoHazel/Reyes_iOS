import SwiftUI
import FirebaseCore
import FirebaseAuth
import Stripe

// Test Backend URL: https://moored-shimmer-atlasaurus.glitch.me
// Can find the project in https://glitch.com/edit/#!/moored-shimmer-atlasaurus?path=README.md%3A1%3A0

// This URL will be different in production
let BaseBackendURL = "http://127.0.0.1:1234/"
var stripeInitialized = false

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
        print("\n - - - - - - - - - - PUBLISHABLE KEY - - - - - - - - - - \n")
        
        //Get the publishable kay from the server
        let configUrl = URL(string: BaseBackendURL + "config")
        var request = URLRequest(url: configUrl!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let publishableKey = json["publishableKey"] as? String else {
                print("FAILED TO RETRIEVE PUBLISHABLE KEY FORM SERVER...")
                stripeInitialized = false
                return
            }
            print("PUBLISHABLE KEY: \(publishableKey)")
            StripeAPI.defaultPublishableKey = publishableKey
            stripeInitialized = true
        })
        task.resume()
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
