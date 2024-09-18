//
//  UserInfo.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 18/09/24.
//

import SwiftUI

struct UserInfo: View {
    var body: some View {
        Text("User Info")
    }
}

struct UserInfo_Previews: PreviewProvider {
    static var previews: some View {
        // Contenedor para el preview
        PreviewWrapper()
    }

    struct PreviewWrapper: View {

        var body: some View {
            UserInfo()
        }
    }
}
