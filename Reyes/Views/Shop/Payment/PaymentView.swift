//
//  PaymentView.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 05/10/24.

import SwiftUI
import Stripe

struct PaymentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var vm: AppViewModel
    @ObservedObject var model = PaymentModel()
    @State var loading = false
    @State var paymentMethodParams: STPPaymentMethodParams?
    @State private var showThankYouAlert = false
    
    let totalReward: Double
    
    
    var body: some View {
        VStack{
            STPPaymentCardTextField.Representable(paymentMethodParams: $paymentMethodParams)
            if let paymentIntent = model.paymentIntentParams {
                Button(action: {
                    paymentIntent.paymentMethodParams = paymentMethodParams
                    loading = true
                }) {
                    Text("Comprar")
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
                }.paymentConfirmationSheet(isConfirmingPayment: $loading, paymentIntentParams: paymentIntent, onCompletion: model.onCompletion)
                    .disabled(loading)
                
            } else {
                Text("Procesando...")
            }
        }.onAppear() {
            Task {
                let email = authViewModel.email
                let fullName = "\(authViewModel.firstName) \(authViewModel.lastName)"
                let shippingAddress = [
                    "line1": authViewModel.address1,
                    "city": authViewModel.city,
                    "state": authViewModel.selectedState,
                    "postal_code": authViewModel.postalCode,
                    "country": "MX"
                ]
                let phone = authViewModel.phone
                let items = items()
                let selectedState = authViewModel.selectedState
                let metadata = productNames()
                
                model.preparePaymentIntent(paymentMethodType: "card", currency: "mxn", email: email, fullName: fullName, shippingAddress: shippingAddress, phone: phone, items: items, selectedState: selectedState, metadata: metadata)
            }
        }
        .alert("Gracias por tu compra", isPresented: $showThankYouAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("En breve recibirás un correo con los detalles del pedido.")
        }
        .onChange(of: model.paymentStatus) { paymentStatus in
                if paymentStatus == .succeeded {
                    Task {
                        await purchase()
                    }
                }
            }
        
        if let paymentStatus = model.paymentStatus {
            HStack {
                switch paymentStatus {
                case .succeeded:
                    Text("Orden completada!")
                        .foregroundColor(.green)
                case .canceled:
                    Text("Pago cancelado!")
                        .foregroundColor(.red)
                case .failed:
                    Text("Hubo un error en el pago...")
                        .foregroundColor(.red)
                @unknown default:
                    Text("Estatus de pago desconocido...")
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    private func purchase() async {
        
        //1. Erase the cart products
        authViewModel.deleteAllSelectedProducts()
        
        //2. Add rewards
        authViewModel.rewards += totalReward
        
        //3. Update the member info
        authViewModel.saveMember()
        
        //4. Display a congrats alert
        showThankYouAlert = true
        
        //5. Update availability in firestore
        await updateProductsAvailability()
        
        print("\n - - - - - - - - - - PURCHASE - - - - - - - - - - \n")
        print("PURCHASE SUCCEDED")
        print("\n - - - - - - - - - -  END - - - - - - - - - - \n")
        
    }
    
    private func items() -> [String: Int]{
        return authViewModel.selectedProducts
    }
    
    private func updateProductsAvailability() async {
        let products = vm.products
        
        for (key, quantity) in authViewModel.selectedProducts {
            let components = key.split(separator: "-")
            guard components.count == 2,
                  let id = Int(components[0]),
                  let size = components.last else {
                continue
            }
            
            if let product = products.first(where: { $0.id == id }) {
                authViewModel.updateProductAvailability(id: id, size: String(size), quantity: quantity)
            } else {
                print("Producto con ID \(id) no encontrado")
            }
        }
        //await vm.loadProducts() I tried to update the products after a purchase in the front
    }
    
    // This is used for metadata but is empty at the moment
    private func productNames() -> [String: Any] {
        let productDict: [String: Any] = [:]
        return productDict
    }
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        @State private var purchaseComplete = false
        
        var body: some View {
            PaymentView(totalReward: 10.0)
        }
    }
}
