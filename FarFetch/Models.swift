//
//  Models.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 6/1/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation

struct MarvelServerResponse: Decodable {
    let code: Int?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let etag: String?
    let data: DataResponse?
}

struct DataResponse: Decodable {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [Hero]?
}

struct MarvelServerResponseForHeroStuff: Decodable {
    let code: Int?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let etag: String?
    let data: DataResponseForHeroStuff?
}

struct DataResponseForHeroStuff: Decodable {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [HeroStuff]?
}

struct Hero: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let modified: String?
    let thumbnail: Thumbnail?
    let resourceURI: String?
    let title: String?
    let comics: Comics?
    let series: Comics?
    let stories: Comics?
    let events: Comics?
}

struct HeroStuff: Decodable {
    let id: Int?
    let description: String?
    let title: String?
}

struct Comics: Decodable {
    let available: Int?
    let collectionURI: String?
    let items: [ComicItems]?
}

struct Series: Decodable {
    let available: Int?
    let collectionURI: String?
    let items: [ComicItems]?
}

struct Stories: Decodable {
    let available: Int?
    let collectionURI: String?
    let items: [ComicItems]?
}

struct Events: Decodable {
    let available: Int?
    let collectionURI: String?
    let items: [ComicItems]?
}

struct ComicItems: Decodable {
    let resourceURI: String?
    let name: String?
}

struct Thumbnail: Decodable {
    let path: String?
    let `extension`: String?
}
