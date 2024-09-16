//
//  VersionUpdate.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 12/09/24.
//

struct VersionUpdate: Codable {
    let forcedVersion: String?
    let forcedTitle: String?
    let forcedMessage: String?
    let forcedButton: String?
    let optionalVersion: String?
    let optionalTitle: String?
    let optionalMessage: String?
    let optionalButton: String?
}
