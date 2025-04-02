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
    @EnvironmentObject var vm: AppViewModel

    var body: some View {
        
        let products = vm.products
        let selectedProducts = authViewModel.selectedProducts
        
        var cartSum: Double {
            selectedProducts.reduce(0.0) { sum, entry in
                let (idAndSize, quantity) = entry
                let parts = idAndSize.split(separator: "-")
                guard let id = Int(parts[0]), parts.count > 1,
                      let product = products.first(where: { $0.id == id }) else { return sum }
                
                let productTotal = product.price * (1 - product.discount / 100.0) * Double(quantity)
                return sum + productTotal
            }
        }
        
        var rewardSum: Double {
            // Floor rewards to the lowest number
            return floor(( cartSum + calcularCostoEnvio() ) / 10)
        }

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
                    Text("De 7 a 14 días")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.green)
                }
                
            }
            Section(header: Text("Artículos")){
                VStack {
                    List {
                        ForEach(selectedProducts.keys.sorted(), id: \.self) { idAndSize in
                            if let quantity = selectedProducts[idAndSize] {
                                let parts = idAndSize.split(separator: "-")
                                if let id = Int(parts[0]), parts.count > 1 {
                                    let size = String(parts[1])
                                    
                                    if let product = products.first(where: { $0.id == id }) {
                                        CartProductRow(cartProduct: product, quantity: quantity, size: size)
                                    }
                                }
                            }
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
                        Text("$\(String(format: "%.2f", cartSum))")
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
                        Text("$\(String(format: "%.2f", cartSum + calcularCostoEnvio()))")
                            .font(.title)
                            .bold()
                    }
                    HStack{
                        Text("Coronas obtenidas:")
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Text("\(String(format: "%.2f", rewardSum))")
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
    
    private func calcularCostoEnvio() -> Double {
        
        // Hacer una petición al back y calcular en base a las reglas de negocio
        // ..
        return 222.0
    }
}

#Preview {
    OrderSummary()
}
