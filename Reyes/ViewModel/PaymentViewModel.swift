//
//  PaymentViewModel.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 04/04/25.
//
import Stripe

// Test Backend URL: https://moored-shimmer-atlasaurus.glitch.me
// Can find the project in https://glitch.com/edit/#!/moored-shimmer-atlasaurus?path=README.md%3A1%3A0

// This URL will be different in production
// HAY QUE MOVER ESTO A UNA VARIABLE DE ENTORNO
// HAY QUE TENER UNO PARA DEBUG Y OTRO PARA PROD
let BaseBackendURL = "http://127.0.0.1:1234/"
var stripeInitialized = false

import Foundation

func getStripeKey(){
    // Mover esto a un manejador especial de stripe
    print("\n - - - - - - - - - - PUBLISHABLE KEY - - - - - - - - - - \n")
    
    //Get the publishable kay from the server
    let configUrl = URL(string: BaseBackendURL + "config")
    var request = URLRequest(url: configUrl!)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200,
              let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let publishableKey = json["publishableKey"] as? String else {
            print("FAILED TO RETRIEVE PUBLISHABLE KEY FORM SERVER...")
            stripeInitialized = false
            return
        }
        print("PUBLISHABLE KEY: \(publishableKey)")
        StripeAPI.defaultPublishableKey = publishableKey
        stripeInitialized = true
    })
    task.resume()
}
