import SwiftUI
import FirebaseCore
import FirebaseAnalytics


struct TestButtons: View {
    var body: some View {
        VStack{
            
            Button(action: {
                //Trigger analytic event
                Analytics.logEvent("Test_Button_pressed", parameters: [
                    AnalyticsParameterItemID: "Test_button",
                    AnalyticsParameterItemName: "Reyes_Button",
                ])
            }, label: {
                Text("Analytic")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal, 20)
                    .background(
                        Color.blue
                            .cornerRadius(10)
                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    )
            })
            Button(action: {
                //Trigger error
                fatalError("Crash was triggered")
            }, label: {
                Text("Error")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal, 30)
                    .background(
                        Color.red
                            .cornerRadius(10)
                            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    )
            })
        }
        
    }
}

#Preview {
    TestButtons()
}
