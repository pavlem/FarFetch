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

class HeroDetailTVC: FfTVC {
    
    // MARK: - API
    var hero: Hero?
    
    // MARK: - Properties
    @IBOutlet weak var heroDetailSegment: UISegmentedControl!
    // Vars
    var heroesStuff = [HeroStuff]() {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            tableView.reloadData()
        }
    }
    var heroesComics: [HeroStuff]?
    var heroesEvents: [HeroStuff]?
    var heroesStories: [HeroStuff]?
    var heroesSeries: [HeroStuff]?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        setUIComponents()
        fetchHeroData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        NetworkHelper.shared.cancelAllURLSessionTasks()
    }
    
    // MARK: - Helper
    func setUIComponents() {
        heroDetailSegment.setTitle("heroDetailComics".localized, forSegmentAt: HeroDetail.comics.rawValue)
        heroDetailSegment.setTitle("heroDetailEvents".localized, forSegmentAt: HeroDetail.events.rawValue)
        heroDetailSegment.setTitle("heroDetailStories".localized, forSegmentAt: HeroDetail.stories.rawValue)
        heroDetailSegment.setTitle("heroDetailSeries".localized, forSegmentAt: HeroDetail.series.rawValue)
    }
    func setNavBar() {
        navigationItem.title = hero?.name ?? ""
    }
    
    // MARK: - Action
    @IBAction func heroDetailAppearanceAction(_ sender: UISegmentedControl) {
        switch HeroDetail(rawValue: sender.selectedSegmentIndex)! {
        case .comics:
            heroesStuff = heroesComics!
        case .events:
            heroesStuff = heroesEvents!
        case .stories:
            heroesStuff = heroesStories!
        case .series:
            heroesStuff = heroesSeries!
        }
        print(sender.selectedSegmentIndex)
    }
    
    // MARK: - Network
    func fetchHeroData() {
        if let heroId = hero?.id {
            fetchHero(forId: String(describing: heroId))
        }
    }
    
    func fetchHero(forId id: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        NetworkHelper.shared.fetchHeroStuff(forId: id, success: { (data) in
            
            let dataArr = [data.dataComics, data.dataEvents, data.dataSeries, data.dataStories]
            var parsedHeroesStuff = [[HeroStuff]]()
            
            for data in dataArr {
                ParserHelper.shared.parseHeroListStuff(fromData: data, success: { (heroAppearance) in
                    parsedHeroesStuff.append(heroAppearance)
                }, isParsingAFail: { (isFail) in
                    print(isFail)
                })
            }
            
            self.heroesComics = parsedHeroesStuff[0]
            self.heroesEvents = parsedHeroesStuff[1]
            self.heroesSeries = parsedHeroesStuff[2]
            self.heroesStories = parsedHeroesStuff[3]
            
            DispatchQueue.main.async {
                self.heroesStuff = self.heroesComics!
            }
            
        }) { (isFetchFailed) in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            print(isFetchFailed)
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.heroDetail, for: indexPath)
        cell.textLabel?.text = heroesStuff[indexPath.row].title
        cell.detailTextLabel?.text = heroesStuff[indexPath.row].description
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  heroesStuff.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
