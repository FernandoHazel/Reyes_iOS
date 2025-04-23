//
//  UserInfo.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 31/10/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

enum AuthenticationState {
  case unauthenticated
  case authenticating
  case authenticated
}

enum AuthenticationFlow {
  case login
  case signUp
}

@MainActor
class AuthenticationViewModel: ObservableObject {
  @Published var password = ""
  @Published var confirmPassword = ""

  @Published var flow: AuthenticationFlow = .login

  @Published var isValid  = false
  @Published var authenticationState: AuthenticationState = .unauthenticated
  @Published var errorMessage = ""
  @Published var user: User?
  @Published var displayName = ""
    
    @Published var member = Member.empty
    private var db = Firestore.firestore()
    
    //Member fields
    @Published var userId = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var address1 = ""
    @Published var address2 = ""
    @Published var postalCode = ""
    @Published var city = ""
    @Published var rewards = 0.0
    @Published var selectedState = "Jalisco"
    @Published var selectedProducts: [String: Int] = [:]

  init() {
    registerAuthStateHandler()
      
      if let user = Auth.auth().currentUser {
              self.user = user
              fetchMember()
          }

    $flow
      .combineLatest($email, $password, $confirmPassword)
      .map { flow, email, password, confirmPassword in
        flow == .login
          ? !(email.isEmpty || password.isEmpty)
          : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty || password != confirmPassword)
      }
      .assign(to: &$isValid)
    
  }

  private var authStateHandler: AuthStateDidChangeListenerHandle?

  func registerAuthStateHandler() {
    if authStateHandler == nil {
      authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
        self.user = user
        self.authenticationState = user == nil ? .unauthenticated : .authenticated
        self.displayName = user?.email ?? ""
          
          // Llamamos a fetchMember si hay un usuario autenticado.
          if user != nil {
              self.fetchMember()
          } else {
              self.closeOrDeleteAccount()
          }
      }
    }
  }

  func switchFlow() {
    flow = flow == .login ? .signUp : .login
    errorMessage = ""
  }

  private func wait() async {
    do {
      print("Wait")
      try await Task.sleep(nanoseconds: 1_000_000_000)
      print("Done")
    }
    catch {
      print(error.localizedDescription)
    }
  }

  func reset() {
    flow = .login
    email = ""
    password = ""
    confirmPassword = ""
  }
}

// MARK: - Email and Password Authentication

extension AuthenticationViewModel {
    
    func editAccount() {
        if let user = Auth.auth().currentUser {
            print("Someone is signed in")
            saveMember()
            print(user.uid)
        }
    }
    
    func singUpOrLinkAccount() async -> Bool {
        return await user != nil ? linkWithEmailPassword() : signUpWithEmailPassword()
    }
    
    func linkWithEmailPassword() async -> Bool {
      authenticationState = .authenticating
      do {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        if let user {
          let result = try await user.link(with: credential)
          self.user = result.user
          authenticationState = .authenticated
          return true
        }
        else {
          fatalError("No user was signed in. This should not happen.")
        }
      }
      catch  {
        print(error)
        errorMessage = error.localizedDescription
        authenticationState = .unauthenticated
        return false
      }
    }

  func signUpWithEmailPassword() async -> Bool {
    authenticationState = .authenticating
    do  {
      try await Auth.auth().createUser(withEmail: email, password: password)
        saveMember()
      return true
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
      authenticationState = .unauthenticated
      return false
    }
  }
    
    func signInWithEmailPassword() async -> Bool {
      authenticationState = .authenticating
      do {
        try await Auth.auth().signIn(withEmail: self.email, password: self.password)
          fetchMember()
        return true
      }
      catch  {
        print(error)
        errorMessage = error.localizedDescription
        authenticationState = .unauthenticated
        return false
      }
    }

  func signOut() {
    do {
      try Auth.auth().signOut()
        closeOrDeleteAccount()
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
    }
  }

  func deleteAccount() async -> Bool {
    do {
      try await user?.delete()
        closeOrDeleteAccount()
        // ONLY DELETE MEMBER IN DELET ACCOUNT CASE
        // member is the db document of the user
        deleteMember()
      return true
    }
    catch {
      errorMessage = error.localizedDescription
      return false
    }
  }
    
    func subscribeMember() {
      guard let uid = user?.uid else { return }

      db.collection("Members")
        .whereField("userId", isEqualTo: uid)
        .limit(to: 1)
        .addSnapshotListener { querySnapshot, error in
        do {
          if let member = try querySnapshot?.documents.first?.data(as: Member.self) {
              print("Assigning Member data to: \(member.firstName) \(member.lastName)")
              self.member = member
          }
        }
        catch {
          print(error.localizedDescription)
        }
      }
    }

    func fetchMember() {
      guard let uid = user?.uid else { return }

      Task {
        do {
          let querySnapshot = try await db.collection("Members").whereField("userId", isEqualTo: uid).limit(to: 1).getDocuments()
          if !querySnapshot.isEmpty {
            if let member = try querySnapshot.documents.first?.data(as: Member.self) {
              await MainActor.run {
                  print("Assigning Member data to: \(member.firstName) \(member.lastName)")
                  self.member = member
                  updateLocalData()
              }
            }
          }
        }
        catch {
          print(error.localizedDescription)
        }
      }
    }

    func saveMember() {
        UpdateDBData()
      do {
          if let documentId = member.id {
              try db.collection("Members").document(documentId).setData(from: member)
        }
        else {
          let documentReference = try db.collection("Members").addDocument(from: member)
          print("Member created in db \(member)")
          member.id = documentReference.documentID
        }
      }
      catch {
        print(error.localizedDescription)
      }
    }
    
    func deleteMember() {
        if let documentId = member.id {
            db.collection("Members").document(documentId).delete { error in
                if let error = error {
                    print("Error deleting member: \(error.localizedDescription)")
                } else {
                    print("Member deleted from db: \(self.member)")
                }
            }
        } else {
            print("Couldn't delete member: \(member)")
        }
    }
    
    func sendPasswordReset(completion: @escaping (String) -> Void) {
        guard !email.isEmpty else {
            completion("Escribe un correo")
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion("Error: \(error.localizedDescription)")
            } else {
                completion("Se envió un enlace de recuperación a \(self.email).")
            }
        }
    }
    
    func addSelectedProduct(
        productId: String,
        size: String,
        quantity: Int
    ){
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error obteniendo el usuario al agregar un producto")
            return
        }
        
        db.collection("Members")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                
                if let error = error {
                    print("Error buscando al usuario \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No se encontraron documentos para el usuario")
                    return
                }
                
                for document in documents {
                    
                    let userRef = self.db.collection("Members").document(document.documentID)
                    
                    // Create idAndSize key
                    let key = "\(productId)-\(size)"
                    
                    // Create a copy of the dictionary to update the data
                    var updatedSelectedProducts = self.selectedProducts
                    updatedSelectedProducts[key] = (updatedSelectedProducts[key] ?? 0) + quantity
                    
                    // Update in firestore
                    userRef.updateData([
                        "selectedProducts.\(key)": updatedSelectedProducts[key] ?? 0
                    ]) { [weak self] error in
                        guard let self = self else { return }
                        
                        if let error = error {
                            print("Error al añadir producto: \(error.localizedDescription)")
                        } else {
                            // Actualizar UI State
                            self.selectedProducts = updatedSelectedProducts
                            print("Producto añadido con talla")
                        }
                    }
                }
            }
    }
    
    func deleteSelectedProduct(idAndSize: String) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: No se pudo obtener el userId")
            return
        }

        db.collection("Members")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error al buscar usuario: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No se encontraron documentos para el usuario")
                    return
                }

                for document in documents {
                    let userRef = self.db.collection("Members").document(document.documentID)

                    // Crear una copia sin el producto eliminado
                    var updatedSelectedProducts = self.selectedProducts
                    updatedSelectedProducts.removeValue(forKey: idAndSize)

                    // Eliminar de Firestore
                    userRef.updateData([
                        "selectedProducts.\(idAndSize)": FieldValue.delete()
                    ]) { [weak self] error in
                        guard let self = self else { return }
                        
                        if let error = error {
                            print("Error al eliminar producto: \(error.localizedDescription)")
                        } else {
                            // Actualizar el estado UI
                            self.selectedProducts = updatedSelectedProducts
                            print("Producto eliminado correctamente")
                        }
                    }
                }
            }
    }
    
    func updateProductAvailability(id: Int, size: String, quantity: Int) {
        db.collection("Products")
            .whereField("id", isEqualTo: id)
            .getDocuments { snapshot, error in
                guard let document = snapshot?.documents.first, error == nil else {
                    print("❌ Producto con ID \(id) no encontrado.")
                    return
                }
                
                let docRef = self.db.collection("Products").document(document.documentID)
                let availability = document.data()["availability"] as? [String: Int] ?? [:]
                let current = availability[size] ?? 0
                let newValue = max(current - quantity, 0) // evita valores negativos
                
                let updateKey = "availability.\(size)"
                docRef.updateData([updateKey: newValue]) { error in
                    if let error = error {
                        print("❌ Error al actualizar disponibilidad: \(error.localizedDescription)")
                    } else {
                        print("✅ Actualizada talla \(size) de \(current) a \(newValue)")
                    }
                }
            }
    }
    
    func deleteAllSelectedProducts() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("Error: No se pudo obtener el userId")
            return
        }

        db.collection("Members")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error al buscar usuario: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No se encontraron documentos para el usuario")
                    return
                }

                for document in documents {
                    let userRef = self.db.collection("Members").document(document.documentID)
                    let data = document.data()
                    
                    if let selectedProducts = data["selectedProducts"] as? [String: Int] {
                        var updates: [String: Any] = [:]

                        for key in selectedProducts.keys {
                            updates["selectedProducts.\(key)"] = FieldValue.delete()
                        }

                        userRef.updateData(updates) { [weak self] error in
                            guard let self = self else { return }
                            
                            if let error = error {
                                print("Error al eliminar productos: \(error.localizedDescription)")
                            } else {
                                self.selectedProducts = [:]
                                print("Todos los productos seleccionados fueron eliminados")
                            }
                        }
                    } else {
                        print("No hay productos seleccionados para eliminar")
                    }
                }
            }
    }

    // use the local data to fill the member instance before uptading in the db
    func UpdateDBData() {
        member.userId = user?.uid ?? ""
        member.firstName = firstName
        member.lastName = lastName
        member.email = email
        member.phone = phone
        member.address1 = address1
        member.address2 = address2
        member.postalCode = postalCode
        member.city = city
        member.rewards = rewards
        member.selectedState = selectedState
        member.selectedProducts = selectedProducts
    }
    
    func updateLocalData() {
         userId = member.userId
         firstName = member.firstName
         lastName = member.lastName
         email = member.email
         phone = member.phone
         address1 = member.address1
         address2 = member.address2
         postalCode = member.postalCode
         city = member.city
         rewards = member.rewards
        selectedState = member.selectedState
        selectedProducts = member.selectedProducts
    }
    
    func closeOrDeleteAccount() {
         userId = ""
         firstName = ""
         lastName = ""
         email = ""
         phone = ""
         address1 = ""
         address2 = ""
         postalCode = ""
         city = ""
        rewards = 0.0
        selectedState = ""
        selectedProducts = [:]
    }
}
