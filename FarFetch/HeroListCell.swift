//
//  HeroListCell.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 5/26/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit

protocol HeroListCellDelegate: class {
    func addToFavoritesAction(cell: HeroListCell)
}

class HeroListCell: UITableViewCell {

    // MARK: - API
    weak var delegate: HeroListCellDelegate?

    var hero: Hero? {
        didSet {
            setUI()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroImg: UIImageView!
    @IBOutlet weak var addToFavoritesBtn: UIButton!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Helper
    func setUI() {
        heroImg.image = nil
        heroName.text = hero!.name
        
        if hero!.thumbnail != nil {
            let imgUrl = hero!.thumbnail!.path! + "." + hero!.thumbnail!.extension!
            
            if let img = heroesImgsCache.object(forKey: (imgUrl as AnyObject)) as? UIImage {
                heroImg.image = img
            } else {
                URLSession.shared.dataTask(with: URL(string: imgUrl)!) { (data, resposne, err) in
                    if err != nil {
                        return
                    }
                    
                    let img = UIImage(data: data!)
                    
                    heroesImgsCache.setObject(img!, forKey: imgUrl as AnyObject)
                    DispatchQueue.main.async {
                        self.heroImg.image = img
                    }
                }.resume()
            }
            print(imgUrl)
        }
    }
    
    // MARK: - Actions
    @IBAction func addToFavorites(_ sender: UIButton) {
        delegate?.addToFavoritesAction(cell: self)
    }
}
