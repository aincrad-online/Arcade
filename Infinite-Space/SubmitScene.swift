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
    var submitButton = SKLabelNode()
    var cancelButton = SKLabelNode()
    var textField = UITextField()
    
    override func didMove(to view: SKView) {
        label  = childNode(withName: "Label") as! SKLabelNode
        
        createStarLayers()
        
        submitButton = childNode(withName: "submit") as! SKLabelNode
        cancelButton = childNode(withName: "cancel") as! SKLabelNode
        
        let width = 200.0
        let height = 36.0
        
        let pos = convertPoint(toView: CGPoint(x: 0 - width, y: 0))
        
        
        let frame = CGRect(x: pos.x , y: pos.y, width: CGFloat(width), height: CGFloat(height))
        textField = UITextField(frame: frame)
        
        textField.backgroundColor = UIColor.white
        textField.textColor = UIColor.black
        textField.textAlignment = NSTextAlignment.center
        
        textField.font = UIFont.systemFont(ofSize: label.fontSize/2)
        textField.adjustsFontSizeToFitWidth = true
        
        
        self.view?.addSubview(textField)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let point = touch.location(in: self)
            
            if(submitButton.contains(point)){
                self.textField.removeFromSuperview()
                self.view?.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
            
            if(cancelButton.contains(point)){
                let scene = GameOverScene(fileNamed: "GameOverScene")
                scene?.scaleMode = self.scaleMode
                
                let theTransition = SKTransition.fade(withDuration: 0.5)
               
                self.textField.removeFromSuperview()
                self.view?.presentScene(scene!, transition: theTransition)
            }
            
        }
    }
    
    func starfieldEmitterNode(speed: CGFloat, lifetime: CGFloat, scale: CGFloat, birthRate: CGFloat, color: SKColor) -> SKEmitterNode {
        let star = SKLabelNode(fontNamed: "Helvetica")
        star.fontSize = 80.0
        star.text = "✦"
        let textureView = SKView()
        let texture = textureView.texture(from: star)
        texture!.filteringMode = .nearest
        
        let emitterNode = SKEmitterNode()
        emitterNode.particleTexture = texture
        emitterNode.particleBirthRate = birthRate
        emitterNode.particleColor = color
        emitterNode.particleLifetime = lifetime
        emitterNode.particleSpeed = speed
        emitterNode.particleScale = scale
        emitterNode.particleColorBlendFactor = 1
        emitterNode.position = CGPoint(x: frame.midX, y: frame.maxY)
        emitterNode.particlePositionRange = CGVector(dx: 800, dy: 0)
        emitterNode.particleSpeedRange = 16.0
        
        //Rotates the stars
        emitterNode.particleAction = SKAction.repeatForever(SKAction.sequence([
            SKAction.rotate(byAngle: CGFloat(-Double.pi / 4), duration: 1),
            SKAction.rotate(byAngle: CGFloat(Double.pi / 4), duration: 1)]))
        
        //Causes the stars to twinkle
        let twinkles = 20
        let colorSequence = SKKeyframeSequence(capacity: twinkles*2)
        let twinkleTime = 1.0 / CGFloat(twinkles)
        for i in 0..<twinkles {
            colorSequence.addKeyframeValue(SKColor.white,time: CGFloat(i) * 2 * twinkleTime / 2)
            colorSequence.addKeyframeValue(SKColor.yellow, time: (CGFloat(i) * 2 + 1) * twinkleTime / 2)
        }
        emitterNode.particleColorSequence = colorSequence
        
        emitterNode.advanceSimulationTime(TimeInterval(lifetime))
        return emitterNode
    }
    
    func createStarLayers() {
        //A layer of a star field
        let starfieldNode = SKNode()
        starfieldNode.name = "starfieldNode"
        starfieldNode.addChild(starfieldEmitterNode(speed: -48, lifetime: size.height / 23, scale: 0.2, birthRate: 1, color: SKColor.lightGray))
        addChild(starfieldNode)
        
        //A second layer of stars
        var emitterNode = starfieldEmitterNode(speed: -32, lifetime: size.height / 10, scale: 0.14, birthRate: 2, color: SKColor.gray)
        emitterNode.zPosition = -10
        starfieldNode.addChild(emitterNode)
        
        //A third layer
        emitterNode = starfieldEmitterNode(speed: -20, lifetime: size.height / 5, scale: 0.1, birthRate: 5, color: SKColor.darkGray)
        starfieldNode.addChild(emitterNode)
    }
 
    
}
