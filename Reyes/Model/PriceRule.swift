//
//  PriceRule.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 24/03/25.
//

import Foundation

struct PriceRule: Hashable, Codable, Identifiable {
    let id: Int
    let iva: Double
    let myProfitPercentage: Double
    let states: [String: Double]
    let stripeFixedFee: Double
    let stripePercentage: Double
}
