//
//  ParserHelper.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 5/26/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation

class ParserHelper {
    
    static let shared = ParserHelper()
    
    func parseHeroList(fromData data: Data, success: @escaping ([Hero]) -> Void, isParsingAFail: @escaping (Bool) -> Void) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let heroList = try decoder.decode([Hero].self, from: data)
            success(heroList)
        } catch let jsonErr {
            print("Failed to decode:", jsonErr)
            isParsingAFail(true)
        }
    }
    
//    func parseHeroDetail(fromData data: Data, success: @escaping ([Hero]) -> Void, isParsingAFail: @escaping (Bool) -> Void) {
//        
//    }
}
