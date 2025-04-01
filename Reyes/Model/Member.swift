//
//  User.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 02/11/24.
//

import Foundation
import FirebaseFirestore

struct Member: Codable, Identifiable {
  @DocumentID var id: String?
  var userId: String
    var firstName: String
    var lastName: String
    var email: String
    var phone: String
    var address1: String
    var address2: String
    var selectedState: String
    var postalCode: String
    var city: String
    var rewards: Double
    var selectedProducts: [String: Int] = [:]
}

extension Member {
    // Create an empty instance of member
  static var empty: Member {
    Member(
        userId: "",
        firstName: "",
        lastName: "",
        email: "",
        phone: "",
        address1: "",
        address2: "",
        selectedState: "",
        postalCode: "",
        city: "",
        rewards: 0.0,
        selectedProducts: [
            "8-L" : 2,
            "8-M" : 2
            
        ]
    )
  }
}
