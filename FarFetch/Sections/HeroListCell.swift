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
    
    var currentDataTask: URLSessionDataTask?
    
    // MARK: - Outlets
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroImg: UIImageView!
    @IBOutlet weak var addToFavoritesBtn: UIButton!
    @IBOutlet weak var imgLoadingIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.heroImg.layer.cornerRadius = heroImg.bounds.width / 2
        heroImg.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        heroImg.image = UIImage.placeHolder
        heroName.text = ""
        addToFavoritesBtn.setTitle("", for: .normal)
        
        if let currentImageDataTask = currentDataTask {
            currentImageDataTask.cancel()
        }
        imgLoadingIndicator.stopAnimating()
        imgLoadingIndicator.isHidden = true
    }
    
    // MARK: - Helper
    func setUI() {
        heroImg.image = UIImage.placeHolder
        heroName.text = hero!.name
        
        let addRemoveBtnTitle = realm.object(ofType: HeroRealm.self, forPrimaryKey: String(describing: hero!.id!)) != nil ? "heroListRemove".localized : "heroListAdd".localized
        addToFavoritesBtn.setTitle(addRemoveBtnTitle, for: .normal)
        
        if hero!.thumbnail != nil {
            let imgUrl = hero!.thumbnail!.path! + "." + hero!.thumbnail!.extension!
            
            if let img = heroesImgsCache.object(forKey: (imgUrl as AnyObject)) as? UIImage {
                heroImg.image = img
            } else {
                heroImg.image = UIImage.placeHolder
                imgLoadingIndicator.startAnimating()
                self.imgLoadingIndicator.isHidden = false
            
                currentDataTask = URLSession.shared.dataTask(with: URL(string: imgUrl)!) { (data, resposne, err) in
                    if err != nil {
                        return
                    }
                    
                    let img = UIImage(data: data!)
                    
                    heroesImgsCache.setObject(img!, forKey: imgUrl as AnyObject)
                    DispatchQueue.main.async {
                        self.heroImg.image = img
                        self.imgLoadingIndicator.stopAnimating()
                        self.imgLoadingIndicator.isHidden = true
                    }
                }
                
                currentDataTask!.resume()
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func addToFavorites(_ sender: UIButton) {
        delegate?.addToFavoritesAction(cell: self)
    }
}
