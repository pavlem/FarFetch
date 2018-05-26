//
//  HeroListsTVC.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 5/26/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit

struct Response: Decodable {
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
    let results: [Results]?
}

struct Results: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let modified: String?
    let thumbnail: Thumbnail?
}

struct Thumbnail: Decodable {
    let path: String?
    let `extension`: String?
}



struct Hero: Decodable {
    let id: Int?
    let name: String?
    let link: String?
    let image_url: String?
    let number_of_lessons: Int?
}


struct Characters: Decodable {
    let count: Int?
    let limit: Int?
    let offset: Int?
}
class HeroListsTVC: FfTVC {
    
    var heroList = [Hero]()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchHeroList()
        setNavBar()
    }

    // MARK: - Helper
    func setNavBar() {
        navigationItem.title = "Heroes List"
    }
    
    // MARK: Network Helper
    func fetchHeroList() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        DispatchQueue.global(qos: .background).async {
            NetworkHelper.shared.fetchHeroList(success: { (data) in
                sleep(2)
                ParserHelper.shared.parseHeroList(fromData: data, success: { (heroes) in
                    self.heroList = heroes
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.tableView.reloadData()
                    }
                }, isParsingAFail: { (isFail) in
                    print(isFail) // Some Alert Can Be implemented here
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                })
            }, isHeroRetrivalFailed: { (isRequestFailed) in
                print(isRequestFailed)
            })
        }
    }
}

// MARK: - Table view data source
extension HeroListsTVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.heroList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "heroListCell_ID", for: indexPath) as! HeroListCell
        cell.hero = self.heroList[indexPath.row]
        return cell
    }
}
