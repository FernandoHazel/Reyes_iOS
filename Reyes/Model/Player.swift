import Foundation
import SwiftUI

struct Player: Hashable, Codable, Identifiable {
    let id: Int
    let number: Int
    let profileImageName: String
    let name: String
    let pos: String
    let weight: Double
    let height: Double
    let age: Int
    let procedence: String
    let lfa: Int
    let status: String
    let group: String
    let about: [String]
    let imgNames: [String]
    
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

