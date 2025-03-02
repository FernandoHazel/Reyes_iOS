//
//  VersionUpdate.swift
//  Reyes
//
//  Created by Fernando Hazel Ascencio Baumgarten on 12/09/24.
//
import Firebase
import FirebaseRemoteConfig

struct VersionUpdateAlertConfig {
    let title: String?
    let message: String?
    let forcedButton: String?
    let optionalButton: String?
    let type: UpdateType
}

enum UpdateType {
    case forced
    case optional
}

class VersionUpdateManager {
    // MARK: - Properties
    static let appstoreId: String = "id6667093876"
    private let firebase: RemoteConfig = RemoteConfig.remoteConfig()
    
    func setDefaultsConfigValues(){
        let defaultValues = firebase.setDefaults(fromPlist: "remote_config_defaults")
        
        // Debug only code (erase or comment in production)
        /*
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        firebase.configSettings = settings
        */
    }
    
    func fetchRemoteConfigValues(){
        firebase.fetch { (status, error) -> Void in
          if status == .success {
            print("Config fetched!")
            self.firebase.activate { changed, error in
                
                if let error = error {
                    print("Error activating fetched remote config: \(error)")
                    return
                }

                // Got the data correctly
                if changed {
                    print("Remote config values were changed")
                }
                
                //self.debugRetrievedData()

                // Prompt update if needed
                print("is update needed? \(self.isUpdateNeeded().0) because \(self.currentVersion) vs forced:\(self.forcedVersion) optional:\(self.optionalVersion)")
            }
          } else {
            print("Config not fetched")
            print("Error: \(error?.localizedDescription ?? "No error available.")")
          }
        }
    }
    
    private func debugRetrievedData(){
        let jsonString = firebase["ios_version_update"].stringValue ?? ""
        print("Received JSON: \(jsonString)")
    }

    private var versionJSONData: Data {
        firebase["ios_version_update"].dataValue
    }

    private var currentVersion: [Substring] {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        return appVersion.split(separator: ".")
    }

    private var forcedVersion: [Substring] {
        guard let version = versionModel else { return [] }
        return version.forcedVersion?.split(separator: ".") ?? []
    }

    private var optionalVersion: [Substring] {
        guard let version = versionModel else { return [] }
        return version.optionalVersion?.split(separator: ".") ?? []
    }

    private var versionModel: VersionUpdate? {
        do {
            return try JSONDecoder().decode(VersionUpdate.self, from: versionJSONData)
        } catch {
            print(error)
            return nil
        }
    }

    private var dateFormatter: DateFormatter {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter
    }

    // MARK: - Methods
    func isUpdateNeeded() -> (Bool,  VersionUpdateAlertConfig?) {
        if isUpdateNeeded(by: .forced) {
            return (true, getAlertConfig(by: .forced))
        }

        if isUpdateNeeded(by: .optional) {
            return (true, getAlertConfig(by: .optional))
        }

        return (false, nil)
    }

    // MARK: - Private methods
    private func isUpdateNeeded(by type: UpdateType) -> Bool {
        let config = type == .forced ? forcedVersion : optionalVersion
        guard let current = date(from: currentVersion.first ?? ""),
              let currentBuild = Int(currentVersion.last ?? ""),
              let remote = date(from: config.first ?? ""),
              let remoteBuild = Int(config.last ?? "") else { return false }

        return remote > current || (remote == current && remoteBuild > currentBuild)
    }

    private func date(from substring: Substring) -> Date? {
        dateFormatter.date(from: String(substring))
    }

    private func getAlertConfig(by type: UpdateType) -> VersionUpdateAlertConfig {
        let isForced: Bool = type == .forced
        let title: String? = isForced ? versionModel?.forcedTitle : versionModel?.optionalTitle
        let message: String? = isForced ? versionModel?.forcedMessage : versionModel?.optionalMessage

        return VersionUpdateAlertConfig(title: title,
                                        message: message,
                                        forcedButton: versionModel?.forcedButton,
                                        optionalButton: versionModel?.optionalButton,
                                        type: type)
    }
}

