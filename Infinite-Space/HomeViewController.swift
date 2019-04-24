//
//  HomeViewController.swift
//  Infinite-Space
//
//  Created by Komlan Attiogbe on 4/16/19.
//  Copyright © 2019 aincrad-online. All rights reserved.
//

import UIKit
import FLAnimatedImage
import AVFoundation

class HomeViewController: UIViewController {
    
    static let shared: HomeViewController = HomeViewController()
    let settings = SettingsViewController()
    
    let defaults = UserDefaults.standard
    
    
    
    @IBOutlet weak var backgroundGif: FLAnimatedImageView!
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var LeaderboardButton: UIButton!
    @IBOutlet weak var SettingsButton: UIButton!
    
    var backgroundStartPosition = CGAffineTransform()
    public static var audioPlayer: AVAudioPlayer?
    var InGame = false
    
    
    @IBOutlet weak var LogoGif: FLAnimatedImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PlayButton.layer.borderWidth = 0
        LeaderboardButton.layer.borderWidth = 0
        SettingsButton.layer.borderWidth = 0
        
        let path1 : String = Bundle.main.path(forResource: "InfiniteSpace", ofType: "gif")!
        let path2 : String = Bundle.main.path(forResource: "spaceEarth", ofType: "gif")!

        let url = URL(fileURLWithPath: path1)
        let url2 = URL(fileURLWithPath: path2)
        do {
            let gifData = try Data(contentsOf: url)
            let gifData2 = try Data(contentsOf: url2)
            let imageData1 = try? FLAnimatedImage(animatedGIFData: gifData)
            let imageData2 = try? FLAnimatedImage(animatedGIFData: gifData2)
            LogoGif.animatedImage = imageData1 as? FLAnimatedImage
            backgroundGif.animatedImage = imageData2 as? FLAnimatedImage
        } catch {
            print(error)
        }
        
        
        
        playMusic(start: true, song:"HomePageAudio")
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        playMusic(start: false, song:"HomePageAudio")
        InGame = false
        
    }
    
    func playMusic(start: Bool, song: String){
        if(InGame || start){
            do {
                if let fileURL = Bundle.main.path(forResource: song, ofType: "mp3") {
                    HomeViewController.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
                } else {
                    print("No file with specified name exists")
                }
            } catch let error {
                print("Can't play the audio file failed with an error \(error.localizedDescription)")
        }
            
            HomeViewController.audioPlayer?.play()
            
    }
}
    
    @IBAction func onLeaderboardButton(_ sender: Any) {
        self.performSegue(withIdentifier: "LeaderboardPush", sender: self)
        
    }
    

    @IBAction func onSettingsButton(_ sender: Any) {
        self.performSegue(withIdentifier: "SettingsPush", sender: self)
    }
    
    
    @IBAction func onPlayButton(_ sender: Any) {
        self.performSegue(withIdentifier: "GamePush", sender: self)
        InGame = true
        HomeViewController.audioPlayer?.stop()
        playMusic(start: false, song: "gameAudio")
        HomeViewController.audioPlayer?.setVolume(settings.getSliderValue(), fadeDuration: 0.5)
        HomeViewController.audioPlayer?.play()
        print(settings.getSliderValue())
    }
}

