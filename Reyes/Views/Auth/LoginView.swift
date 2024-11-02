//
//  UserInfo.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 31/10/24.
//

import SwiftUI
import Combine
import FirebaseAnalytics

private enum FocusableField: Hashable {
  case email
  case password
}

struct LoginView: View {
  @EnvironmentObject var authViewModel: AuthenticationViewModel
  @Environment(\.dismiss) var dismiss

  @FocusState private var focus: FocusableField?

  private func signInWithEmailPassword() {
    Task {
      if await authViewModel.signInWithEmailPassword() == true {
        dismiss()
      }
    }
  }

  var body: some View {
    VStack {
      Image("Reyes_logo")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(minHeight: 200, maxHeight: 300)
      Text("Ingresar")
        .font(.largeTitle)
        .fontWeight(.bold)
        .frame(maxWidth: .infinity, alignment: .leading)

      HStack {
        Image(systemName: "at")
        TextField("Email", text: $authViewModel.email)
          .textInputAutocapitalization(.never)
          .disableAutocorrection(true)
          .focused($focus, equals: .email)
          .submitLabel(.next)
          .onSubmit {
            self.focus = .password
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 4)

      HStack {
        Image(systemName: "lock")
        SecureField("Contraseña", text: $authViewModel.password)
          .focused($focus, equals: .password)
          .submitLabel(.go)
          .onSubmit {
            signInWithEmailPassword()
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 8)

      if !authViewModel.errorMessage.isEmpty {
        VStack {
          Text(authViewModel.errorMessage)
            .foregroundColor(Color(UIColor.systemRed))
        }
      }

      Button(action: signInWithEmailPassword) {
        if authViewModel.authenticationState != .authenticating {
          Text("Ingresar")
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        }
        else {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        }
      }
      .disabled(!authViewModel.isValid)
      .frame(maxWidth: .infinity)
      .buttonStyle(.borderedProminent)

      HStack {
        Text("¿Aún no tienes una cuenta?")
        Button(action: { authViewModel.switchFlow() }) {
          Text("Registrate")
            .fontWeight(.semibold)
            .foregroundColor(.blue)
        }
      }
      .padding([.top, .bottom], 50)

    }
    .listStyle(.plain)
    .padding()
    .analyticsScreen(name: "\(Self.self)")
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      LoginView()
      LoginView()
        .preferredColorScheme(.dark)
    }
    .environmentObject(AuthenticationViewModel())
  }
}
