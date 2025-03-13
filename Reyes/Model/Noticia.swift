import Foundation
import SwiftUI

struct Noticia: Hashable, Codable, Identifiable {
    var id: Int
    var title: String?
    var mainImageName: String?
    var postLink: String?
}
