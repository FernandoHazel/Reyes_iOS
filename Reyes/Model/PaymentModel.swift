//
//  PaymentModel.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 06/10/24.

import Foundation
import Stripe

class PaymentModel: ObservableObject {
    @Published var paymentStatus: STPPaymentHandlerActionStatus?
    @Published var paymentIntentParams: STPPaymentIntentParams?
    @Published var lastPaymentError: NSError?
    var paymentMethodType: String?
    var currency: String?
    var email: String?
    var fullName: String?
    var shippingAdress: [String: Any]?
    var phone: String?
    var items: [[String: Any]]?
    var metadata: [String: Any]?
    
    
    func preparePaymentIntent(paymentMethodType: String, currency: String, email: String, fullName: String, shippingAdress: [String: Any], phone: String, items: [[String: Any]], metadata: [String: Any]){
        self.paymentMethodType = paymentMethodType
        self.currency = currency
        self.email = email
        self.fullName = fullName
        self.shippingAdress = shippingAdress
        self.phone = phone
        self.items = items
        self.metadata = metadata
        
        //Get the publishable kay from the server
        let url = URL(string: BaseBackendURL + "create-payment-intent")
        var request = URLRequest(url: url!)
        let json: [String: Any] = [
            "paymentMethodType": paymentMethodType,
            "currency": currency,
            "email": email,
            "fullName": fullName,
            "shipping": [
                "address": shippingAdress,
                "name": fullName,
                "phone": phone
            ],
            "items": items
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
            print("Created payment intent with client secret \(clientSecret)")
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
            preparePaymentIntent(paymentMethodType: self.paymentMethodType!, currency: self.currency!, email: self.email!, fullName: self.fullName!, shippingAdress: shippingAdress!, phone: self.phone!, items: self.items!, metadata: self.metadata!)
        }
    }
}
