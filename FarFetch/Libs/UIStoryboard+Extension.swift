//
//  UIStoryboard+Extension.swift
//  FarFetch
//
//  Created by Pavle Mijatovic on 6/2/18.
//  Copyright © 2018 Pavle Mijatovic. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {
    static var heroList: UIStoryboard { return UIStoryboard(name: "HeroList", bundle: Bundle.main) }
    static var heroDetail: UIStoryboard { return UIStoryboard(name: "HeroDetail", bundle: Bundle.main) }
    static var heroSearch: UIStoryboard { return UIStoryboard(name: "HeroSearch", bundle: Bundle.main) }
}
