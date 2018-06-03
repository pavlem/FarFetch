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
    @objc dynamic var thumbnailURL = ""
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    
    // MARK: - API
    func setHeroRealm(with hero: Hero) {
        self.id = String(describing: hero.id!)
        self.name = hero.name!
        self.descriptionOfHero = hero.description!
        self.thumbnailURL = hero.thumbnail!.path! + "." + hero.thumbnail!.extension!
    }
    
    
//    convenience init(hero: Hero) {
//        self.init()
//
//        self.id = String(describing: hero.id!)
//        self.name = hero.name!
//        self.descriptionOfHero = hero.description!
//        self.thumbnailURL = hero.thumbnail!.path! + "." + hero.thumbnail!.extension!
//    }
    
//    required init() {
//        super.init()
//    }
//
//    required init(realm: RLMRealm, schema: RLMObjectSchema) {
//        fatalError("init(realm:schema:) has not been implemented")
//    }
//
//    required init(value: Any, schema: RLMSchema) {
//        fatalError("init(value:schema:) has not been implemented")
//    }
    
//    convenience init(myValue: String) {
//        self.init() //Please note this says 'self' and not 'super'
//        self.myValue = myValue
//    }
}
