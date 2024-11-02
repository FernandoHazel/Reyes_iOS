//
//  UserInfo.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 31/10/24.
//

import SwiftUI
import FirebaseAnalytics

struct UserProfileView: View {
  @EnvironmentObject var viewModel: AuthenticationViewModel
  @Environment(\.dismiss) var dismiss
  @State var presentingConfirmationDialog = false

  private func deleteAccount() {
    Task {
      if await viewModel.deleteAccount() == true {
        dismiss()
      }
    }
  }

  private func signOut() {
    viewModel.signOut()
  }

  var body: some View {
    Form {
      Section {
        VStack {
          HStack {
            Spacer()
            Image(systemName: "person.fill")
              .resizable()
              .frame(width: 100 , height: 100)
              .aspectRatio(contentMode: .fit)
              .clipShape(Circle())
              .clipped()
              .padding(4)
              .overlay(Circle().stroke(Color.accentColor, lineWidth: 2))
            Spacer()
          }
            /*
          Button(action: {}) {
            Text("edit")
          }*/
        }
      }
      .listRowBackground(Color(UIColor.systemGroupedBackground))
      Section("Correo") {
        Text(viewModel.displayName)
      }
      Section {
        Button(role: .cancel, action: signOut) {
          HStack {
            Spacer()
            Text("Cerrar Sesión")
            Spacer()
          }
        }
      }
      Section {
        Button(role: .destructive, action: { presentingConfirmationDialog.toggle() }) {
          HStack {
            Spacer()
            Text("Borrar Cuenta")
            Spacer()
          }
        }
      }
    }
    .navigationTitle("Perfil")
    .navigationBarTitleDisplayMode(.inline)
    .analyticsScreen(name: "\(Self.self)")
    .confirmationDialog("Borrar tu cuenta es permanente y perderás las recompensas obtenidas ¿Estás segur@?",
                        isPresented: $presentingConfirmationDialog, titleVisibility: .visible) {
      Button("Borrar cuenta", role: .destructive, action: deleteAccount)
      Button("Cancelar", role: .cancel, action: { })
    }
  }
}

struct UserProfileView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationView {
      UserProfileView()
        .environmentObject(AuthenticationViewModel())
    }
  }
}
