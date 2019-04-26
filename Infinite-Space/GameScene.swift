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
    static var highScore = 0
    
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
    var background = SKSpriteNode()
    
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
        
        GameScene.highScore = defaults.integer(forKey: "highScore")
        highScoreLabel = self.childNode(withName: "highScoreLabel") as! SKLabelNode
        highScoreLabel.text = "Highscore: \(GameScene.highScore)"
        
        border = SKPhysicsBody.init(edgeLoopFrom: self.frame)
        //createStarLayers()
        
        background = self.childNode(withName: "background") as! SKSpriteNode
        createBackground()
    }
    
    
    func createBackground(){
        for i in 1...3 {
            let sky = SKSpriteNode(imageNamed: "Parallax")
            sky.name = "background"
            sky.size = background.size
            sky.anchorPoint = background.anchorPoint
            sky.position = CGPoint(x: sky.position.x, y: CGFloat(i) * sky.size.width)
            sky.zPosition = -1
            self.addChild(sky)
        }
    }
    
    func moveBackground(){
        self.enumerateChildNodes(withName: "background", using: ({
            (node,error) in
            node.position.y -= 2
            if(node.position.y < -(self.size.height)){
                node.position.y += self.size.height * 3
            }
        }))
        
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
        if GameScene.score > GameScene.highScore {
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
        

        if(GameScene.score > GameScene.highScore){
            GameScene.gotHighScore = true
            GameScene.highScore = GameScene.score
            defaults.set(GameScene.highScore, forKey: "highScore")
            
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
        //shooting,scoring, and rock spawn is disabled on game over
        
        if(currentTime > nextBullet && canFireBullet && canScore){
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
        
        moveBackground()
    }

}
