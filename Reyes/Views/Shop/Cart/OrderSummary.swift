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
    @State var showErrorAlert = false
    @State private var showKeyErrorAlert = false
    @State var showPaymentView = false
    @State var errorMessage = ""
    @State var productsTotal = 0.0
    @State var shipmentWithFees = 0.0
    @State var orderTotal = 0.0
    @State var totalReward = 0.0
    @ObservedObject var model = PaymentModel()

    var body: some View {
        
        let products = vm.products
        let selectedProducts = authViewModel.selectedProducts

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
                        if productsTotal == 0.0 {
                            ProgressView()
                        } else {
                            Text("$\(String(format: "%.2f", productsTotal))")
                        }
                    }
                    HStack{
                        Text("Envío")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        if shipmentWithFees == 0.0 {
                            ProgressView()
                        } else {
                            Text("$\(String(format: "%.2f", shipmentWithFees))")
                        }
                    }
                    Divider()
                    HStack{
                        Text("Total")
                            .bold()
                            .font(.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        if orderTotal == 0.0 {
                            ProgressView()
                        } else {
                            Text("$\(String(format: "%.2f", orderTotal))")
                                .font(.title)
                                .bold()
                        }
                    }
                    HStack{
                        Text("Coronas obtenidas:")
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        if totalReward == 0.0 {
                            ProgressView()
                        } else {
                            Text("\(String(format: "%.2f", totalReward))")
                                .bold()
                                .foregroundColor(.green)
                            Image(systemName: "crown.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                }
            }
            Section(header: Text("Método de pago")){
                VStack{
                    if (showPaymentView){
                        PaymentView(totalReward: totalReward)
                    }
                }
            }
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Ocurrió un error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .alert("Error al preparar el pedido", isPresented: $showKeyErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("No fué posible preparar el pedido en este momento, intentalo más tarde.")
        }
        .onAppear(){
            Task {
                // Get the API Key
                let success = await model.getStripeKey()
                    if success {
                        // Calculate Order
                        let orderCalculated = await calculateOrder()
                        if orderCalculated {
                            showPaymentView = true
                        }
                    } else {
                        print("No se pudo obtener la clave de Stripe")
                        showKeyErrorAlert = true
                    }
                }
        }
    }
    
    private func calculateOrder() async -> Bool {
        guard let url = URL(string: BaseBackendURL + "calculateOrder") else { return false }
        
        var request = URLRequest(url: url)
        let json: [String: Any] = [
            "selectedState": authViewModel.selectedState,
            "items": authViewModel.selectedProducts
        ]
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                showErrorAlert = true
                errorMessage = "Respuesta inválida del servidor."
                print("No se pudo obtener una respuesta del servidor")
                return false
            }

            // This error appears when a product of the cart is not available any more
            if httpResponse.statusCode == 405 {
                let decoded = try JSONDecoder().decode(ErrorResponse.self, from: data)
                showErrorAlert = true
                errorMessage = decoded.error
                print(decoded.error)
                // Delete the cart so the user can try to fill again
                authViewModel.deleteAllSelectedProducts()
                return false
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                do {
                    let decoded = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    showErrorAlert = true
                    errorMessage = decoded.error
                    print(decoded.error)
                } catch {
                    showErrorAlert = true
                    errorMessage = "Ocurrió un error inesperado: \(error.localizedDescription)"
                    print("Decoding error: \(error.localizedDescription)")
                }
                return false
            }

            let decoded = try JSONDecoder().decode(OrderResponse.self, from: data)
            
            print("Total productos:", decoded.productsTotal)
            print("Envío:", decoded.shipmentWithFees)
            print("Total orden:", decoded.orderTotal)
            print("Recompensas:", decoded.totalReward)
            
            // Update UI with the data
            productsTotal = decoded.productsTotal
            shipmentWithFees = decoded.shipmentWithFees
            orderTotal = decoded.orderTotal
            totalReward = decoded.totalReward
            
            return true
            
        } catch {
            showErrorAlert = true
            errorMessage = "Error al obtener o parsear la respuesta: \(error)"
            print("Error al obtener o parsear la respuesta:", error)
            return false
        }
    }

}

struct OrderResponse: Codable {
    let productsTotal: Double
    let shipmentWithFees: Double
    let orderTotal: Double
    let totalReward: Double
}

struct ErrorResponse: Codable {
    let error: String
}

#Preview {
    OrderSummary()
}
