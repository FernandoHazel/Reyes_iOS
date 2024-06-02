import Foundation
import SwiftUI

struct RewardInstruction: Hashable, Codable, Identifiable {
    var id: Int
    var image: String
    var title: String
    var text: String
}
