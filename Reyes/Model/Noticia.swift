import Foundation
import SwiftUI

struct Noticia: Hashable, Codable, Identifiable {
    var id: Int
    var title: String
    var subTitle: String
    var mainImageName: String
    var by: String
    var description: String
    var imgNames: [String]
    
    var images: [Image] {
        imgNames.map{Image($0)}
    }
}
