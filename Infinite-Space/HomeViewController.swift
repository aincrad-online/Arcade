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

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var LeaderboardButton: UIButton!
    @IBOutlet weak var SettingsButton: UIButton!
    
    var backgroundStartPosition = CGAffineTransform()
    var audioPlayer: AVAudioPlayer?
    var InGame = false
    
    
    @IBOutlet weak var LogoGif: FLAnimatedImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundStartPosition = backgroundImage.transform
        
        PlayButton.layer.borderWidth = 0
        LeaderboardButton.layer.borderWidth = 0
        SettingsButton.layer.borderWidth = 0
        
        let path1 : String = Bundle.main.path(forResource: "InfiniteSpace", ofType: "gif")!
        let url = URL(fileURLWithPath: path1)
        do {
            let gifData = try Data(contentsOf: url)
            let imageData1 = try? FLAnimatedImage(animatedGIFData: gifData) 
            LogoGif.animatedImage = imageData1 as? FLAnimatedImage
        } catch {
            print(error)
        }
        
        
        
        playMusic(start: true)
        animateBackground()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        backgroundImage.transform = backgroundStartPosition
        animateBackground()
        playMusic(start: false)
        InGame = false
        
    }
    
    func playMusic(start: Bool){
        if(InGame || start){
            do {
                if let fileURL = Bundle.main.path(forResource: "HomePageAudio", ofType: "mp3") {
                    audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
                } else {
                    print("No file with specified name exists")
                }
            } catch let error {
                print("Can't play the audio file failed with an error \(error.localizedDescription)")
        }
            
            audioPlayer?.play()
            
    }
}

    func animateBackground(){
        UIView.animate(withDuration: 15, delay: 0, options: [.autoreverse, .curveLinear,.repeat], animations: {
            let x = -(self.backgroundImage.frame.width - self.view.frame.width)
            self.backgroundImage.transform = CGAffineTransform(translationX: x, y: 0)
        }, completion: nil)
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
        audioPlayer?.stop()
    }
}

