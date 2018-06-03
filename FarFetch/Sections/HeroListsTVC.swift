//
//  HeroListsTVC.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 5/26/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit
import RealmSwift

var heroesImgsCache = NSCache<AnyObject, AnyObject>()

enum AllOrFavorites: Int {
    case all
    case favorties
}

class HeroListsTVC: FfTVC {
    
    // MARK: - API
    var heroList = [Hero]()
    var heroListPersisted = [Hero]()
    var heroListFromWeb = [Hero]()
    var isSearchMode = false

    // MARK: - Properties
    // Vars
    private var isLoadingMore = false
    private var isFavoritesMode = false

    // Outlets
    @IBOutlet weak var searchBarBtn: UIBarButtonItem!
    @IBOutlet weak var allOrFavoritesCtrl: UISegmentedControl!
    // Constants
    let cellHeight = CGFloat(80)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        setUIComponents()
        if !isSearchMode {
            fetchHeroList {}
            addRefreshControl()
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    // MARK: - Helper
    func setUIComponents() {
        searchBarBtn.title = "search".localized
    }
    
    func setNavBar() {
        navigationItem.title = "heroList".localized
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
    
    @IBAction func allOrFavoritesAction(_ sender: UISegmentedControl) {
        switch AllOrFavorites(rawValue: sender.selectedSegmentIndex)! {
        case .all:
            isFavoritesMode = false
            heroList = heroListFromWeb
            tableView.reloadData()
        case .favorties:
            isFavoritesMode = true
            heroListPersisted.removeAll()
            heroListPersisted = DbHelper.shared.getPersistedHeroes()
            heroList = heroListPersisted
            tableView.reloadData()
        }
    }
    
    // MARK: Network Helper
    func fetchHeroList(success: @escaping () -> Void) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        DispatchQueue.global(qos: .background).async {
            NetworkHelper.shared.fetchHeroList(success: { (data) in
                success()
                ParserHelper.shared.parseHeroList(fromData: data, success: { (heroes) in
                    self.heroListFromWeb = heroes
                    self.heroList = self.heroListFromWeb
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
                aprint(isRequestFailed)
            })
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segue.heroSearch {
            if let _ = segue.destination as? HeroSearchVC {
                self.isSearchMode = false
                //                heroSearchVC.delegate = self
            }
        } else if segue.identifier == Segue.heroDetail {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedRow = indexPath.row
                let heroDetailTVC = segue.destination as! HeroDetailTVC
                heroDetailTVC.hero = self.heroList[selectedRow]
            }
        }
    }
}

// MARK: - Table view data source
extension HeroListsTVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.heroList, for: indexPath) as! HeroListCell
        cell.hero = heroList[indexPath.row]
        cell.delegate = self
        
        // Check if the last row number is the same as the last current data element
        if indexPath.row == self.heroList.count - 1 {
            if !isLoadingMore && !isSearchMode && !isFavoritesMode {
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
                        aprint(isRequestFailed)
                    })
                }
            }
        }
        return cell
    }
}

extension HeroListsTVC: HeroListCellDelegate {
    func addToFavoritesAction(cell: HeroListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        let heroRealm = HeroRealm()
        heroRealm.setHeroRealm(with: heroList[indexPath.row])

        if let heroR = realm.object(ofType: HeroRealm.self, forPrimaryKey: heroRealm.id) {
            DbHelper.shared.delete(object: heroR)
            cell.addToFavoritesBtn.setTitle("heroListAdd".localized, for: .normal)
        } else {
            DbHelper.shared.add(object: heroRealm)
            cell.addToFavoritesBtn.setTitle("heroListRemove".localized, for: .normal)
        }
    }
}
