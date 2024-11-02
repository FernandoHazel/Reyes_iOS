//
//  UserInfo.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 31/10/24.
//

import Foundation
import FirebaseAuth

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
  @Published var email = ""
  @Published var password = ""
  @Published var confirmPassword = ""

  @Published var flow: AuthenticationFlow = .login

  @Published var isValid  = false
  @Published var authenticationState: AuthenticationState = .unauthenticated
  @Published var errorMessage = ""
  @Published var user: User?
  @Published var displayName = ""

  init() {
    registerAuthStateHandler()

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
    func anonymousSingIn() {
      if Auth.auth().currentUser == nil {
        print("Nobody is signed in. Trying to sign in anonymously.")
        Task {
              do {
                try await Auth.auth().signInAnonymously()
                errorMessage = ""
              }
          catch {
            print("Error while signing in anonymously: "+error.localizedDescription)
            errorMessage = error.localizedDescription
          }
        }
      }
      else {
        print("Someone is signed in")
        if let user = Auth.auth().currentUser {
          print(user.uid)
        }
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
    }
    catch {
      print(error)
      errorMessage = error.localizedDescription
    }
  }

  func deleteAccount() async -> Bool {
    do {
      try await user?.delete()
      return true
    }
    catch {
      errorMessage = error.localizedDescription
      return false
    }
  }
}
