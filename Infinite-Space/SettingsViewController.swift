//
//  SettingsViewController.swift
//  Infinite-Space
//
//  Created by Komlan Attiogbe on 4/16/19.
//  Copyright © 2019 aincrad-online. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var musicSlider: UISlider!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var ResetStatsButton: UIButton!
    var backgroundStartPosition = CGAffineTransform()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundStartPosition = backgroundImage.transform
        ResetStatsButton.layer.borderWidth = 0
        animateBackground()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        backgroundImage.transform = backgroundStartPosition
        animateBackground()
        
    }
    
    func animateBackground(){
        UIView.animate(withDuration: 15, delay: 0, options: [.autoreverse, .curveLinear,.repeat], animations: {
            let x = -(self.backgroundImage.frame.width - self.view.frame.width)
            self.backgroundImage.transform = CGAffineTransform(translationX: x, y: 0)
        }, completion: nil)
    }

}
