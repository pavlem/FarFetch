//
//  HeroSearchVC.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 5/29/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit

class HeroSearchVC: UIViewController {
    
    // MARK: - Properties
    // Outlets
    @IBOutlet weak var heroNameTextFld: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUIComponents()
    }
    
    // MARK: - Helper
    func setUIComponents() {
        heroNameTextFld.placeholder = "heroSearchPlaceholder".localized
        searchBtn.setTitle("search".localized, for: .normal)
        navigationItem.title = "heroSearchNavTitle".localized
    }
    
    // MARK: - Actions
    @IBAction func search(_ sender: UIButton) {
    
        guard let heroName = heroNameTextFld.text else { return }
        guard heroName.count > 0 else { return }

        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        NetworkHelper.shared.fetchHero(heroName, success: { (data) in
            aprint(data.count)
            
            ParserHelper.shared.parseHeroList(fromData: data, success: { (heroes) in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    let heroListSB = UIStoryboard.heroList
                    let heroListVC = heroListSB.instantiateViewController(withIdentifier: ViewControllerID.heroList) as! HeroListsTVC
                    heroListVC.isSearchMode = true
                    heroListVC.heroList = heroes
                    self.navigationController?.show(heroListVC, sender: self)
                }
                
            }, isParsingAFail: { (isParseFail) in
                aprint(isParseFail)
                //.. Alert
            })
        }, isHeroSearchFailed: { (isFail) in
            aprint(isFail)
            // Alert..
        })
    }
}
