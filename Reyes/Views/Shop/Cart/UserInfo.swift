//
//  UserInfo.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 18/09/24.
//

import SwiftUI

struct UserInfo: View {
    @State private var firstName: String = ""
    @State private var firstNameError: Bool = false
    @State private var lastName: String = ""
    @State private var lastNameError: Bool = false
    @State private var email: String = ""
    @State private var emailError: Bool = false
    @State private var phone: String = "" // Add country code
    @State private var phoneError: Bool = false
    @State private var adress1: String = ""
    @State private var adress1Error: Bool = false
    @State private var adress2: String = ""
    @State private var selectedCountry = "México"
        let countries = ["México", "Estados Unidos"]
    @State private var postalCode: String = ""
    @State private var postalCodeError: Bool = false
    @State private var city: String = ""
    @State private var cityError: Bool = false
    @State private var province: String = ""
    @State private var provinceError: Bool = false
    
    @State private var infoVerified: Bool = false
    
    var body: some View {
        VStack{
            
            Form {
                Section(header: Text("Información de envío")){
                    HStack{
                        VStack{
                            TextField("Nombre*", text: $firstName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            if(firstNameError){
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
                            if(lastNameError){
                                Text("Por favor escribe tu apellido")
                                    .foregroundColor(.red)
                                    .font(.caption)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        
                    }
                    VStack{
                        TextField("Correo Electrónico*", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        if(emailError){
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
                        if(phoneError){
                            Text("Por favor escribe un teléfono válido")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                    VStack{
                        TextField("Dirección1*", text: $adress1)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        if(adress1Error){
                            Text("Por favor escribe una dirección válida")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                    
                    TextField("Dirección2 (opcional)", text: $adress2)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Picker("País", selection: $selectedCountry) {
                        ForEach(countries, id: \.self) { country in
                            Text(country)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    
                    VStack{
                        TextField("Código Postal", text: $postalCode)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        if(postalCodeError){
                            Text("Por favor escribe una código postal válido")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                    VStack{
                        TextField("Ciudad*", text: $city)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        if(cityError){
                            Text("Por favor escribe una ciudad válida")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                    
                    VStack{
                        TextField("Estado / Provincia / Territorio", text: $province)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        if(provinceError){
                            Text("Por favor escribe un territorio válido")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }
                }
            }
            Spacer()
            
            if (infoVerified){
                OrderSumaryButton()
            } else {
                Button {
                    validateForm()
                } label: {
                    Text("Revisar formulario")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .lineLimit(1)
                        .background(
                            Color.yellow
                                .cornerRadius(10)
                                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                                .frame(width: 300)
                        )
                }
            }
            Spacer()
        }
    }
    
    func validateForm(){

        //Not empty and alphabetic
        if(!firstName.isEmpty && isAlphabetic(firstName)){
            firstNameError = false
        } else {
            firstNameError = true
        }
        if(!lastName.isEmpty && isAlphabetic(lastName)){
            lastNameError = false
        } else {
            lastNameError = true
        }
        
        if(isValidEmail(email)){
            emailError = false
        } else {
            emailError = true
        }
        
        if(!phone.isEmpty && isValidPhoneNumber(phone)){
            phoneError = false
        } else {
            phoneError = true
        }
        
        if(!adress1.isEmpty){
            adress1Error = false
        } else {
            adress1Error = true
        }
        
        if(isValidPostalCode(postalCode)){
            postalCodeError = false
        } else {
            postalCodeError = true
        }
        
        if(!city.isEmpty && isAlphabetic(city)){
            cityError = false
        } else {
            cityError = true
        }
        
        if(!province.isEmpty && isAlphabetic(province)){
            provinceError = false
        } else {
            provinceError = true
        }
        
        // If we get any single error of any field the info of the form is not verified
        if (firstNameError || lastNameError || emailError || phoneError || adress1Error || postalCodeError || cityError || provinceError){
            infoVerified = false
        } else {
            infoVerified = true
        }
    }
        
    // Validate is text only has letters
    func isAlphabetic(_ text: String) -> Bool {
        let alphabeticRegex = "^[a-zA-ZáéíóúÁÉÍÓÚñÑ]+$"
        return text.range(of: alphabeticRegex, options: .regularExpression) != nil
    }
    // Validate a valid email
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^[0-9+\\-()\\s]{7,15}$"
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phoneNumber)
    }
    func isValidPostalCode(_ postalCode: String) -> Bool {
        let postalCodeRegex = "^[0-9]{5}$" // only numbers and only 5 digits
        return NSPredicate(format: "SELF MATCHES %@", postalCodeRegex).evaluate(with: postalCode)
    }

}

struct OrderSumaryButton: View {
    var body: some View {
        NavigationLink(destination: Text("Resumen de la compra")) {
            Text("Resumen de compra")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding()
                .lineLimit(1)
                .background(
                    Color.green
                        .cornerRadius(10)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .frame(width: 300)
                )
        }
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
