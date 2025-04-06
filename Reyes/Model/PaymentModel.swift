//
//  PaymentModel.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 06/10/24.
// Test Backend URL: https://moored-shimmer-atlasaurus.glitch.me
// Can find the project in https://glitch.com/edit/#!/moored-shimmer-atlasaurus?path=README.md%3A1%3A0

import Foundation
import Stripe

// This URL will be different in production
// HAY QUE MOVER ESTO A UNA VARIABLE DE ENTORNO
// HAY QUE TENER UNO PARA DEBUG Y OTRO PARA PROD
let BaseBackendURL = "http://127.0.0.1:1234/"
var stripeInitialized = false

class PaymentModel: ObservableObject {
    @Published var paymentStatus: STPPaymentHandlerActionStatus?
    @Published var paymentIntentParams: STPPaymentIntentParams?
    @Published var lastPaymentError: NSError?
    var paymentMethodType: String?
    var currency: String?
    var email: String?
    var fullName: String?
    var shippingAddress: [String: Any]?
    var phone: String?
    var items: [String: Int] = [:]
    var selectedState: String = ""
    var metadata: [String: Any]?
    
    func getStripeKey() async -> Bool {
        print("\n - - - - - - - - - - PUBLISHABLE KEY - - - - - - - - - - \n")
        
        guard let configUrl = URL(string: BaseBackendURL + "config") else {
            print("URL inválida")
            return false
        }
        
        var request = URLRequest(url: configUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Respuesta inválida del servidor")
                return false
            }
            
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let publishableKey = json["publishableKey"] as? String else {
                print("No se pudo parsear la publishableKey")
                return false
            }
            
            print("PUBLISHABLE KEY: \(publishableKey)")
            StripeAPI.defaultPublishableKey = publishableKey
            return true
        } catch {
            print("Error al obtener publishable key: \(error)")
            return false
        }
    }
    
    func preparePaymentIntent(paymentMethodType: String, currency: String, email: String, fullName: String, shippingAddress: [String: Any], phone: String, items: [String: Int], selectedState: String, metadata: [String: Any]){
        self.paymentMethodType = paymentMethodType
        self.currency = currency
        self.email = email
        self.fullName = fullName
        self.shippingAddress = shippingAddress
        self.phone = phone
        self.items = items
        self.selectedState = selectedState
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
                "address": shippingAddress,
                "name": fullName,
                "phone": phone
            ],
            "items": items,
            "selectedState": selectedState
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
            preparePaymentIntent(paymentMethodType: self.paymentMethodType!, currency: self.currency!, email: self.email!, fullName: self.fullName!, shippingAddress: shippingAddress!, phone: self.phone!, items: self.items, selectedState: self.selectedState, metadata: self.metadata!)
        }
    }
}
