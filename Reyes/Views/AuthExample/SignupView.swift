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
  @EnvironmentObject var viewModel: AuthenticationViewModel
  @Environment(\.dismiss) var dismiss

  @FocusState private var focus: FocusableField?
    
    // Get a reference to the managed object context from the environment.
    @Environment(\.managedObjectContext) private var viewContext
    
    // I have "users" but is supposed to exist only one
    @FetchRequest(sortDescriptors: [])
    private var users: FetchedResults<UserData>
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var phone: String = ""
    @State private var adress1: String = ""
    @State private var adress2: String = ""
    @State private var selectedState = "Jalisco"
        let states = [
            "Aguascalientes",
            "Baja California",
            "Baja California Sur",
            "Campeche",
            "Chiapas",
            "Chihuahua",
            "Ciudad de México",
            "Coahuila",
            "Colima",
            "Durango",
            "Guanajuato",
            "Guerrero",
            "Hidalgo",
            "Jalisco",
            "Estado de México",
            "Michoacán",
            "Morelos",
            "Nayarit",
            "Nuevo León",
            "Oaxaca",
            "Puebla",
            "Querétaro",
            "Quintana Roo",
            "San Luis Potosí",
            "Sinaloa",
            "Sonora",
            "Tabasco",
            "Tamaulipas",
            "Tlaxcala",
            "Veracruz",
            "Yucatán",
            "Zacatecas"]
    @State private var postalCode: String = ""
    @State private var city: String = ""
    
    @State private var formFilled: Bool = false

  var body: some View {
    VStack {
      Text("Registro")
        .font(.largeTitle)
        .fontWeight(.bold)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        // UserInfo Form
        HStack{
            VStack{
                TextField("Nombre*", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                if(!isAlphabetic(firstName)){
                    Text("Por favor escribe tu nombre")
                        .foregroundColor(.red)
                        .font(.caption)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            VStack{
                TextField("Apellido*", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                if(!isAlphabetic(lastName)){
                    Text("Por favor escribe tu apellido")
                        .foregroundColor(.red)
                        .font(.caption)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
        }
        VStack{
            TextField("Correo Electrónico*", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            if(!isValidEmail(viewModel.email)){
                Text("Por favor escribe un correo válido")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        VStack{
            TextField("Teléfono*", text: $phone)
                .keyboardType(.phonePad)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            if(!isValidPhoneNumber(phone)){
                Text("Por favor escribe un teléfono válido")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        VStack{
            TextField("Dirección1*", text: $adress1)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            if(adress1.isEmpty){
                Text("Por favor escribe una dirección válida")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        
        TextField("Dirección2 (opcional)", text: $adress2)
            .autocapitalization(.none)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        
        Picker("Estado", selection: $selectedState) {
            ForEach(states, id: \.self) { state in
                Text(state)
            }
        }
        .pickerStyle(MenuPickerStyle())
        
        VStack{
            TextField("Código Postal", text: $postalCode)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            if(!isValidPostalCode(postalCode)){
                Text("Por favor escribe una código postal válido")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        VStack{
            TextField("Ciudad*", text: $city)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            if(!isAlphabetic(city)){
                Text("Por favor escribe una ciudad válida")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
    
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

        Button(action: {
            saveUserData()
            signUpWithEmailPassword()
        } ) {
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
        .disabled(!(viewModel.isValid && allFieldsCorrect()))
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

    // Data functions
    private func fillForm(){
        if (users.first != nil) {
            // Update existing user
            firstName = users.first?.firstName ?? ""
            lastName = users.first?.lastName ?? ""
            viewModel.email = users.first?.email ?? ""
            phone = users.first?.phone ?? ""
            adress1 = users.first?.adress1 ?? ""
            adress2 = users.first?.adress2 ?? ""
            selectedState = users.first?.selectedState ?? ""
            postalCode = users.first?.postalCode ?? ""
            city = users.first?.city ?? ""
        }
    }
    
    private func saveUserData() {

        // Check if user already exist
        if let existingUser = users.first {
            // Update existing user
            existingUser.firstName = firstName
            existingUser.lastName = lastName
            existingUser.email = viewModel.email
            existingUser.phone = phone
            existingUser.adress1 = adress1
            existingUser.adress2 = adress2
            existingUser.selectedState = selectedState
            existingUser.postalCode = postalCode
            existingUser.city = city
        } else {
            // Create a new user
            let newUser = UserData(context: viewContext)
            newUser.firstName = firstName
            newUser.lastName = lastName
            newUser.email = viewModel.email
            newUser.phone = phone
            newUser.adress1 = adress1
            newUser.adress2 = adress2
            newUser.selectedState = selectedState
            newUser.postalCode = postalCode
            newUser.city = city
            newUser.rewards = 0
        }
        
        // Save changes
        saveContext()
    }
    
    private func saveContext(){
        do{
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Could't save context while adding user data: \(error.localizedDescription)")
        }
    }
    
    private func signUpWithEmailPassword() {
      Task {
        if await viewModel.signUpWithEmailPassword() == true {
          dismiss()
        }
      }
    }
    
    func allFieldsCorrect() -> Bool {
        return isAlphabetic(firstName) && isAlphabetic(lastName) && isValidEmail(viewModel.email) && isValidPhoneNumber(phone) && !adress1.isEmpty && isValidPostalCode(postalCode) && isAlphabetic(city)
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
