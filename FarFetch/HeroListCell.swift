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
    func setUI(){
        heroName.text = hero!.name
    }
    
    // MARK: - Actions
    @IBAction func addToFavorites(_ sender: UIButton) {
        delegate?.addToFavoritesAction(cell: self)
    }
}
