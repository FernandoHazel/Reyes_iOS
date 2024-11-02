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
    var adress1: String
    var adress2: String
    var selectedState: String
    var postalCode: String
    var city: String
    var rewards: Double
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
        adress1: "",
        adress2: "",
        selectedState: "",
        postalCode: "",
        city: "",
        rewards: 0.0
    )
  }
}
