//
//  GameScene.swift
//  tiny game1
//
//  Created by ofer on 04/10/2016.
//  Copyright © 2016 ofertande. All rights reserved.
//

import SpriteKit

var stage : Int = 0
class SelectStage: SKScene, SKPhysicsContactDelegate {
    
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
        ball.position = CGPoint(x: -330, y: lastY)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.height / 2)
        ball.physicsBody!.velocity = lastVelocity
        ball.physicsBody!.restitution = 0.99
        ball.physicsBody!.friction = 0
        ball.physicsBody!.linearDamping = 0
        ball.physicsBody!.categoryBitMask = collision.player.rawValue
        ball.physicsBody!.contactTestBitMask = collision.wall.rawValue + collision.enemy.rawValue
        ball.physicsBody!.collisionBitMask = collision.wall.rawValue
        mainSelf.addChild(ball)
        
        reload()
        
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
        if pos.x > 0 && pos.y < -200{
            moveToScene(name: "SelectLevel")
        }
    }
    
    /*
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x31:
            moveToScene(name: "SelectLevel")
        case 124:
            if stage != stages.count - 1{
                stage += 1
                reload()
            }
        case 123:
            if stage != 0{
                stage -= 1
                reload()
            }
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }*/
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    
    func moveToScene(name : String){
        currentLevel = stages[stage].levels[0]
        let transition = SKTransition.crossFade(withDuration: 0)
        
        let nextScene = GameScene(fileNamed: name)
        
        scene?.view?.presentScene(nextScene!, transition: transition)
    }
    func reload(){
        let lblPrecent = childNode(withName: "lblPrecent") as! SKLabelNode
        let stagePrecent = stages[stage].stagePrecent()
        lblPrecent.fontColor = precentColor(precent: stagePrecent)
        let precentEzer = Int(stagePrecent * CGFloat(100))
        lblPrecent.text = String(describing: precentEzer) + "%"
        let lblTitle = childNode(withName: "lblTitle") as! SKLabelNode
        lblTitle.text = String(stage + 1) + ": " + stages[stage].name
        let backButton = childNode(withName: "backButton")!
        let nextButton = childNode(withName: "nextButton")!
        if stage == 0{
            backButton.alpha = 0.38
        }else{
            backButton.alpha = 1
        }
        if stage == stages.count - 1{
            nextButton.alpha = 0.38
        }else{
            nextButton.alpha = 1
        }

    }
}
func precentColor(precent : CGFloat) -> UIColor{
    return UIColor(white: 0.1 + precent * 0.9, alpha: 1)
}

