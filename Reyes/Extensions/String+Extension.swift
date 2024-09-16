//
//  String+Extension.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 15/09/24.
//

import Foundation
import SwiftUI
import UIKit

extension String {
    func openAppStore() {
        if let url = URL(string: "https://apps.apple.com/app/id\(self)"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
