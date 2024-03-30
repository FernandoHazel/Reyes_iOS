import Foundation
import SwiftUI

struct Product: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var price: Double
    var size: String
    var description: String
    var imgNames: [String]
    
    var images: [Image] {
        imgNames.map{Image($0)}
    }
}

