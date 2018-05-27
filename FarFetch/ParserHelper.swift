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
            let response = try decoder.decode(MarvelServerResponse.self, from: data)
            if let heroList = response.data?.results {
                success(heroList)
            } else {
                isParsingAFail(true)
            }
        } catch let jsonErr {
            print("Failed to decode:", jsonErr)
            isParsingAFail(true)
        }
    }
    
//    func parseHeroDetail(fromData data: Data, success: @escaping ([Hero]) -> Void, isParsingAFail: @escaping (Bool) -> Void) {
//        
//    }
}
