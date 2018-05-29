//
//  NetworkHelper.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 5/26/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation
import CryptoSwift

struct URLStrings {
    static let baseEndpoint = "https://gateway.marvel.com"
    //    static let baseEndpoint = "http://developer.marvel.com"
    static let characters = "/v1/public/characters"
    static let heroListMOC = "http://api.letsbuildthatapp.com/jsondecodable/courses_snake_case"
}



var privateKey = "ea827ee77a1eed8ca8c771ec5fc5af5b9e84886b"
var publicKey = "d4ac801ec659832e8eaa74553f0a2d35"

class NetworkHelper {
    static let shared = NetworkHelper()
    
    var characterListOffset = 0
    
    // MARK: - Constants
    let characterListOffsetIncrement = 20
    
    func fetchHeroList(success: @escaping (Data) -> Void, isHeroRetrivalFailed: @escaping (Bool) -> Void) {
        let heroListURLString = URLStrings.baseEndpoint + URLStrings.characters
        
        fetchData(forUrlString: heroListURLString, success: { (data) in
            //            let dataAsString = String(data: data, encoding: String.Encoding.utf8)
            success(data)
        }) { (isRequestFailed) in
            isHeroRetrivalFailed(isRequestFailed)
        }
    }
    
    func fetchData(forUrlString urlString: String, success: @escaping (Data) -> Void, isRequestFailed: @escaping (Bool) -> Void) {
    
        let ts = Date().timeIntervalSince1970.description
        let hash = (ts + privateKey + publicKey).md5()
        
        
        guard let url = URL(string: urlString) else { return }
        
        let urlQ1 = URLQueryItem(name: "apikey", value: publicKey)
        let urlQ2 = URLQueryItem(name: "ts", value: ts)
        let urlQ3 = URLQueryItem(name: "hash", value: hash)
//        let urlQ4 = URLQueryItem(name: "limit", value: "10")
        let urlOffsetItem = URLQueryItem(name: "offset", value: String(describing: characterListOffset))
//        let urlQ5 = URLQueryItem(name: "name", value: "Spider-Man")


        let urlQueryItems = [urlQ1, urlQ2, urlQ3, urlOffsetItem]
        let urlWithQueryParameters = addQueryParams(url: url, newParams: urlQueryItems)
        
        URLSession.shared.dataTask(with: urlWithQueryParameters!) { (data, urlResponse, err) in
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
            self.characterListOffset += self.characterListOffsetIncrement
            success(data)

            }.resume()
    }
}


func addQueryParams(url: URL, newParams: [URLQueryItem]) -> URL? {
    let urlComponents = NSURLComponents.init(url: url, resolvingAgainstBaseURL: false)
    guard urlComponents != nil else { return nil; }
    if (urlComponents?.queryItems == nil) {
        urlComponents!.queryItems = [];
    }
    urlComponents!.queryItems!.append(contentsOf: newParams);
    return urlComponents?.url;
}
