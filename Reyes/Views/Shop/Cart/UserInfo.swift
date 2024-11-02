//
//  UserInfo.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 18/09/24.
//

import SwiftUI

struct UserInfo: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var isShowingOrderSummary = false
    
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
        authViewModel.fetchMember()
    }
    
    private func anonymousSingIn() {
        authViewModel.anonymousSingIn()
    }
    
    var body: some View {
        VStack{
            
            Form {
                Section(header: Text("Información de envío")){
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
                        TextField("Dirección1*", text: $authViewModel.adress1)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        if(authViewModel.adress1.isEmpty){
                            Text("Por favor escribe una dirección válida")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                    
                    TextField("Dirección2 (opcional)", text: $authViewModel.adress2)
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
                }
            }
            Spacer()
            
            if (isAlphabetic(authViewModel.firstName) && isAlphabetic(authViewModel.lastName) && isValidEmail(authViewModel.email) && isValidPhoneNumber(authViewModel.phone) && !authViewModel.adress1.isEmpty && isValidPostalCode(authViewModel.postalCode) && isAlphabetic(authViewModel.city)
            ){
                VStack {
                    Button(action: {
                        anonymousSingIn()
                        isShowingOrderSummary = true
                    }) {
                        Text("Resumen de compra")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding()
                            .lineLimit(1)
                            .background(
                                Color.green
                                    .cornerRadius(10)
                                    .shadow(radius: 10)
                                    .frame(maxWidth: .infinity)
                            )
                    }

                    // Navegación manual
                    NavigationLink(destination: OrderSummary(), isActive: $isShowingOrderSummary) {
                        EmptyView()
                    }
                }
            }
            
            Spacer()
        }.onAppear(perform: fillForm)
    }
}

struct OrderSummaryButton: View {
    @State private var isShowingOrderSummary = false

    var body: some View {
        VStack {
            Button(action: {
                showOrderSummary()
            }) {
                Text("Resumen de compra")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .lineLimit(1)
                    .background(
                        Color.green
                            .cornerRadius(10)
                            .shadow(radius: 10)
                            .frame(width: 300)
                    )
            }

            // Navegación manual
            NavigationLink(destination: OrderSummary(), isActive: $isShowingOrderSummary) {
                EmptyView()
            }
        }
    }

    // Método a ejecutar al presionar el botón
    func showOrderSummary() {
        // Ejecutar lógica adicional aquí
        isShowingOrderSummary = true
    }
}

struct UserInfo_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {

        var body: some View {
            UserInfo()
        }
    }
}
