//
//  SubmitScene.swift
//  Infinite-Space
//
//  Created by Caleb Giles on 4/25/19.
//  Copyright © 2019 aincrad-online. All rights reserved.
//

import Foundation
import SpriteKit



class SubmitScene : SKScene {
    
    var label = SKLabelNode()
    
    
    override func didMove(to view: SKView) {
        label  = childNode(withName: "Label") as! SKLabelNode
        
        let frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let textField = UITextView(frame: frame)
        
        textField.backgroundColor = UIColor.gray
        textField.textColor = UIColor.white
        textField.textAlignment = NSTextAlignment.center
        
        self.view?.addSubview(textField)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            
        }
    }
 
    
}
