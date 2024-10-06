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
                        Text("$\(String(format: "%.2f", calcularCostoEnvio()))")
                    }
                    Divider()
                    HStack{
                        Text("Total")
                            .bold()
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Text("$\(String(format: "%.2f", cartSum() + calcularCostoEnvio()))")
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
                    PaymentView()
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
    private func calcularCostoEnvio() -> Double {
        
        //La tarifa debe ser parametrizable en base al estado a dónde hay que enviar
        let costoTotal = 200.0
        
        return costoTotal
    }

    private func calculateRewards() -> Double{
        var sum: Double = 0
        cartProducts.forEach { cartProduct in
            sum += cartProduct.reward * Double(cartProduct.quantitySelected)
        }
        return sum
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
        //showPurchaseAlert = true
        
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

}

#Preview {
    OrderSummary()
}
