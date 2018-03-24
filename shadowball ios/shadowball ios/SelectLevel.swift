//
//  GameScene.swift
//  tiny game1
//
//  Created by ofer on 04/10/2016.
//  Copyright © 2016 ofertande. All rights reserved.
//

import SpriteKit

var level : Int = 0

class SelectLevel: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        mainSelf = self
        mainLight = childNode(withName: "mainLight") as! SKLightNode
        mainCamera = childNode(withName: "mainCamera") as! SKCameraNode
        setupCamera(camera: mainCamera)
        
        ball = SKSpriteNode(imageNamed: "circle-512.png")
        ball.name = "ball"
        ball.xScale = 0.125
        ball.yScale = 0.125
        ball.lightingBitMask = 1
        ball.shadowedBitMask = 1
        ball.shadowCastBitMask = 1
        ball.position = CGPoint(x: -550, y: 300)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.height / 2)
        ball.physicsBody!.restitution = 0.99
        ball.physicsBody!.friction = 0
        ball.physicsBody!.linearDamping = 0
        ball.physicsBody!.categoryBitMask = collision.player.rawValue
        ball.physicsBody!.contactTestBitMask = collision.wall.rawValue + collision.enemy.rawValue
        ball.physicsBody!.collisionBitMask = collision.wall.rawValue
        mainSelf.addChild(ball)
        
        levelRect()
    }
    func didBegin(_ contact: SKPhysicsContact) {
        let particle = SKEmitterNode(fileNamed: "particle1.sks")
        particle!.zPosition = -1
        particle!.yAcceleration = scene!.physicsWorld.gravity.dy * 100
        particle!.position = contact.contactPoint
        particle!.run(SKAction.sequence([SKAction.wait(forDuration: 0.1),SKAction.run {
            particle?.particleBirthRate = 0
            },SKAction.wait(forDuration: 1),SKAction.run {
                particle?.removeFromParent()
            }]))
        addChild(particle!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let pos = touches.first!.location(in: self)
        if pos.y < -200{
            if pos.x > 0 && pos.x < 500{
                moveToGameScene()
            }
        }else{
            var newLevel = 0
            for i in 0...9{
                if pos.x > -489 + 122 * CGFloat(i){
                    newLevel = i + 1
                }
            }
            let levelRects = childNode(withName: "levelRects")!
            let oldRect = levelRects.childNode(withName: "levelRect" + String(level+1)) as! SKSpriteNode
            let newRect = levelRects.childNode(withName: "levelRect" + String(newLevel + 1)) as! SKSpriteNode
            if stages[stage].levelsComplete()[level] == 1{
                oldRect.color = mainLight.shadowColor
            }else{
                oldRect.color = scene!.backgroundColor
            }
            newRect.color = UIColor(white: 0.72, alpha: 1)
            moveLevel(newLevel: newLevel)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func moveLevel(newLevel : Int){
        let timeEzer = 0.5 + CGFloat(abs(newLevel - level)) / 10
        level = newLevel
        let act = SKAction.moveTo(x: -550 + CGFloat(level) * 122, duration: TimeInterval(timeEzer))
        act.timingMode = SKActionTimingMode.easeInEaseOut
        ball.run(act)
    }
    func moveToGameScene(){
        currentLevel = stages[stage].levels[level]
        lastVelocity = ball.physicsBody!.velocity
        lastY = ball.position.y
        let transition = SKTransition.crossFade(withDuration: 0)
        
        let nextScene = GameScene(fileNamed: "GameScene")
        
        scene?.view?.presentScene(nextScene!, transition: transition)
    }
    func levelRect(){
        var i = 1
        let mainLight = childNode(withName: "mainLight") as! SKLightNode
        let levelRects = childNode(withName: "levelRects")!
        let levelsComplete = stages[stage].levelsComplete()
        for lvl in stages[stage].levels{
            let rect = levelRects.childNode(withName: "levelRect" + String(i)) as! SKSpriteNode
            if levelsComplete[i-1] == 1{
                rect.color = mainLight.shadowColor
            }
            /*else if level == 0{
                level = i - 1
                rect.color = NSColor(white: 0.72, alpha: 1)
            }*/
            i += 1
        }
        if level == 0{
            let rect = levelRects.childNode(withName: "levelRect1") as! SKSpriteNode
            rect.color = UIColor(white: 0.72, alpha: 1)
        }
        ball = childNode(withName: "ball") as! SKSpriteNode
        ball.position.x = -550 + CGFloat(level) * 122
    }
}
