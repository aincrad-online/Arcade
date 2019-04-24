//
//  GameScene.swift
//  Infinite-Space
//
//  Created by Caleb Giles on 4/7/19.
//  Copyright © 2019 aincrad-online. All rights reserved.
//

import SpriteKit
import GameplayKit
import FLAnimatedImage

class GameScene: SKScene, SKPhysicsContactDelegate {

    static var score = 0
    static var gotHighScore = false
    let defaults = UserDefaults()
    var highScoreLabel = SKLabelNode()
    var highScore = 0
    
    var player = SKSpriteNode()
    var nextBullet = 0.0
    var fireRate = 0.5
    var canFireBullet = false
    
    var nextRock = 1.0
    var spawnRate = 0.25
    var fallRate = 3.0
    var canSpawnRocks = true
    
    var scoreLabel = SKLabelNode()
    var nextScore = 1.0
    var scoreRate = 1.0
    var canScore = true
    
    var gameEnded = false
    
    
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
        player.physicsBody?.categoryBitMask = physicsCategories.Player
        player.physicsBody?.collisionBitMask = physicsCategories.None
        player.physicsBody?.contactTestBitMask = physicsCategories.Rock
        
        
        GameScene.score = 0
        GameScene.gotHighScore = false
        scoreLabel = self.childNode(withName: "ScoreLabel") as! SKLabelNode
        
        scoreLabel.text = "Score: \(GameScene.score)"
        
        highScore = defaults.integer(forKey: "highScore")
        highScoreLabel = self.childNode(withName: "highScoreLabel") as! SKLabelNode
        highScoreLabel.text = "Highscore: \(highScore)"
        
        border = SKPhysicsBody.init(edgeLoopFrom: self.frame)
        createStarLayers()
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        else{
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        //player hits a rock
        if body1.categoryBitMask == physicsCategories.Player && body2.categoryBitMask == physicsCategories.Rock{
            
            if body1.node != nil{
            
            spawnExplosion(spawnPosition: body1.node!.position)
            }
            
            gameOver()
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
        
        //bullet hits a rock
        if body1.categoryBitMask == physicsCategories.bullet && body2.categoryBitMask == physicsCategories.Rock{
            
            if body2.node != nil{
            
            spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
        
    }
    
    func spawnExplosion(spawnPosition: CGPoint){
        let explosion = SKSpriteNode(imageNamed: "Explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 0.25, duration: 0.1)
        let ScaleOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([scaleIn, ScaleOut, delete])
        
        explosion.run(explosionSequence)
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
        bullet.physicsBody?.categoryBitMask = physicsCategories.bullet
        bullet.physicsBody?.collisionBitMask = physicsCategories.None
        bullet.physicsBody?.contactTestBitMask = physicsCategories.Rock
        
        
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
        
        let colliderSize = CGSize(width: rock.size.width * 0.9, height: rock.size.height * 0.9)
        
        rock.physicsBody = SKPhysicsBody(rectangleOf: colliderSize)
        rock.physicsBody?.affectedByGravity = false
        rock.physicsBody?.allowsRotation = false
        rock.physicsBody?.linearDamping = CGFloat(0.0)
        rock.physicsBody?.categoryBitMask = physicsCategories.Rock
        rock.physicsBody?.collisionBitMask = physicsCategories.None
        rock.physicsBody?.contactTestBitMask = physicsCategories.Player | physicsCategories.bullet
        
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
    
    func incrementScore(){
        GameScene.score += 1
        if GameScene.score > highScore {
            highScoreLabel.text = "highscore: \(GameScene.score)"
        }
        scoreLabel.text = "Score: \(GameScene.score)"
    }
    
    func gameOver(){
        canSpawnRocks = false
        canScore = false
        canFireBullet = false
        gameEnded = true
        
        
        let sceneAction = SKAction.run(changeScene)
        let wait = SKAction.wait(forDuration: 2.0)
        let changeSequence = SKAction.sequence([wait, sceneAction])
        

        if(GameScene.score > highScore){
            GameScene.gotHighScore = true
            highScore = GameScene.score
            defaults.set(highScore, forKey: "highScore")
            
        }
        
        
        
        self.run(changeSequence)
      
    }
    
    func changeScene(){
        let scene = GameOverScene(fileNamed: "GameOverScene")
        scene!.scaleMode = self.scaleMode
        
        let theTransition = SKTransition.fade(withDuration: 0.5)
        
        self.view?.presentScene(scene!, transition: theTransition)
        
        HomeViewController.audioPlayer?.setVolume(0.0, fadeDuration: 0.5)
        
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
        if(!gameEnded){
            canFireBullet = true
        }
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
        
        if(currentTime > nextScore && canScore){
            nextScore = currentTime + scoreRate
            incrementScore()
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
