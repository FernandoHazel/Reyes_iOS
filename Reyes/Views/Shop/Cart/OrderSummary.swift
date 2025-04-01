//
//  OrderSummary.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 19/09/24.
//

import SwiftUI
import Foundation

struct OrderSummary: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [])
    private var cartProducts: FetchedResults<CartProduct>
    
    @State var purchaseCompleted = false

    var body: some View {

        Form {
            Section(header: Text("Información de envío")){
                VStack{
                    Text("\(authViewModel.firstName) \(authViewModel.lastName)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(authViewModel.address1)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("\(authViewModel.city), \(authViewModel.selectedState), \(authViewModel.postalCode)")
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
                            //CartProductRow(cartProduct: cartProduct)
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
                    PaymentView(purchaseCompleted: $purchaseCompleted)
                }
            }
        }.sheet(isPresented: $purchaseCompleted) {
            CongratsView()
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
        var costoTotal = 0.0
        
        switch authViewModel.selectedState{
        case "Aguascalientes":
            costoTotal = 200
        case "Baja California":
            costoTotal = 500
        case "Baja California Sur":
            costoTotal = 300
        case "Campeche":
            costoTotal = 300
        case "Chiapas":
            costoTotal = 300
        case "Chihuahua":
            costoTotal = 400
        case "Ciudad de México":
            costoTotal = 200
        case "Coahuila":
            costoTotal = 400
        case "Colima":
            costoTotal = 200
        case "Durango":
            costoTotal = 400
        case "Guanajuato":
            costoTotal = 600
        case "Guerrero":
            costoTotal = 700
        case "Hidalgo":
            costoTotal = 200
        case "Jalisco":
            costoTotal = 200
        case "Estado de México":
            costoTotal = 200
        case "Michoacán":
            costoTotal = 200
        case "Morelos":
            costoTotal = 200
        case "Nayarit":
            costoTotal = 300
        case "Nuevo León":
            costoTotal = 200
        case "Oaxaca":
            costoTotal = 200
        case "Puebla":
            costoTotal = 200
        case "Querétaro":
            costoTotal = 200
        case "Quintana Roo":
            costoTotal = 300
        case "San Luis Potosí":
            costoTotal = 155
        case "Sinaloa":
            costoTotal = 250
        case "Sonora":
            costoTotal = 700
        case "Tabasco":
            costoTotal = 750
        case "Tamaulipas":
            costoTotal = 300
        case "Tlaxcala":
            costoTotal = 300
        case "Veracruz":
            costoTotal = 200
        case "Yucatán":
            costoTotal = 300
        case "Zacatecas":
            costoTotal = 400
        default:
            costoTotal = 200
        }
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

#Preview {
    OrderSummary(purchaseCompleted: false)
}
