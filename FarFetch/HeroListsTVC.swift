//
//  HeroListsTVC.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 5/26/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit

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

struct Hero: Decodable {
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

class HeroListsTVC: FfTVC {
    
    var heroList = [Hero]()
    
    private var isLoadingMore = false // flag
    
    
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
                ParserHelper.shared.parseHeroList(fromData: data, success: { (heroes) in
                    self.heroList = heroes
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.tableView.reloadData()
                    }
                }, isParsingAFail: { (isFail) in
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        // Some Alert Can Be implemented here to notify the user
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
        return heroList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.heroList, for: indexPath) as! HeroListCell
        cell.hero = heroList[indexPath.row]
        cell.delegate = self
        
        // Check if the last row number is the same as the last current data element
        if indexPath.row == self.heroList.count - 1 {
            if !isLoadingMore {
                self.isLoadingMore = true
                UIApplication.shared.isNetworkActivityIndicatorVisible = true

                DispatchQueue.global(qos: .background).async {
                    sleep(2)
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self.heroList += self.heroList
                        self.tableView.reloadData()
                        self.isLoadingMore = false
                    }
                }
            }
            print("=====")
        }
        return cell
    }
}

extension HeroListsTVC: HeroListCellDelegate {
    func addToFavoritesAction(cell: HeroListCell) {
        let indexPath = tableView.indexPath(for: cell)
        
        print(indexPath ?? "none")
    }
}
