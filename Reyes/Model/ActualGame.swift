import Foundation
import SwiftUI

struct ActualGame: Hashable, Codable, Identifiable {
    var id: Int
    var gameId: Int
    var ticketsLink: String?
    var gameLink: String?
}
