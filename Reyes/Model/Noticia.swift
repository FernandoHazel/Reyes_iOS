import Foundation
import SwiftUI

struct Noticia: Hashable, Codable, Identifiable {
    var id: Int
    var title: String
    var subTitle: String
    var mainImageName: String
    var by: String
    var date: String
    var paragraphs: [String]
}
