//
//  PaymentView.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 05/10/24.

import SwiftUI
import Stripe

struct PaymentView: View {
    // Get a reference to the managed object context from the environment.
    @Environment(\.managedObjectContext) private var viewContext
    
    // I have "users" but is supposed to exist only one
    @FetchRequest(sortDescriptors: [])
    private var users: FetchedResults<UserData>
    
    @FetchRequest(sortDescriptors: [])
    private var cartProducts: FetchedResults<CartProduct>
    
    @ObservedObject var model = PaymentModel()
    @State var loading = false
    @State var paymentMethodParams: STPPaymentMethodParams?
    @Binding var purchaseCompleted: Bool
    
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
            model.preparePaymentIntent(paymentMethodType: "card", currency: "mxn")
            purchaseCompleted = false
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
    
    private func calculateRewards() -> Double{
        var sum: Double = 0
        cartProducts.forEach { cartProduct in
            sum += cartProduct.reward * Double(cartProduct.quantitySelected)
        }
        return sum
    }
    private func purchase(){
        //1. Generate the order in firebase (also in stripe)
        
        //2. Erase the cart products
        cartProducts.forEach { cartProduct in
            viewContext.delete(cartProduct)
        }
        
        //3. Update the remote inventory
        
        //4. Add rewards
        users.first!.rewards += calculateRewards()
        
        //6. Save context
        saveContext()
        
        //7. Navigate to congrats view
        purchaseCompleted = true
        
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
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
    
    struct PreviewWrapper: View {
        @State private var purchaseComplete = false
        
        var body: some View {
            PaymentView(purchaseCompleted: $purchaseComplete)
        }
    }
}
