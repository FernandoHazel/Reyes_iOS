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
  case confirmPassword
}

struct SignupView: View {
  @EnvironmentObject var authViewModel: AuthenticationViewModel
  @Environment(\.dismiss) var dismiss

  @FocusState private var focus: FocusableField?
    @State private var formFilled: Bool = false

  var body: some View {
    VStack {
      Text("Registro")
        .font(.largeTitle)
        .fontWeight(.bold)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        HStack{
            VStack{
                TextField("Nombre*", text: $authViewModel.firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                if(!isAlphabetic(authViewModel.firstName)){
                    Text("Por favor escribe tu nombre")
                        .foregroundColor(.red)
                        .font(.caption)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            VStack{
                TextField("Apellido*", text: $authViewModel.lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                if(!isAlphabetic(authViewModel.lastName)){
                    Text("Por favor escribe tu apellido")
                        .foregroundColor(.red)
                        .font(.caption)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
        }
        VStack{
            TextField("Correo Electrónico*", text: $authViewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            if(!isValidEmail(authViewModel.email)){
                Text("Por favor escribe un correo válido")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        VStack{
            TextField("Teléfono*", text: $authViewModel.phone)
                .keyboardType(.phonePad)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            if(!isValidPhoneNumber(authViewModel.phone)){
                Text("Por favor escribe un teléfono válido")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        VStack{
            TextField("Dirección1*", text: $authViewModel.address1)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            if(authViewModel.address1.isEmpty){
                Text("Por favor escribe una dirección válida")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        
        TextField("Dirección2 (opcional)", text: $authViewModel.address2)
            .autocapitalization(.none)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        
        Picker("Estado", selection: $authViewModel.selectedState) {
            ForEach(authViewModel.states, id: \.self) { state in
                Text(state)
            }
        }
        .pickerStyle(MenuPickerStyle())
        
        VStack{
            TextField("Código Postal", text: $authViewModel.postalCode)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            if(!isValidPostalCode(authViewModel.postalCode)){
                Text("Por favor escribe una código postal válido")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        VStack{
            TextField("Ciudad*", text: $authViewModel.city)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            if(!isAlphabetic(authViewModel.city)){
                Text("Por favor escribe una ciudad válida")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    
      HStack {
        Image(systemName: "lock")
        SecureField("Contraseña", text: $authViewModel.password)
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
        SecureField("Confirmar contraseña", text: $authViewModel.confirmPassword)
          .focused($focus, equals: .confirmPassword)
          .submitLabel(.go)
          .onSubmit {
            signUpWithEmailPassword()
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

        Button(action: {
            signUpWithEmailPassword()
        } ) {
        if authViewModel.authenticationState != .authenticating {
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
        .disabled(!(authViewModel.isValid && allFieldsCorrect()))
      .frame(maxWidth: .infinity)
      .buttonStyle(.borderedProminent)

      HStack {
        Text("¿Ya tienes una cuenta?")
        Button(action: { authViewModel.switchFlow() }) {
          Text("Ingresa")
            .fontWeight(.semibold)
            .foregroundColor(.blue)
        }
      }
      .padding([.top, .bottom], 50)
    }
    .onAppear(perform: fillForm)
    .listStyle(.plain)
    .padding()
    .analyticsScreen(name: "\(Self.self)")
  }
    
    // Validate is text only has letters
    private func isAlphabetic(_ text: String) -> Bool {
        if(text.isEmpty){
            return false
        }
        let alphabeticRegex = "^[a-zA-ZáéíóúÁÉÍÓÚñÑ]+$"
        return text.range(of: alphabeticRegex, options: .regularExpression) != nil
    }
    private func isValidEmail(_ email: String) -> Bool {
        if(email.isEmpty){
            return false
        }
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        if(phoneNumber.isEmpty){
            return false
        }
        let phoneRegex = "^[0-9+\\-()\\s]{7,15}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phoneNumber)
    }
    private func isValidPostalCode(_ postalCode: String) -> Bool {
        if(postalCode.isEmpty){
            return false
        }
        let postalCodeRegex = "^[0-9]{5}$" // only numbers and only 5 digits
        return NSPredicate(format: "SELF MATCHES %@", postalCodeRegex).evaluate(with: postalCode)
    }

    private func fillForm(){
        authViewModel.fetchMember()
    }
    
    private func signUpWithEmailPassword() {
      Task {
        if await authViewModel.singUpOrLinkAccount() == true {
          dismiss()
        }
      }
    }
    
    func allFieldsCorrect() -> Bool {
        return isAlphabetic(authViewModel.firstName) && isAlphabetic(authViewModel.lastName) && isValidEmail(authViewModel.email) && isValidPhoneNumber(authViewModel.phone) && !authViewModel.address1.isEmpty && isValidPostalCode(authViewModel.postalCode) && isAlphabetic(authViewModel.city)
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
