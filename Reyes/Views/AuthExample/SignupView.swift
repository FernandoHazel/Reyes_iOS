// Añadir todos los campos que ya obtuvimos en la vista de checkout si es el caso
// Para eso puedo intentar traer la vista de user info

import SwiftUI
import Combine
import FirebaseAnalytics

private enum FocusableField: Hashable {
  case email
  case password
  case confirmPassword
}

struct SignupView: View {
  @EnvironmentObject var viewModel: AuthenticationViewModel
  @Environment(\.dismiss) var dismiss

  @FocusState private var focus: FocusableField?

  private func signUpWithEmailPassword() {
    Task {
      if await viewModel.signUpWithEmailPassword() == true {
        dismiss()
      }
    }
  }

  var body: some View {
    VStack {
      Text("Registro")
        .font(.largeTitle)
        .fontWeight(.bold)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        // Añadir la vista de user info
        UserInfo()

      HStack {
        Image(systemName: "lock")
        SecureField("Contraseña", text: $viewModel.password)
          .focused($focus, equals: .password)
          .submitLabel(.next)
          .onSubmit {
            self.focus = .confirmPassword
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 8)

      HStack {
        Image(systemName: "lock")
        SecureField("Confirmar contraseña", text: $viewModel.confirmPassword)
          .focused($focus, equals: .confirmPassword)
          .submitLabel(.go)
          .onSubmit {
            signUpWithEmailPassword()
          }
      }
      .padding(.vertical, 6)
      .background(Divider(), alignment: .bottom)
      .padding(.bottom, 8)


      if !viewModel.errorMessage.isEmpty {
        VStack {
          Text(viewModel.errorMessage)
            .foregroundColor(Color(UIColor.systemRed))
        }
      }

      Button(action: signUpWithEmailPassword) {
        if viewModel.authenticationState != .authenticating {
          Text("Registrate")
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
      .disabled(!viewModel.isValid)
      .frame(maxWidth: .infinity)
      .buttonStyle(.borderedProminent)

      HStack {
        Text("¿Ya tienes una cuenta?")
        Button(action: { viewModel.switchFlow() }) {
          Text("Ingresa")
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

struct SignupView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      SignupView()
      SignupView()
        .preferredColorScheme(.dark)
    }
    .environmentObject(AuthenticationViewModel())
  }
}
