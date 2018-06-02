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

struct ApiKey {
    static let `private` = "ea827ee77a1eed8ca8c771ec5fc5af5b9e84886b"
    static let `public` = "d4ac801ec659832e8eaa74553f0a2d35"
}

class NetworkHelper {
    static let shared = NetworkHelper()
    
    var characterListOffset = 0
    
    // MARK: - Constants
    let characterListOffsetIncrement = 20
    
    func fetchHeroList(success: @escaping (Data) -> Void, isHeroRetrivalFailed: @escaping (Bool) -> Void) {
        let heroListURLString = URLStrings.baseEndpoint + URLStrings.characters
        
        fetchData(forUrlString: heroListURLString, urlQueryItems: basicURLQueryItems(), success: { (data) in
            success(data)
        }) { (isRequestFailed) in
            isHeroRetrivalFailed(isRequestFailed)
        }
    }
    
    func fetchHero(_ name: String, success: @escaping (Data) -> Void, isHeroSearchFailed: @escaping (Bool) -> Void) {
        
        self.characterListOffset = 0
        let urlHeroNameItem = URLQueryItem(name: "name", value: name)
        let heroListURLString = URLStrings.baseEndpoint + URLStrings.characters
        
        var urlQueryItems = basicURLQueryItems()
        urlQueryItems.insert(urlHeroNameItem, at: 0)
        
        fetchData(forUrlString: heroListURLString, urlQueryItems: urlQueryItems, success: { (data) in
            success(data)
        }) { (isRequestFailed) in
            isHeroSearchFailed(isRequestFailed)
        }
    }

    func fetchHero(forId id: String, success: @escaping (Data) -> Void, isHeroSearchFailed: @escaping (Bool) -> Void) {
        
        self.characterListOffset = 0
        let heroListURLString = URLStrings.baseEndpoint + URLStrings.characters + "/" + id
        
        fetchData(forUrlString: heroListURLString, urlQueryItems: basicURLQueryItems(), success: { (data) in
            success(data)
        }) { (isRequestFailed) in
            isHeroSearchFailed(isRequestFailed)
        }
    }
    
    func fetchHeroStuff(forId id: String, success: @escaping ((dataComics: Data, dataEvents: Data, dataSeries: Data, dataStories: Data)) -> Void, isHeroSearchFailed: @escaping (Bool) -> Void) {
        
        self.characterListOffset = 0
        let baseUrlString = URLStrings.baseEndpoint + URLStrings.characters + "/" + id
        let heroListURLComics = baseUrlString + "/comics"
        let heroListURLEvents = baseUrlString + "/events"
        let heroListURLSeries = baseUrlString + "/series"
        let heroListURLStories = baseUrlString + "/stories"

        let basicURLQueryItems = self.basicURLQueryItems()
        
        fetchData(forUrlString: heroListURLComics, urlQueryItems: basicURLQueryItems, success: { (dataComics) in
            self.fetchData(forUrlString: heroListURLEvents, urlQueryItems: basicURLQueryItems, success: { (dataEvents) in
                
                self.fetchData(forUrlString: heroListURLSeries, urlQueryItems: basicURLQueryItems, success: { (dataSeries) in
                    
                    self.fetchData(forUrlString: heroListURLStories, urlQueryItems: basicURLQueryItems, success: { (dataStories) in
                        
                        //-------
                        success((dataComics: dataComics, dataEvents: dataEvents, dataSeries: dataSeries, dataStories: dataStories))
                        
//                        success((dataComics, dataEvents, dataSeries, dataStories))
                        //-------

                        
                    }, isRequestFailed: { (isRequestFailed) in
                        isHeroSearchFailed(isRequestFailed)
                    })
                    
                }, isRequestFailed: { (isRequestFailed) in
                    isHeroSearchFailed(isRequestFailed)
                })
                
            }, isRequestFailed: { (isRequestFailed) in
                isHeroSearchFailed(isRequestFailed)
            })

        }) { (isRequestFailed) in
            isHeroSearchFailed(isRequestFailed)
        }
    }
    
    func fetchData(forUrlString urlString: String, urlQueryItems: [URLQueryItem]?, success: @escaping (Data) -> Void, isRequestFailed: @escaping (Bool) -> Void) {

        guard var url = URL(string: urlString) else { return }
        
        if let urlQueryItemsLo = urlQueryItems {
            url = addQueryParams(url: url, newParams: urlQueryItemsLo)!
        }
        
        print(url)
        
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
            self.characterListOffset += self.characterListOffsetIncrement
            success(data)

            }.resume()
    }
    
    // MARK: - Helper
    func basicURLQueryItems() -> [URLQueryItem] {
        let ts = Date().timeIntervalSince1970.description
        let hash = (ts + ApiKey.private + ApiKey.public).md5()
        
        let urlApikeyItem = URLQueryItem(name: "apikey", value: ApiKey.public)
        let urlTimeStampItem = URLQueryItem(name: "ts", value: ts)
        let urlHashItem = URLQueryItem(name: "hash", value: hash)
        let urlOffsetItem = URLQueryItem(name: "offset", value: String(describing: characterListOffset))
        
        return [urlApikeyItem, urlTimeStampItem, urlHashItem, urlOffsetItem]
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
}
