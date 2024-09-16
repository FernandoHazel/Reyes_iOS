import Foundation
import SwiftUI

struct Product: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var price: Double
    var description: String
    var imgNames: [String]
    var discount: Double
    var availability: [String: Int]
    var reward: Double
    
    var images: [Image] {
        imgNames.map{Image($0)}
    }
}

