//
//  Constants.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 5/27/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation

struct CellID {
    static let heroList = "heroListCell_ID"
    static let heroDetail = "heroDetail_ID"
}

struct Segue {
    static let heroSearch = "HeroSearch_Segue"
    static let heroDetail = "HeroDetail_Segue"
}

struct ViewControllerID {
    static let heroList = "HeroListTVC_ID"
    static let heroDetail = "HeroDetailTVC_ID"
    static let heroSearch = "HeroSearchTVC_ID"
}

// MARK: - Helper functions
func aprint(_ any: Any, function: String = #function, file: String = #file, line: Int = #line) {
    let fileName = file.lastPathComponent
    print("🍏\(any)- - - - - - - - - - - - - - - - - - - - - \(fileName!) || \(function) || \(line)")
}
