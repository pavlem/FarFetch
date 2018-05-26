//
//  NetworkHelper.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 5/26/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation

struct URLStrings {
    static let heroList = "http://api.letsbuildthatapp.com/jsondecodable/courses_snake_case"

}


class NetworkHelper {
    static let shared = NetworkHelper()
    
    func fetchHeroList(success: @escaping (Data) -> Void, isHeroRetrivalFailed: @escaping (Bool) -> Void) {
        fetchData(forUrlString: URLStrings.heroList, success: { (data) in
            success(data)
        }) { (isRequestFailed) in
            isHeroRetrivalFailed(isRequestFailed)
        }
    }
    
    func fetchData(forUrlString urlString: String, success: @escaping (Data) -> Void, isRequestFailed: @escaping (Bool) -> Void) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, urlResponse, err) in
 
            if let httpResponse = urlResponse as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    isRequestFailed(true)
                    return
                }
            }
            
            if let _ = err {
                isRequestFailed(true)
                return
            }
            
            guard let data = data else { return }
            success(data)
            }.resume()
    }
}
