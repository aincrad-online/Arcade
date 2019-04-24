//
//  SettingsViewController.swift
//  Infinite-Space
//
//  Created by Komlan Attiogbe on 4/16/19.
//  Copyright © 2019 aincrad-online. All rights reserved.
//

import UIKit
import FLAnimatedImage

class SettingsViewController: UIViewController{
    
    @IBOutlet weak var musicSlider: UISlider!
    @IBOutlet weak var ResetStatsButton: UIButton!
    @IBOutlet weak var backgroundGif: FLAnimatedImageView!
    
    public static var vol: Float = 0.5
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ResetStatsButton.layer.borderWidth = 0
        musicSlider.value = SettingsViewController.vol
        //musicSlider.value
        // Do any additional setup after loading the view.
        let path2 : String = Bundle.main.path(forResource: "spaceEarth", ofType: "gif")!
        
        let url2 = URL(fileURLWithPath: path2)
        do {
            let gifData2 = try Data(contentsOf: url2)
            let imageData2 = try? FLAnimatedImage(animatedGIFData: gifData2)
            backgroundGif.animatedImage = imageData2 as? FLAnimatedImage
        } catch {
            print(error)
        }
    }
    
    @IBAction func onBackButton(_ sender: Any) {
        SettingsViewController.vol = musicSlider.value
        print(SettingsViewController.vol)
        self.dismiss(animated: true, completion: nil)
        SettingsViewController.vol = musicSlider.value
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    @IBAction func onMusicSlider(_ sender: UISlider) {
        HomeViewController.audioPlayer?.setVolume(musicSlider.value, fadeDuration: 0.5)
        //vol = musicSlider.value
    }
    
    func getSliderValue() -> Float{
        return SettingsViewController.vol
    }
}

