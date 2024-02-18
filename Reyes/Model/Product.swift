import Foundation
import SwiftUI

struct Product: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var price: Int
    var size: String
    var description: String
    private var imgNames: [String]
    
    var images: [Image] {
        imgNames.map{Image($0)}
        //Image(imgName)
    }
}

