//
//  HeroRealm.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 6/2/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class HeroRealm: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var descriptionOfHero = ""
    @objc dynamic var thumbnailPath = ""
    @objc dynamic var thumbnailExtension = ""

    override class func primaryKey() -> String {
        return "id"
    }
    
    // MARK: - API
    func setHeroRealmObject(with hero: Hero) {
        self.id = String(describing: hero.id!)
        self.name = hero.name!
        self.descriptionOfHero = hero.description ?? ""
        self.thumbnailPath = hero.thumbnail!.path!
        self.thumbnailExtension = hero.thumbnail!.extension!
    }
}
