//
//  HeroListCell.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 5/26/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit

class HeroListCell: UITableViewCell {

    @IBOutlet weak var heroName: UILabel!
    
    var hero: Hero? {
        didSet {
            setUI()
        }
    }
    
    func setUI(){
        heroName.text = hero!.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
