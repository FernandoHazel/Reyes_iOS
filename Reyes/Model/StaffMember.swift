import Foundation
import SwiftUI

struct StaffMember: Hashable, Codable, Identifiable {
    let id: Int
    let profileImageName: String
    let name: String
    let rol: String
    let age: Int
    let about: [String]
    let imgNames: [String]
    
    var images: [Image] {
        imgNames.map{Image($0)}
    }
}
