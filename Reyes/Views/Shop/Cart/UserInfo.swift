//
//  UserInfo.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 18/09/24.
//

import SwiftUI

struct UserInfo: View {
    
    // Get a reference to the managed object context from the environment.
    @Environment(\.managedObjectContext) private var viewContext
    
    // I have "users" but is supposed to exist only one
    @FetchRequest(sortDescriptors: [])
    private var users: FetchedResults<UserData>
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
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
    //@State private var province: String = ""
    
    @State private var isShowingOrderSummary = false
    
    var body: some View {
        VStack{
            
            Form {
                Section(header: Text("Información de envío")){
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
                        TextField("Correo Electrónico*", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        if(!isValidEmail(email)){
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
                    
                    /*VStack{
                        TextField("Estado / Provincia / Territorio", text: $province)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        if(!isAlphabetic(province)){
                            Text("Por favor escribe un territorio válido")
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                    }*/
                }
            }
            Spacer()
            
            if (isAlphabetic(firstName) && isAlphabetic(lastName) && isValidEmail(email) && isValidPhoneNumber(phone) && !adress1.isEmpty && isValidPostalCode(postalCode) && isAlphabetic(city) //&& isAlphabetic(province)
            ){
                VStack {
                    Button(action: {
                        saveUserData()
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
    
    // Validate is text only has letters
    private func isAlphabetic(_ text: String) -> Bool {
        if(text.isEmpty){
            return false
        }
        let alphabeticRegex = "^[a-zA-ZáéíóúÁÉÍÓÚñÑ]+$"
        return text.range(of: alphabeticRegex, options: .regularExpression) != nil
    }
    // Validate a valid email
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
            email = users.first?.email ?? ""
            phone = users.first?.phone ?? ""
            adress1 = users.first?.adress1 ?? ""
            adress2 = users.first?.adress2 ?? ""
            selectedState = users.first?.selectedState ?? ""
            postalCode = users.first?.postalCode ?? ""
            city = users.first?.city ?? ""
            //province = users.first?.province ?? ""
        }
    }
    
    private func saveUserData() {

        // Check if user already exist
        if let existingUser = users.first {
            // Update existing user
            existingUser.firstName = firstName
            existingUser.lastName = lastName
            existingUser.email = email
            existingUser.phone = phone
            existingUser.adress1 = adress1
            existingUser.adress2 = adress2
            existingUser.selectedState = selectedState
            existingUser.postalCode = postalCode
            existingUser.city = city
            //existingUser.province = province
        } else {
            // Create a new user
            let newUser = UserData(context: viewContext)
            newUser.firstName = firstName
            newUser.lastName = lastName
            newUser.email = email
            newUser.phone = phone
            newUser.adress1 = adress1
            newUser.adress2 = adress2
            newUser.selectedState = selectedState
            newUser.postalCode = postalCode
            newUser.city = city
            //newUser.province = province
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
