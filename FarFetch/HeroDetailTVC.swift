//
//  HeroDetailTVC.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 5/31/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit

enum HeroDetail: Int {
    case comics
    case events
    case stories
    case series
}

class HeroDetailTVC: UITableViewController {
    
    // MARK: - API
    var hero: Hero?
    
    // MARK: - Properties
    @IBOutlet weak var heroDetailSegment: UISegmentedControl!
    // Vars
    var heroesStuff: [HeroStuff]?
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if let heroId = hero?.id {
        //            fetchHero(forId: String(describing: heroId))
        //        }
    }
    
    // MARK: - Action
    @IBAction func heroDetailAppearanceAction(_ sender: UISegmentedControl) {
        
        switch HeroDetail(rawValue: sender.selectedSegmentIndex)! {
        case .comics:
            print("comics")
        case .events:
            print("events")
        case .stories:
            print("stories")
        case .series:
            print("series")
        }
        print(sender.selectedSegmentIndex)

    }
    
    // MARK: - Network
    func fetchHero(forId id: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        //        NetworkHelper.shared.fetchHeroStuff(forId: id, success: { (data) in
        
        //            let dataComics = data.dataComics
        //
        //            let dataArr = [data.dataComics, data.dataEvents, data.dataSeries, data.dataStories]
        //
        //            var parsedHeroesStuff = [[HeroStuff]]()
        //
        //            for d in dataArr {
        //                ParserHelper.shared.parseHeroListStuff(fromData: d, success: { (heroAppearance) in
        //                    parsedHeroesStuff.append(heroAppearance)
        //                }, isParsingAFail: { (isFail) in
        //                    print(isFail)
        //                })
        //            }
        //
        //            let heroesComics = parsedHeroesStuff[0]
        //            let heroesEvents = parsedHeroesStuff[1]
        //            let heroesSeries = parsedHeroesStuff[2]
        //            let heroesStories = parsedHeroesStuff[3]
        //
        //            self.heroesStuff = heroesComics
        //            print("====")
        //
        //            DispatchQueue.main.async {
        //                UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //                self.tableView.reloadData()
        //            }
        //            print(data)
        
        //        }) { (isFetchFailed) in
        //            DispatchQueue.main.async {
        //                UIApplication.shared.isNetworkActivityIndicatorVisible = true
        //            }
        //            print(isFetchFailed)
        //        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.heroDetail, for: indexPath)
        cell.textLabel?.text = "PAJA"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5 // heroesStuff?.count ?? 0
    }
}
