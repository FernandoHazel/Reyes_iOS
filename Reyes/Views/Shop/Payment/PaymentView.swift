//
//  PaymentView.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 05/10/24.

import SwiftUI
import Stripe

struct PaymentView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [])
    private var cartProducts: FetchedResults<CartProduct>
    
    @ObservedObject var model = PaymentModel()
    @State var loading = false
    @State var paymentMethodParams: STPPaymentMethodParams?
    
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
        }.onAppear(){
            // Create the intent when the view appears
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
            let metadata = productNames()
            
            model.preparePaymentIntent(paymentMethodType: "card", currency: "mxn", email: email, fullName: fullName, shippingAddress: shippingAddress, phone: phone, items: items, metadata: metadata)
        }
        .onChange(of: model.paymentStatus) { paymentStatus in
                if paymentStatus == .succeeded {
                    purchase()
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
    
    private func calculateRewards() -> Double {
        var sum: Double = 0
        cartProducts.forEach { cartProduct in
            sum += cartProduct.reward * Double(cartProduct.quantitySelected)
        }
        return sum
    }
    private func purchase(){
        
        //1. Erase the cart products
        cartProducts.forEach { cartProduct in
            viewContext.delete(cartProduct)
        }
        
        //2. Add rewards
        authViewModel.rewards += calculateRewards()
        
        //3. Save context
        saveContext()
        
        
        //5. Update the member info
        authViewModel.saveMember()
        
        // Display a congrats alert
        // ...
        
        print("\n - - - - - - - - - - PURCHASE - - - - - - - - - - \n")
        print("PURCHASE SUCCEDED")
        print("\n - - - - - - - - - -  END - - - - - - - - - - \n")
        
    }
    
    private func saveContext(){
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Could't save context while adding cart product: \(error.localizedDescription)")
        }
    }
    
    private func items() -> [[String: Any]]{
        return cartProducts.map { $0.toDictionary() }
    }
    
    private func productNames() -> [String: Any] {
        var productDict: [String: Any] = [:]
        var keyCount = 1
        
        cartProducts.forEach { cartProduct in
            if let productName = cartProduct.name {
                productDict["item\(keyCount)"] = productName
                keyCount += 1
            }
        }
        
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
            PaymentView()
        }
    }
}
