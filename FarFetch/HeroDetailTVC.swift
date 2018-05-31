//
//  HeroDetailTVC.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 5/31/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit

class HeroDetailTVC: UITableViewController {
    
    // MARK: - API
    var hero: Hero?

    // MARK: - Properties
    @IBOutlet weak var heroDetailSegment: UISegmentedControl!
    // Vars
//    var heroStuff: [Hero]?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let heroId = hero?.id {
            fetchHero(forId: String(describing: heroId))
        }
    }
    
    // MARK: - Action
    @IBAction func heroDetailAppearanceAction(_ sender: UISegmentedControl) {
    }
    
    // MARK: - Network
    func fetchHero(forId id: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        NetworkHelper.shared.fetchHeroStuff(forId: id, success: { (data) in
            
            let dataComics = data.dataComics
            
            ParserHelper.shared.parseHeroListStuff(fromData: dataComics, success: { (heroAppearance) in
                print(heroAppearance)
            }, isParsingAFail: { (isFail) in
                print(isFail)
            })
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            print(data)
            
        }) { (isFetchFailed) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }
            print(isFetchFailed)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
