//
//  PaymentModel.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 06/10/24.

// Remember to prevent user to buy if stripeInitialized = false

import Foundation
import Stripe

class PaymentModel: ObservableObject {
    @Published var paymentStatus: STPPaymentHandlerActionStatus?
    @Published var paymentIntentParams: STPPaymentIntentParams?
    @Published var lastPaymentError: NSError?
    var paymentMethodType: String?
    var currency: String?
    
    func preparePaymentIntent(paymentMethodType: String, currency: String){
        self.paymentMethodType = paymentMethodType
        self.currency = currency
        
        //Get the publishable kay from the server
        let url = URL(string: BaseBackendURL + "create-payment-intent")
        var request = URLRequest(url: url!)
        let json: [String: Any] = [
            "paymentMethodType": paymentMethodType,
            "currency": currency
        ]
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let clientSecret = json["clientSecret"] as? String else {
                let message = error?.localizedDescription ?? "Failed to decode response form server..."
                print(message)
                return
            }
            print("Created payment intent")
            DispatchQueue.main.async {
                self.paymentIntentParams = STPPaymentIntentParams(clientSecret: clientSecret)
            }
        })
        task.resume()
    }
    
    func onCompletion(status: STPPaymentHandlerActionStatus, paymentIntent: STPPaymentIntent?, error: NSError?){
        self.paymentStatus = status
        self.lastPaymentError = error
        
        if status == .succeeded {
            self.paymentIntentParams = nil
            preparePaymentIntent(paymentMethodType: self.paymentMethodType!, currency: self.currency!)
        }
    }
}
