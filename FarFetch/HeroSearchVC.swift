//
//  HeroSearchVC.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 5/29/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit

protocol HeroSearchVCDelegate: class {
    func searchCompleteWith(heroes: [Hero]?)
}

class HeroSearchVC: UIViewController {
    
    // MARK: - API
    weak var delegate: HeroSearchVCDelegate?

    // MARK: - Properties
    // Outlets
    @IBOutlet weak var heroNameTextFld: UITextField!
    @IBOutlet weak var searchLbl: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setUIComponents()
    }
    
    // MARK: - Helper
    func setUIComponents() {
        //...
    }
    
    // MARK: - Actions
    @IBAction func search(_ sender: UIButton) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        DispatchQueue.global(qos: .background).async {
            
            sleep(2)
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false

                let hero1 = Hero(id: 1111, name: "Pajamen", description: "sadfdfs", modified: "dsdfsdf", thumbnail: nil)
                
                let hero2 = Hero(id: 2222, name: "Pajamen 2", description: "sadfdfs", modified: "dsdfsdf", thumbnail: nil)
                
                self.delegate?.searchCompleteWith(heroes: [hero1, hero2])
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        //API CALL
        //DelegateCallBack
        //Pop
    }
}
