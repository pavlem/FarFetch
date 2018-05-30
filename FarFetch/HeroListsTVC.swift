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
//    let thumbnail: Thumbnail?
}

struct Thumbnail: Decodable {
    let path: String?
    let `extension`: String?
}

class HeroListsTVC: FfTVC {
    
    // MARK: - API
    var heroList = [Hero]()
    
    // MARK: - Properties
    private var isLoadingMore = false // flag
    private var isSearchMode = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        fetchHeroList {}
    }
    
    // MARK: - Helper
    func setNavBar() {
        navigationItem.title = "Heroes List"
        addRefreshControl()
    }
    
    func addRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshHeroList), for: UIControlEvents.valueChanged)
        refresh.backgroundColor = .white
        refreshControl = refresh
    }
    
    // MARK: - Actions
    @objc func refreshHeroList() {
        isSearchMode = false
        NetworkHelper.shared.characterListOffset = 0
        fetchHeroList {
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: Network Helper
    func fetchHeroList(success: @escaping () -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        DispatchQueue.global(qos: .background).async {
            NetworkHelper.shared.fetchHeroList(success: { (data) in
                success()
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.heroSearch {
            if let heroSearchVC = segue.destination as? HeroSearchVC {
                self.isSearchMode = false
                heroSearchVC.delegate = self
            }
        } else if segue.identifier == Segue.heroDetail {
            //..
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
            if !isLoadingMore && !isSearchMode {
                self.isLoadingMore = true
                UIApplication.shared.isNetworkActivityIndicatorVisible = true

                DispatchQueue.global(qos: .background).async {
                    
                    NetworkHelper.shared.fetchHeroList(success: { (data) in
                        ParserHelper.shared.parseHeroList(fromData: data, success: { (heroes) in
                            self.heroList += heroes
                            DispatchQueue.main.async {
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                self.tableView.reloadData()
                                self.isLoadingMore = false
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

extension HeroListsTVC: HeroSearchVCDelegate {
    func searchCompleteWith(heroes: [Hero]?) {
        if let heroesLocal = heroes {
            self.isSearchMode = true
            self.heroList.removeAll()
            self.heroList = heroesLocal
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.setContentOffset(.zero, animated: true)
            }
            
        }
    }
}
