//
//  GameOverScene.swift
//  Infinite-Space
//
//  Created by Caleb Giles on 4/23/19.
//  Copyright © 2019 aincrad-online. All rights reserved.
//

import Foundation
import SpriteKit


class GameOverScene : SKScene {
    
    var scoreLabel = SKLabelNode()
    var displayScoreLabel = SKLabelNode()
    var highScoreLabel = SKLabelNode()
    var playAgainButton = SKLabelNode()
    var mainMenuButton = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        let score = GameScene.score
        
        
        
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLabel.text = "Score:"
        
        displayScoreLabel = childNode(withName: "displayScoreLabel") as! SKLabelNode
        displayScoreLabel.text = "\(score)"
        
        highScoreLabel = childNode(withName: "highScoreLabel") as! SKLabelNode
        
        if GameScene.gotHighScore{
            highScoreLabel.text = "New Highscore!!!"
        }
        else{
            highScoreLabel.text = ""
        }
        
        playAgainButton = childNode(withName: "playAgainButton") as! SKLabelNode
        
        mainMenuButton = childNode(withName: "mainMenuButton") as! SKLabelNode
  
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            let point = touch.location(in: self)
            
            if(playAgainButton.contains(point)){
                let scene = GameScene(fileNamed: "GameScene")
                scene?.scaleMode = self.scaleMode
                
                let theTransition = SKTransition.fade(withDuration: 0.5)
                HomeViewController.audioPlayer?.setVolume(SettingsViewController.vol, fadeDuration: 0.5)
                
                self.view?.presentScene(scene!, transition: theTransition)
                
                
            }
            
            if(mainMenuButton.contains(point)){
                self.view?.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
