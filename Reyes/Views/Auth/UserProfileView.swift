//
//  UserInfo.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 31/10/24.
//

import SwiftUI
import FirebaseAnalytics

struct UserProfileView: View {
  @EnvironmentObject var authViewModel: AuthenticationViewModel
  @Environment(\.dismiss) var dismiss
  @State var presentingConfirmationDialog = false
    @State var addPassword = false
    
    // Get a reference to the managed object context from the environment.
    @Environment(\.managedObjectContext) private var viewContext
    
    // I have "users" but is supposed to exist only one
    @FetchRequest(sortDescriptors: [])
    private var users: FetchedResults<UserData>

  private func deleteAccount() {
    Task {
      if await authViewModel.deleteAccount() == true {
          deleteUserData()
        dismiss()
      }
    }
  }

  private func signOut() {
      deleteUserData()
      authViewModel.signOut()
  }
    
    private func deleteUserData() {

        // Check if user already exist
        if let existingUser = users.first {
            // Update existing user
            existingUser.firstName = ""
            existingUser.lastName = ""
            existingUser.email = ""
            existingUser.phone = ""
            existingUser.address1 = ""
            existingUser.address2 = ""
            existingUser.selectedState = ""
            existingUser.postalCode = ""
            existingUser.city = ""
            existingUser.rewards = 0
        }
        // Save changes
        saveContext()
    }
    
    private func saveContext(){
        do{
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Could't save context while adding user data: \(error.localizedDescription)")
        }
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
        
        Section(header: Text("Usuario")) {
            VStack(alignment: .leading) {
                Text("Nombre")
                    .font(.caption)
                Text("\(authViewModel.firstName) \(authViewModel.lastName)")
            }
            VStack(alignment: .leading) {
                Text("Correo")
                    .font(.caption)
                Text(authViewModel.email)
            }
            VStack(alignment: .leading) {
                Text("Dirección de envío")
                    .font(.caption)
                Text("\(authViewModel.address1), \(authViewModel.city), \(authViewModel.selectedState), \(authViewModel.postalCode)")
            }
            VStack(alignment: .leading) {
                Text("Proveedor")
                    .font(.caption)
                Text(authViewModel.user?.providerData.first?.providerID ?? "(Desconocido)")
            }
        }
        
      Section {
          // Don't let the user close session if the account is anonymous because he can loose the rewards
          if (authViewModel.user?.providerData.first?.providerID != nil){
              Button(role: .cancel, action: signOut) {
                HStack {
                  Spacer()
                  Text("Cerrar Sesión")
                  Spacer()
                }
              }
          }
          if (authViewModel.user?.providerData.first?.providerID == nil){
              Button(role: .none, action: { addPassword.toggle() }) {
                HStack {
                  Spacer()
                  Text("Añadir una contraseña")
                  Spacer()
                }
              }
          }
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
    .sheet(isPresented: $addPassword) {
        ScrollView{
            SignupView()
        }
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
