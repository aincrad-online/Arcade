//
//  CustomNavController.swift
//  Infinite-Space
//
//  Created by Komlan Attiogbe on 4/22/19.
//  Copyright © 2019 aincrad-online. All rights reserved.
//

import UIKit

class CustomNavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        //navigationBar.tintColor = .white
        
    }

}
