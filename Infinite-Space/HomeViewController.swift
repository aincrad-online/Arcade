//
//  HomeViewController.swift
//  Infinite-Space
//
//  Created by Komlan Attiogbe on 4/16/19.
//  Copyright © 2019 aincrad-online. All rights reserved.
//

import UIKit


class HomeViewController: UIViewController {

    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var LeaderboardButton: UIButton!
    @IBOutlet weak var SettingsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PlayButton.layer.cornerRadius = 15
        PlayButton.layer.borderWidth = 1
        LeaderboardButton.layer.cornerRadius = 15
        LeaderboardButton.layer.borderWidth = 1
        SettingsButton.layer.cornerRadius = 15
        SettingsButton.layer.borderWidth = 1
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLeaderboardButton(_ sender: Any) {
        self.performSegue(withIdentifier: "LeaderboardPush", sender: self)
        
    }
    

    @IBAction func onSettingsButton(_ sender: Any) {
        self.performSegue(withIdentifier: "SettingsPush", sender: self)
    }
}
/*
extension UIImage {
    public class func gif(asset: String) -> UIImage? {
        if let asset = NSDataAsset(name: asset) {
            return UIImage.gif(asset: asset.data)
        }
        return nil
    }
}
*/
