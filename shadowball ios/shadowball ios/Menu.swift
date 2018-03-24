//
//  GameScene.swift
//  tiny game1
//
//  Created by ofer on 04/10/2016.
//  Copyright © 2016 ofertande. All rights reserved.
//

import SpriteKit

var scale : CGFloat = 1.74
var lastVelocity : CGVector = CGVector(dx: 0, dy: 0)
var lastY : CGFloat = 100
let nsUser = UserDefaults.standard
class Menu: SKScene, SKPhysicsContactDelegate {
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        mainSelf = self
        NSUserSetup()
        setupScale()
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
        ball.position = CGPoint(x: -490, y: 100)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.frame.height / 2)
        ball.physicsBody!.restitution = 0.99
        ball.physicsBody!.friction = 0
        ball.physicsBody!.linearDamping = 0
        ball.physicsBody!.categoryBitMask = collision.player.rawValue
        ball.physicsBody!.contactTestBitMask = collision.wall.rawValue + collision.enemy.rawValue
        ball.physicsBody!.collisionBitMask = collision.wall.rawValue
        mainSelf.addChild(ball)
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
        if pos.y < -100{
            if pos.x > -200 && pos.x < 200{
                moveToScene(name: "SelectStage")
            }
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    func NSUserSetup(){
        let levelComplete = nsUser.value(forKey: "levelComplete")
        //nsUser.setValue(nil, forKey: "levelComplete")
        if levelComplete == nil{
            var levelComplete2 : [[Int]] = []
            for stageNum in 0...stages.count-1{
                var arr1 : [Int] = []
                for _ in 0...stages[stageNum].levels.count{
                    arr1.append(0)
                }
                levelComplete2.append(arr1)
            }
            nsUser.setValue(levelComplete2, forKey: "levelComplete")
        }
        print(nsUser.value(forKey: "levelComplete"))
        //let levelComplete : [[Int]] = []
    }
    func moveToScene(name : String){
        lastVelocity = ball.physicsBody!.velocity
        lastY = ball.position.y
        let transition = SKTransition.crossFade(withDuration: 0)
        
        let nextScene = GameScene(fileNamed: name)
        
        scene?.view?.presentScene(nextScene!, transition: transition)
    }
}
func setupScale(){
    //plus 1.74
    //regular 1.92
    //se 2.24
    switch UIScreen.main.bounds.width {
    case 568:
        scale = 2.24
    case 667:
        scale = 1.92
    case 736:
        scale = 1.74
    default:
        print("not known screen size")
    }
}
func setupCamera(camera: SKCameraNode){
    camera.xScale = scale
    camera.yScale = scale
}
