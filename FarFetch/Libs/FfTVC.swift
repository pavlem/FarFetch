//
//  FfTVC.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 5/26/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import UIKit

class FfTVC: UITableViewController {

    let estimatedRowHeight = CGFloat(80)

    override func viewDidLoad() {
        super.viewDidLoad()

        setTableViewAppearance()
    }

    func setTableViewAppearance() {
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.tableFooterView!.isHidden = true
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
}
