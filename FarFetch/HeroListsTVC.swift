//
//  HeroListsTVC.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 5/26/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit

class HeroListsTVC: FfTVC {
    
    var heroNames = [""]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "http://api.letsbuildthatapp.com/jsondecodable/courses_snake_case"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        DispatchQueue.global(qos: .background).async {
            
            NetworkHelper.shared.fetchData(forUrlString: urlString, success: { (data) in
                print(data)
                self.heroNames = ["Paja", "Pera", "Zika", "Mica"]
                sleep(1)
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.tableView.reloadData()
                }
            }) { (isRequestFailed) in
                print(isRequestFailed)
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroNames.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "heroListCell_ID", for: indexPath) as! HeroListCell
        cell.heroName.text = heroNames[indexPath.row]
        return cell
    }
}
