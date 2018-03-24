//
//  GameScene.swift
//  tiny game1
//
//  Created by ofer on 04/10/2016.
//  Copyright © 2016 ofertande. All rights reserved.
//

import SpriteKit

enum collision: UInt32 {
    case player = 1
    case wall = 2
    case enemy = 4
}
var mainSelf = SKNode()
var mainLight = SKLightNode()
var mainCamera = SKCameraNode()
var obsNode = SKNode()
var ball = SKSpriteNode()
var particles : [SKEmitterNode] = []
var currentLevel : Level = Level()
var gamestop : Bool = false
let redTime : CGFloat = 4

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        gamestop = false
        physicsWorld.contactDelegate = self
        mainSelf = self
        mainLight = childNode(withName: "mainLight") as! SKLightNode
        mainCamera = childNode(withName: "mainCamera") as! SKCameraNode
        setupCamera(camera: mainCamera)
        obsNode = childNode(withName: "obsNode")!
        
        ball = SKSpriteNode(imageNamed: "circle-512.png")
        ball.name = "ball"
        ball.xScale = 0.125
        ball.yScale = 0.125
        ball.lightingBitMask = 1
        ball.shadowedBitMask = 1
        ball.shadowCastBitMask = 1
        ball.position = CGPoint(x: -490, y: 100)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.height / 2)
        ball.physicsBody!.restitution = 0.99
        ball.physicsBody!.friction = 1
        ball.physicsBody!.linearDamping = 0.5
        ball.physicsBody!.categoryBitMask = collision.player.rawValue
        ball.physicsBody!.contactTestBitMask = collision.wall.rawValue + collision.enemy.rawValue
        ball.physicsBody!.collisionBitMask = collision.wall.rawValue
        mainSelf.addChild(ball)
        
        let progress = mainCamera.childNode(withName: "progress") as! SKSpriteNode
        progress.xScale = 0
        progress.run(SKAction.scaleX(to: 1, duration: currentLevel.time))
        
        /*
         obsArr.append(Obs(startPosition: CGPoint(x: 700,y: -200), h: 300))
         obsArr.append(Obs(startPosition: CGPoint(x: 800,y: -100), h: 300))
         obsArr.append(Obs(startPosition: CGPoint(x: 900,y: -200), h: 300))
         
         */
        //obsArr = obsStringToArr(obsString: "700,-200,300,1!800,-100,300,2")
        //obsArr = randomObs2(space: 100, num: 20)
        currentLevel.obs = obsStringToArr(obsString: currentLevel.obsString)
        
        for obs in currentLevel.obs{
            obsNode.addChild(obs.sprite)
        }
        
        obsNode.run(SKAction.move(to: CGPoint(x: -currentLevel.obs.last!.startPosition.x - 700, y: 0), duration: currentLevel.time   )) {
            self.finishLevel()
            
        }
        /*
         ball.run(SKAction.colorize(with: NSColor.red, colorBlendFactor: 1, duration: TimeInterval(redTime))) {
         let ezerPoint = CGPoint(x: ball.position.x / 2, y: ball.position.y / 2)
         self.gameover(zoomPoint: ezerPoint)
         }*/
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //print(contact.bodyA.node!.name! + " , " + contact.bodyB.node!.name!)
        if contact.bodyA.categoryBitMask == 1 || contact.bodyB.categoryBitMask == 1{
            var other = contact.bodyA
            if other.categoryBitMask == 1{
                other = contact.bodyB
            }
            switch other.categoryBitMask {
            case 2:
                //ball hit wall
                let wall = other.node!
                let particle = SKEmitterNode(fileNamed: "particle1.sks")
                if wall.name == "wallUp"{
                    particle?.emissionAngle = CGFloat(M_PI * 1.5)
                }
                particle?.zPosition = -1
                particle!.yAcceleration = scene!.physicsWorld.gravity.dy * 100
                particle!.position = contact.contactPoint
                particle!.run(SKAction.sequence([SKAction.wait(forDuration: 0.1),SKAction.run {
                    particle?.particleBirthRate = 0
                    },SKAction.wait(forDuration: 1),SKAction.run {
                        particle?.removeFromParent()
                    }]))
                addChild(particle!)
                particles.append(particle!)
                /*
                 ball.removeAllActions()
                 ball.run(SKAction.colorize(with: NSColor.red, colorBlendFactor: 1, duration: TimeInterval(redTime))) {
                 let ezerPoint = CGPoint(x: ball.position.x / 2, y: ball.position.y / 2)
                 self.gameover(zoomPoint: ezerPoint)
                 }*/
                
                break
            case 4:
                //ball hit obs
                let obs = other.node!
                obs.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),SKAction.colorize(with: UIColor.red, colorBlendFactor: 1, duration: 1)]))
                let ezerPoint = CGPoint(x: contact.contactPoint.x / 2, y: contact.contactPoint.y / 2)
                gameover(zoomPoint: ezerPoint)
                
                break
            default:
                print("ball hit something")
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let pos = touches.first!.location(in: self)
        playerTouch()
    }
    
    override func update(_ currentTime: TimeInterval) {
        //print(ball.position)
    }
    func levelComplete(){
        /*
         var lvlString : String = stages[stage].levelsString
         let strArr = lvlString.characters.split(separator: "#")
         var i = 0
         for lvlString in strArr{
         let at = String(lvlString)
         if i == level{
         
         }
         i += 1
         }
         */
    }
    func playerTouch(){
        if !gamestop{
            scene!.physicsWorld.gravity.dy = -scene!.physicsWorld.gravity.dy
            for particle in particles{
                particle.yAcceleration = scene!.physicsWorld.gravity.dy * 100
            }
        }else{
            moveToScene(name: "GameScene")
        }
    }
    func stopGame(){
        gamestop = true
        ball.physicsBody = nil
        
        scene!.physicsWorld.gravity.dy = 0
        mainCamera.childNode(withName: "progress")!.removeAllActions()
        
    }
    func gameover(zoomPoint: CGPoint){
        obsNode.removeAllActions()
        stopGame()
        mainCamera.run(SKAction.move(to: zoomPoint, duration: 2))
        mainCamera.run(SKAction.scale(to: 0.8 * scale, duration: 2))
    }
    func moveToScene(name : String){
        currentLevel.obs = obsStringToArr(obsString: currentLevel.obsString)
        let transition = SKTransition.push(with: SKTransitionDirection.right, duration: 0)
        
        let nextScene = GameScene(fileNamed: name)
        
        scene?.view?.presentScene(nextScene!, transition: transition)
    }
    func camerashake(times : Int, shakeamount : UInt32){
        mainCamera.run(SKAction.repeat(SKAction.sequence([SKAction.run({
            let xEzer = arc4random() % shakeamount
            let yEzer = arc4random() % shakeamount
            let randx = CGFloat(xEzer) - CGFloat(shakeamount) / 2 + mainCamera.position.x
            let randy = CGFloat(yEzer) - CGFloat(shakeamount) / 2  + mainCamera.position.y
            mainCamera.position = CGPoint(x: randx, y: randy)
        }),SKAction.wait(forDuration: 0.05)]), count: times))
    }
    func finishLevel(){
        var levelComplete = nsUser.value(forKey: "levelComplete") as! [[Int]]
        levelComplete[stage][level] = 1
        nsUser.setValue(levelComplete, forKey: "levelComplete")
        level = stages[stage].defaultLevel()
        self.moveToScene(name: "SelectLevel")
    }
    
}
