// see https://michael-ginn.medium.com/creating-optional-viewbuilder-parameters-in-swiftui-views-a0d4e3e1a0ae
//
//  UserInfo.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 31/10/24.
//

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
                  .foregroundColor(.yellow)
              Button("Ingresar") {
                  viewModel.reset()
                  presentingLoginScreen.toggle()
              }
              .foregroundColor(.white)
          }
          .padding(.bottom)
      }
      .sheet(isPresented: $presentingLoginScreen) {
          ScrollView{
              AuthenticationView()
                .environmentObject(viewModel)
          }
      }
    case .authenticated:
        EmptyView()
    }
  }
}

struct AuthenticatedView_Previews: PreviewProvider {
  static var previews: some View {
    AuthenticatedView()
          .environmentObject(AuthenticationViewModel())
  }
}
