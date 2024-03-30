import Foundation
import SwiftUI

struct Player: Hashable, Codable, Identifiable {
    var id: Int
    var number: Int
    var profileImageName: String
    var name: String
    var pos: String
    var weight: Double
    var height: Double
    var age: Int
    var procedence: String
    var lfa: Int
    var status: String
    var group: String
    var about: String
    var imgNames: [String]
    
    var images: [Image] {
        imgNames.map{Image($0)}
    }
}

enum Status: String, CaseIterable {
    case Activo
    case Lesionado
    case Expulsado
    case Descanso
}

enum GroupTeam: String, CaseIterable {
    case Ofensiva
    case Defensiva
    case Especialista
}

