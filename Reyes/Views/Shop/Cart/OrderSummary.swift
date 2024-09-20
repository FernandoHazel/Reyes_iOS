//
//  OrderSummary.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 19/09/24.
//

import SwiftUI
import Foundation

struct OrderSummary: View {
    // Get a reference to the managed object context from the environment.
    @Environment(\.managedObjectContext) private var viewContext
    
    // I have "users" but is supposed to exist only one
    @FetchRequest(sortDescriptors: [])
    private var users: FetchedResults<UserData>
    
    @FetchRequest(sortDescriptors: [])
    private var cartProducts: FetchedResults<CartProduct>
    
    @State private var selectedPaymentMethod: PaymentMethod?
    
    let paymentMethods = [
        PaymentMethod(name: "Tarjeta de Crédito", icon: "creditcard"),
        PaymentMethod(name: "Paypal", icon: "paypal"),
        PaymentMethod(name: "Apple Pay", icon: "applelogo")
    ]

    var body: some View {
        Form {
            Section(header: Text("Información de envío")){
                VStack{
                    Text("\(users.first?.firstName ?? "") \(users.first?.lastName ?? "")")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(users.first?.adress1 ?? "")")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(users.first?.city ?? ""), \(users.first?.province ?? ""), \(users.first?.postalCode ?? ""), \(users.first?.selectedCountry ?? "")")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                VStack{
                    Text("Fecha estimada de entrega")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.green)
                    Text("De 7 a 14 días") // Calculate somehow (can be something generic like 7-14 days)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.green)
                }
                
            }
            Section(header: Text("Artículos")){
                VStack {
                    List {
                        ForEach(cartProducts) { cartProduct in
                            CartProductRow(cartProduct: cartProduct)
                        }
                    }
                }
            }
            Section(header: Text("Resumen del pedido")){
                VStack{
                    HStack{
                        Text("Total de artículos")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Text("$\(String(format: "%.2f", cartSum()))")
                    }
                    HStack{
                        Text("Envío")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Text("$\(String(format: "%.2f", calcularCostoEnvio(peso: 1, distancia: 10, tipoEnvio: "estándar")))")
                    }
                    Divider()
                    HStack{
                        Text("Total")
                            .bold()
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Text("$\(String(format: "%.2f", cartSum() + calcularCostoEnvio(peso: 1, distancia: 10, tipoEnvio: "estándar")))")
                            .font(.title)
                            .bold()
                    }
                    HStack{
                        Text("Coronas obtenidas:")
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Text("\(String(format: "%.2f", calculateRewards()))")
                            .bold()
                            .foregroundColor(.green)
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                    }
                }
            }
            Section(header: Text("Método de pago")){
                VStack{
                    List(paymentMethods) { method in
                        HStack {
                            Text(method.name)
                            Spacer()
                            if(method.icon == "creditcard"){
                                Image(systemName: method.icon)
                                    .resizable()
                                    .frame(width: 40, height: 30)
                            } else if (method.icon == "paypal") {
                                Image("paypal")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                            } else {
                                Image(systemName: method.icon)
                                    .resizable()
                                    .frame(width: 25, height: 30)
                            }

                            if selectedPaymentMethod?.id == method.id {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .onTapGesture {
                            selectedPaymentMethod = method
                        }
                    }

                    if let selectedMethod = selectedPaymentMethod {
                        if (selectedMethod.name == "Tarjeta de Crédito"){
                            CreditCardForm()
                        }
                    }
                }
            }
        }
    }
    
    private func cartSum() -> Double{
        var sum: Double = 0
        cartProducts.forEach { cartProduct in
            let priceWithDiscount = cartProduct.price - cartProduct.price * cartProduct.discount / 100
            let productTotal = priceWithDiscount * Double(cartProduct.quantitySelected)
            sum += productTotal
        }
        return sum
    }
    
    // Esta es una función de ejemplo pero hay que definirla bien hablando con una empresa dedicada a esto
    private func calcularCostoEnvio(peso: Double, distancia: Double, tipoEnvio: String) -> Double {
        let tarifaPorKilo: Double = 5.0  // Tarifa base por kilogramo
        let tarifaPorKilometro: Double = 0.1  // Tarifa base por kilómetro
        let cargoBase: Double = 10.0  // Costo fijo base de envío
        var multiplicadorTipoEnvio: Double

        // Determinar multiplicador según el tipo de envío
        switch tipoEnvio.lowercased() {
        case "urgente":
            multiplicadorTipoEnvio = 1.5  // Costo mayor por envío urgente
        case "estándar":
            multiplicadorTipoEnvio = 1.0  // Costo estándar
        default:
            multiplicadorTipoEnvio = 0.8  // Costo menor por envío económico
        }

        // Calcular el costo total
        let costoPeso = peso * tarifaPorKilo
        let costoDistancia = distancia * tarifaPorKilometro
        let costoTotal = (cargoBase + costoPeso + costoDistancia) * multiplicadorTipoEnvio
        
        return costoTotal
    }

    private func calculateRewards() -> Double{
        var sum: Double = 0
        cartProducts.forEach { cartProduct in
            sum += cartProduct.reward * Double(cartProduct.quantitySelected)
        }
        return sum
    }
}

struct CreditCardForm: View {
    // Get a reference to the managed object context from the environment.
    @Environment(\.managedObjectContext) private var viewContext
    
    // I have "users" but is supposed to exist only one
    @FetchRequest(sortDescriptors: [])
    private var users: FetchedResults<UserData>
    
    @FetchRequest(sortDescriptors: [])
    private var cartProducts: FetchedResults<CartProduct>
    
    @State private var cardNumber: String = ""
    @State private var mmyy: String = ""
    @State private var cvv: String = ""
    
    //Delete in production
    @State private var showPurchaseAlert: Bool = false
    
    var body: some View {
        VStack{
            VStack{
                TextField("CardNumber", text: $cardNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                if(!isValidCard(cardNumber)){
                    Text("La tarjeta no tiene un formato válido")
                        .foregroundColor(.red)
                        .font(.caption)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            HStack{
                VStack{
                    TextField("MM/YY", text: $mmyy)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    if(!isValidCreditCardExpiry(mmyy)){
                        Text("La fecha de expiración no es válida")
                            .foregroundColor(.red)
                            .font(.caption)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                VStack{
                    TextField("CVV", text: $cvv)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    // error validation
                    if(!isValidCVV(cvv)){
                        Text("El cvv no tiene un formato válido")
                            .foregroundColor(.red)
                            .font(.caption)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
            }
            
            Spacer()
            
            if (isValidCard(cardNumber) && isValidCreditCardExpiry(mmyy) && isValidCVV(cvv)){
                Button {
                    purchase()
                } label: {
                    Text("Pagar")
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
            Spacer()
        }.alert(isPresented: $showPurchaseAlert) {
            Alert(
                title: Text("¡Ya casi está!"),
                message: Text("La función de compra sigue en desarrollo, pulsa OK para continuar."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func purchase(){
        //1. Generate the order (verify if the payment method does not do this for us)
        
        //2. Erase the cart products
        cartProducts.forEach { cartProduct in
            viewContext.delete(cartProduct)
        }
        
        //3. Update the remote inventory
        
        //4. Add rewards
        users.first!.rewards += calculateRewards()

        
        //5. Show alert (delete in production)
        showPurchaseAlert = true
        
        //6. Save context
        saveContext()
    }
    
    private func saveContext(){
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Could't save context while adding cart product: \(error.localizedDescription)")
        }
    }

    private func isValidCard(_ card: String) -> Bool {
        // Verificar si el número tiene 16 dígitos (tu validación actual)
        if(card.isEmpty){
            return false
        }
        let cardNumberRegex = "^[0-9]{16}$"
        let isValidLength = NSPredicate(format: "SELF MATCHES %@", cardNumberRegex).evaluate(with: card)

        // Si no tiene el formato correcto, ya es inválido
        guard isValidLength else { return false }
        
        // Validar el número de tarjeta con el algoritmo de Luhn
        return isValidLuhn(card)
    }
    // El algoritmo de Luhn realiza una serie de pasos matemáticos sobre los dígitos del número de tarjeta. Si el resultado final es divisible por 10, entonces el número de tarjeta es válido según este algoritmo.
    private func isValidLuhn(_ cardNumber: String) -> Bool {
        var sum = 0
        let reversedDigits = cardNumber.reversed().map { String($0) }
        
        for (idx, element) in reversedDigits.enumerated() {
            guard let digit = Int(element) else { return false }

            if idx % 2 == 1 {
                // Duplicar los dígitos en posiciones impares (según la lógica de Luhn)
                let doubledDigit = digit * 2
                sum += doubledDigit > 9 ? doubledDigit - 9 : doubledDigit
            } else {
                // Sumar los dígitos en posiciones pares tal como están
                sum += digit
            }
        }
        
        // Si la suma es divisible por 10, el número es válido
        return sum % 10 == 0
    }
    private func isValidCreditCardExpiry(_ expiryDate: String) -> Bool {
        if(expiryDate.isEmpty){
            return false
        }
        // Validar que el formato sea MM/YY
        let dateRegex = "^(0[1-9]|1[0-2])/[0-9]{2}$"
        let datePredicate = NSPredicate(format: "SELF MATCHES %@", dateRegex)
        
        // Si no coincide con el formato, devolver falso
        guard datePredicate.evaluate(with: expiryDate) else {
            return false
        }

        // Obtener la fecha actual y formatearla para comparala con la ingresada
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MM/yy"
        
        // Formateamos la fecha ingresada si no está vacía
        if let enteredDate = dateFormatter.date(from: expiryDate){
            // Comparar la fecha ingresada con la fecha actual
            if enteredDate > currentDate {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    private func isValidCVV(_ cvv: String) -> Bool {
        // Verificar si el número tiene 16 dígitos (tu validación actual)
        if(cvv.isEmpty){
            return false
        }
        let cvvRegex = "^[0-9]{3}$"
        let isValidLength = NSPredicate(format: "SELF MATCHES %@", cvvRegex).evaluate(with: cvv)

        // Si no tiene el formato correcto, ya es inválido
        guard isValidLength else { return false }
        
        // Validar el número de tarjeta con el algoritmo de Luhn
        if isValidLength {
            return true
        } else {
            return false
        }
    }
    private func calculateRewards() -> Double{
        var sum: Double = 0
        cartProducts.forEach { cartProduct in
            sum += cartProduct.reward * Double(cartProduct.quantitySelected)
        }
        return sum
    }
}

struct PaymentMethod: Identifiable {
    let id = UUID()
    let name: String
    let icon: String // Name of the image asset
}


#Preview {
    OrderSummary()
}
