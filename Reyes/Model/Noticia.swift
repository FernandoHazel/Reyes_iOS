import Foundation
import SwiftUI

struct Noticia: Hashable, Codable, Identifiable, Comparable {
    var id: Int
    var mainImageName: String?
    var postLink: String?
    
    // this function is to order by id because firebase documents are messy
    static func < (lhs: Noticia, rhs: Noticia) -> Bool {
        return lhs.id < rhs.id
    }
}
