//
//  GameScene.swift
//  Infinite-Space
//
//  Created by Caleb Giles on 4/7/19.
//  Copyright © 2019 aincrad-online. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {


    var player = SKSpriteNode()
    var nextBullet = 0.0
    var fireRate = 1.0
    var canFireBullet = false
    
    var nextRock = 1.0
    var spawnRate = 0.25
    var fallRate = 3.0
    var canSpawnRocks = true
    
    var border = SKPhysicsBody()
    
    struct physicsCategories{
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1
        static let bullet: UInt32 = 0b10
        static let Rock: UInt32 = 0b100
    }

    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
        player = self.childNode(withName: "Player") as! SKSpriteNode
        
        print(player.zPosition)
        border = SKPhysicsBody.init(edgeLoopFrom: self.frame)
        createStarLayers()
    }
    
    func fireBullet(){
        
        let bullet = SKSpriteNode(imageNamed: "Bullet")
        bullet.setScale(0.25)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.allowsRotation = false
        bullet.physicsBody?.linearDamping = CGFloat(0.0)
        
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let destroyBullet = SKAction.removeFromParent()
        
        let bulletSequence = SKAction.sequence([moveBullet, destroyBullet])
        
        bullet.run(bulletSequence)
    }
    
    func spawnRocks(){
        
        let randomStart = random(min: -(self.frame.width/2), max: (self.frame.width/2))
        let randomEnd = random(min: -(self.frame.width/2), max: (self.frame.width/2))
        let startPoint = CGPoint(x: randomStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomEnd, y: -((self.size.height/2) * 1.2))
        let randomRotation = CGFloat(random(min: 0.0, max: 360.0))
        
        let randomRock = random(min:-1.0, max: 1.0)
        var rock = SKSpriteNode()
        if randomRock >= 0.0{
            rock = SKSpriteNode(imageNamed: "Astroid1")
        }
        else{
            rock = SKSpriteNode(imageNamed: "Astroid2")
        }
        
        
        rock.setScale(0.25)
        rock.position = startPoint
        rock.zPosition = 2
        rock.zRotation = randomRotation
        self.addChild(rock)
        
        //let rockFall = SKAction.moveTo(y: endPoint.y, duration: 2.0)
        let rockFall = SKAction.move(to: endPoint, duration: fallRate)
        let deleteRock = SKAction.removeFromParent()
        
        let rockSequence = SKAction.sequence([rockFall, deleteRock])
        
        rock.run(rockSequence)
    }
    
    func random() ->CGFloat{
        return CGFloat(Float(drand48()))
    }
    
    func random(min: CGFloat, max: CGFloat)->CGFloat{
        return random() * (max-min) + min
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        canFireBullet = true
        for touch in touches{
            let location = touch.location(in: self)
            
            player.run(SKAction.moveTo(x: location.x, duration: 0.2))
            
        }
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       canFireBullet = true
        for touch in touches{
            let location = touch.location(in: self)
            
            player.run(SKAction.moveTo(x: location.x, duration: 0.1))
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        canFireBullet = false
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if(currentTime > nextBullet && canFireBullet){
            nextBullet = currentTime + fireRate
            fireBullet()
        }
        
        if(currentTime > nextRock && canSpawnRocks){
            nextRock = currentTime + spawnRate
            spawnRocks()
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
