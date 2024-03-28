import SwiftUI
import Combine
import FirebaseAnalyticsSwift

private enum FocusableField: Hashable {
  case email
  case password
  case confirmPassword
}

struct SignUp: View {
    //@EnvironmentObject var viewModel: AuthenticationViewModel
    //@Environment(\.dismiss) var dismiss
    @State private var temporalString: String = ""
    
    @FocusState private var focus: FocusableField?
    
    /*private func signUpWithEmailPassword() {
     Task {
     if await viewModel.signUpWithEmailPassword() == true {
     dismiss()
     }
     }
     }*/
    
    var body: some View {
        VStack {
            Image("Reyes_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(minHeight: 200, maxHeight: 300)
            Text("Sign up")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            HStack {
                Image(systemName: "at")
                TextField("Email", text: $temporalString)
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
            .padding(.leading)
            
            HStack {
                Image(systemName: "lock")
                SecureField("Password", text: $temporalString)
                    .focused($focus, equals: .password)
                    .submitLabel(.next)
                    .onSubmit {
                        self.focus = .confirmPassword
                    }
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 8)
            .padding(.leading)
            
            HStack {
                Image(systemName: "lock")
                SecureField("Confirm password", text: $temporalString)
                    .focused($focus, equals: .confirmPassword)
                    .submitLabel(.go)
                /*.onSubmit {
                 signUpWithEmailPassword()
                 }*/
            }
            .padding(.vertical, 6)
            .background(Divider(), alignment: .bottom)
            .padding(.bottom, 8)
            .padding(.leading)
            
            
            /*if !viewModel.errorMessage.isEmpty {
             VStack {
             Text(viewModel.errorMessage)
             .foregroundColor(Color(UIColor.systemRed))
             }
             }*/
            
            Button(action: {}, label: {
                Text("Registrarse")
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            })
            
            /*  Button(action: signUpWithEmailPassword) {
             if viewModel.authenticationState != .authenticating {
             Text("Sign up")
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
             .buttonStyle(.borderedProminent)*/
            
            Group {
                NavigationView {
                    HStack {
                        Text("¿Ya tienes una cuenta?")
                        NavigationLink(
                            destination: SingIn(),
                            label: {
                                Text("Ingresar")
                            })
                        }
                        .listStyle(.plain)
                        .padding()
                        //.analyticsScreen(name: "\(Self.self)")
                }
            }
            .frame(height: 20)
            }
        
    }
    
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignUp()
            SignUp()
                .preferredColorScheme(.dark)
        }
        //.environmentObject(AuthenticationViewModel())
    }
}
