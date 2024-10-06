//
//  PaymentView.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 05/10/24.

import SwiftUI
import Stripe

struct PaymentView: View {
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
            model.preparePaymentIntent(paymentMethodType: "card", currency: "mxn")
        }
        
        if let paymentStatus = model.paymentStatus {
            HStack {
                switch paymentStatus {
                case .succeeded:
                    // Go to the congrats view and add the rewards to the user
                    Text("Payment complete!")
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
}

#Preview {
    PaymentView()
}
