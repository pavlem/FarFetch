//
//  DbHelper.swift
//  Opi
//
//  Created by Pavle Mijatovic on 7/27/17.
//  Copyright © 2017 Carnegie Technologies. All rights reserved.
//

import Foundation
import RealmSwift

var realm = try! Realm()

let realmFolderName = "realmDB"
let realmFileName = "farFetch.realm"
let schemaVersionNumberToDelete = 3

class DbHelper {
    
    static let shared = DbHelper()
    
    // MARK: - Properties
    // MARK: Writing Objects
    func deleteAllDBObjects() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func add(object: Object) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch let err {
            aprint(err)
        }
    }
    
    func update(object: Object) {
        do {
            try realm.write {
                realm.add(object, update: true)
            }
        } catch let err {
            aprint(err)
        }
    }
    
    func delete(object: Object) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch let err {
            aprint(err)
        }
    }
    
    func startRealmDBInstance() {
        do {
            realm = try Realm()
        } catch let err {
            aprint(err)
        }
    }
}

// MARK: - Heroes
extension DbHelper {

    func getFavoriteHeores() -> [HeroRealm]? {
        return Array(realm.objects(HeroRealm.self))
    }
    
    func getPersistedHeroes() -> [Hero] {
        let heroesPersisted = DbHelper.shared.getFavoriteHeores()
        
        var heroListPersisted = [Hero]()
        for heroP in heroesPersisted! {
            let thumbnail = Thumbnail(path: heroP.thumbnailPath, extension: heroP.thumbnailExtension)
            
            let hero = Hero(id: Int(heroP.id), name: heroP.name, description: nil, modified: nil, thumbnail: thumbnail, resourceURI: nil, title: nil, comics: nil, series: nil, stories: nil, events: nil)
            heroListPersisted.append(hero)
        }
        
        return heroListPersisted
    }
}


//extension DbHelper {
//    func getHeroes()
//
//
//    func getSettings() -> Settings? {
//        return realm.object(ofType: Settings.self, forPrimaryKey: settingsKey)
//    }
//
//    func persistSettings(name: String?) {
//
//        let settings = Settings(value: realm.object(ofType: Settings.self, forPrimaryKey: settingsKey) ?? Settings())
//        
//        settings.id = settingsKey
//        settings.name = name ?? ""
//
//        if realm.objects(Settings.self).count > 0 {
//            update(object: settings)
//        } else {
//            add(object: settings)
//        }
//    }
//
//    func persist(settings: Settings) {
//        if realm.objects(Settings.self).count > 0 {
//            update(object: settings)
//        } else {
//            add(object: settings)
//        }
//    }
//
//    func set(authorizationToken: String) {
//        guard let settings = getSettings() else { return }
//        do {
//            try realm.write {
//                settings.authorisationToken = authorizationToken
//            }
//        } catch let err {
//            print(err)
//        }
//    }
//
//    func set(qrDisplayPinCode: String) {
//        guard let settings = getSettings() else { return }
//        do {
//            try realm.write {
//                settings.qrDisplayPinCode = qrDisplayPinCode
//            }
//        } catch let err {
//            print(err)
//        }
//    }
//
//    func set(systemUserName: String) {
//        guard let settings = getSettings() else { return }
//        do {
//            try realm.write {
//                settings.systemUserName = systemUserName
//            }
//        } catch let err {
//            print(err)
//        }
//    }
//
//    func set(pushToken: String) {
//        guard let settings = getSettings() else { return }
//        do {
//            try realm.write {
//                settings.pushToken = pushToken
//            }
//        } catch let err {
//            aprint(err)
//        }
//    }
//
//    func set(isDisplayQRScreenLocked: Bool) {
//        guard let settings = getSettings() else { return }
//        do {
//            try realm.write {
//                settings.isDisplayQRScreenLocked = isDisplayQRScreenLocked
//            }
//        } catch let err {
//            aprint(err)
//        }
//    }
//
//    func save(loginResponse: LoginResponse) {
//        guard let settings = getSettings() else { return }
//        do {
//            try realm.write {
//                settings.systemUserUID = loginResponse.uid
//                settings.systemUserName = loginResponse.systemUserName
//                settings.emailAddress = loginResponse.emailAddress
//                settings.systemRoleUID = loginResponse.systemRoleUID ?? ""
//                settings.permissions = loginResponse.permissions
//                settings.partnerUID = loginResponse.partnerUID
//                settings.isCarrier = loginResponse.isCarrier
//                settings.username = loginResponse.username
//            }
//        } catch let err {
//            print(err)
//        }
//    }
//
//    // MARK: - Settings getters
//    var isDisplayQRScreenLocked: Bool {
//        guard let settings = getSettings() else { return false }
//        return settings.isDisplayQRScreenLocked
//    }
//}
//


// MARK: - Project related
extension DbHelper {
    func setRealmConfig() {
        var config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { _, oldSchemaVersion in

                if oldSchemaVersion < 1 {
                    print("oldSchemaVersion: \(oldSchemaVersion)")
                    // Perform 1 Migration Block
                }
        })

        config.deleteRealmIfMigrationNeeded = config.schemaVersion < UInt64(schemaVersionNumberToDelete)
        config.fileURL = URL(string: realmDBFileLocation(fileName: realmFileName))
        Realm.Configuration.defaultConfiguration = config
    }

    func realmDBFileLocation(fileName: String) -> String {
        let realmDBFolderPath = FileManager.documentsDir() + "/" + realmFolderName

        if !FileHelper.fileExists(atPath: realmDBFolderPath) {
            FileHelper.createDirectoryAtPath(realmDBFolderPath)
        }
        _ = FileHelper.skipCloudBackup(path: realmDBFolderPath)
        return FileManager.documentsDir() + "/\(realmFolderName)/\(fileName)"
    }
}
