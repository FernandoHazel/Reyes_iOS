import Foundation
import SwiftUI

struct Game: Hashable, Codable, Identifiable {
    var id: Int
    var date: String
    var team: String
    var hour: String
    var location: String
    var reyesRecord: String
    var teamRecord: String
    var teamImageName: String
}
