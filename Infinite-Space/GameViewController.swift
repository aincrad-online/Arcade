//
//  GameViewController.swift
//  Infinite-Space
//
//  Created by Caleb Giles on 4/7/19.
//  Copyright © 2019 aincrad-online. All rights reserved.
//s

import UIKit
import SpriteKit
import GameplayKit
import FLAnimatedImage

class GameViewController: UIViewController {

    
    
    @IBOutlet var popover: UIView!
    static var popoverView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameViewController.popoverView = popover
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            view.ignoresSiblingOrder = true
            //view.showsFPS = true
           //view.showsNodeCount = true
        }
    }
    


    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
