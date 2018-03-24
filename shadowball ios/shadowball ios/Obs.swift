//
//  Obs.swift
//  tiny game1
//
//  Created by ofer on 05/10/2016.
//  Copyright © 2016 ofertande. All rights reserved.
//

import SpriteKit

class Obs{
    var sprite : SKSpriteNode
    var startPosition : CGPoint
    var h : CGFloat
    var type : Int
    
    init(startPosition : CGPoint,h : CGFloat,type : Int) {
        self.startPosition = startPosition
        self.h = h
        self.type = type
        sprite = SKSpriteNode(color: mainLight.shadowColor, size: CGSize(width: 62, height: h))
        if type == 2{
            sprite.color = mainSelf.scene!.backgroundColor
        }
        sprite.name = "obs"
        sprite.zPosition = 10000
        sprite.position = startPosition
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody!.categoryBitMask = collision.enemy.rawValue
        sprite.physicsBody!.collisionBitMask = 0
        sprite.physicsBody!.contactTestBitMask = collision.player.rawValue
        sprite.physicsBody!.affectedByGravity = false
        sprite.physicsBody!.allowsRotation = false

    }
    init(str : String){
        print(str)
        let arr = str.characters.split(separator: ",")
        let at1 = CGFloat((String(arr[0]) as NSString).doubleValue)
        let at2 = CGFloat((String(arr[1]) as NSString).doubleValue)
        let at3 = CGFloat((String(arr[2]) as NSString).doubleValue)
        let at4 = Int((String(arr[3]) as NSString).intValue)
        let startPosition = CGPoint(x: at1, y: at2)
        let h = at3
        let type = at4
        
        
        self.startPosition = startPosition
        self.h = h
        self.type = type
        sprite = SKSpriteNode(color: mainLight.shadowColor, size: CGSize(width: 60, height: h))
        if type == 2{
            sprite.color = mainSelf.scene!.backgroundColor
        }
        sprite.name = "obs"
        sprite.zPosition = 10000
        sprite.position = startPosition
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        sprite.physicsBody!.categoryBitMask = collision.enemy.rawValue
        sprite.physicsBody!.collisionBitMask = 0
        sprite.physicsBody!.contactTestBitMask = collision.player.rawValue
        sprite.physicsBody!.affectedByGravity = false
        sprite.physicsBody!.allowsRotation = false

    }
    
}

func obsStringToArr(obsString : String) -> [Obs]{
    if obsString.characters.first != "r"{
        var obsArr : [Obs] = []
        let strArr = obsString.characters.split(separator: "!")
        for obsString in strArr{
            let at = String(obsString)
            obsArr.append(Obs(str: at))
        }
        return obsArr
    }else{
        var obsString2 = obsString
        obsString2 = String(obsString2.characters.dropFirst())
        print(obsString2)
        let arr = obsString2.characters.split(separator: ",")
        let at1 = Int((String(arr[0]) as NSString).intValue)
        let at2 = CGFloat((String(arr[1]) as NSString).doubleValue)
        let at3 = Int((String(arr[2]) as NSString).intValue)
        return randomObs(randomNum: at1, space: at2, num: at3)
    }
    
}
func randomObs(randomNum : Int, space : CGFloat, num : Int) -> [Obs]{
    var obsArr : [Obs] = []
    switch randomNum {
    case 1:
        for i in 0...num{
            let x = 700 + space * CGFloat(i)
            let h = CGFloat(arc4random() % (400 - 100)) + 100
            let yezer = 720 - UInt32(h)
            let y = CGFloat(arc4random() % yezer) - CGFloat(yezer)/2
            let type = Int(arc4random()%2) + 1
            obsArr.append(Obs(startPosition: CGPoint(x: x,y: y), h: h, type: type))
        }
    case 2:
        for i in 0...num{
            let x = 700 + space * CGFloat(i)
            let h = CGFloat(arc4random() % (300 - 60)) + 60
            let y = 360 - h/2
            let type = Int(arc4random()%2) + 1
            print(y)
            obsArr.append(Obs(startPosition: CGPoint(x: x,y: y), h: h, type: type))
            let h2 = CGFloat(arc4random() % (300 - 60)) + 60
            let y2 = h2/2 - 360
            obsArr.append(Obs(startPosition: CGPoint(x: x,y: y2), h: h2, type: type))
        }
    case 3:
        var startx : CGFloat = 700
        var type = Int(arc4random()%2) + 1
        for i in 0...num{
            let numx = Int(arc4random() % 20) + 5
            let ezery = 720 - UInt32(space) - 60
            let rndy = CGFloat(arc4random()%ezery) + 60
            let rndy2 = 720 - space - rndy
            for x in 0...numx{
                obsArr.append((Obs(startPosition: CGPoint(x: startx + CGFloat(x) * 60, y: rndy/2 - 360), h: rndy, type: type)))
                obsArr.append((Obs(startPosition: CGPoint(x: startx + CGFloat(x) * 60, y: -rndy2/2 + 360), h: rndy2, type: type)))
            }
            if type == 1{
                type = 2
            }else{
                type = 1
            }
            startx += 1000 + 60 * CGFloat(numx)
        }
    default:
        print("error")
    }
    return obsArr
}

