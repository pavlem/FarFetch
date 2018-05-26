//
//  HeroListsTVC.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 5/26/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit

struct Hero: Decodable {
    let id: Int?
    let name: String?
    let link: String?
    let image_url: String?
    let number_of_lessons: Int?
}

class HeroListsTVC: FfTVC {
    
    var heroList = [Hero]()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchHeroList()
    }

    // MARK: - Helper
    func fetchHeroList() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        DispatchQueue.global(qos: .background).async {
            
            NetworkHelper.shared.fetchHeroList(success: { (data) in
                sleep(1)
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    self.heroList = try decoder.decode([Hero].self, from: data)
                } catch let jsonErr {
                    print("Failed to decode:", jsonErr)
                }
                
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.tableView.reloadData()
                }
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
        cell.heroName.text = self.heroList[indexPath.row].name
        return cell
    }
}
