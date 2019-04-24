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
    
    override func didMove(to view: SKView) {
        
        let score = GameScene.score
        
        
        
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        scoreLabel.text = "Score:"
        
        displayScoreLabel = childNode(withName: "displayScoreLabel") as! SKLabelNode
        displayScoreLabel.text = "\(score)"
        
        highScoreLabel = childNode(withName: "highScoreLabel") as! SKLabelNode
        
        if GameScene.gotHighScore{
            highScoreLabel.text = "New High Score!!!"
        }
        else{
            highScoreLabel.text = ""
        }
        
        

    
        
    }
    
}
