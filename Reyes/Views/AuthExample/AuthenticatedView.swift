// see https://michael-ginn.medium.com/creating-optional-viewbuilder-parameters-in-swiftui-views-a0d4e3e1a0ae
import SwiftUI

struct AuthenticatedView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
  @State private var presentingLoginScreen = false
  @State private var presentingProfileScreen = false

  var body: some View {
    switch viewModel.authenticationState {
    case .unauthenticated, .authenticating:
      VStack {
          HStack{
              Text("inicia sesión y obtén recompensas.")
                  .foregroundColor(.black)
              Button("Ingresar") {
                viewModel.reset()
                presentingLoginScreen.toggle()
              }.foregroundColor(.white)
          }
          
        
      }
      .sheet(isPresented: $presentingLoginScreen) {
        AuthenticationView()
          .environmentObject(viewModel)
      }
    case .authenticated:
      VStack {
        Text("Estas registrado como \(viewModel.displayName).")
        Button("Presiona aquí para ver tu perfil") {
          presentingProfileScreen.toggle()
        }
      }
      .sheet(isPresented: $presentingProfileScreen) {
        NavigationView {
          UserProfileView()
            .environmentObject(viewModel)
        }
      }
    }
  }
}

struct AuthenticatedView_Previews: PreviewProvider {
  static var previews: some View {
    AuthenticatedView()
          .environmentObject(AuthenticationViewModel())
  }
}
