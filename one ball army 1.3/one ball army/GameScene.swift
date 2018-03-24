//
//  GameScene.swift
//  one ball army
//
//  Created by Rotem Israeli on 23/01/15.
//  Copyright (c) 2015 Rotem Israeli. All rights reserved.
//
import UIKit
import SpriteKit


extension String {
    subscript (i: Int) -> String {
        return String(Array(self)[i])
    }
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    enum bodytype : UInt32 {
        case player = 1
        case wall = 2
        case shoot = 4
        case enemy1 = 8
        case enemy2 = 16
        case enemy3 = 32
        case powershild = 64
    }
    enum deltapowerprice : Int {
        case shild = 13
        case fastshooting = 3
        case playercontrol = 4
        case power4 = 17
    }
    enum firstpowerprice : Int{
        case shild = 10
        case fastshooting = 5
        case playercontrol = 4
        case power4 = 8
    }
    func teleporttimerezer(){}
    var ringendangle : [CGFloat] = [0,0,0,0]
    var powerplayercontrolbool = false
    var powerfastshootingbool = false
    var powershildactive = false
    var powershildbool = false
    var inanimation = false
    var inselectlevelpage = false
    var inbuystore = false
    var canremovebuystore = false
    var buystorepage : Int =  -1
    var page : Int = 1;
    var inshop = false
    var needwaitsec = false
    var gameoverbool = false
    var cansendcircle = true
    var diecount = 0
    var shootspeed = 20
    var numshootspeed = 20
    var nummovespeed : Float = 1
    var enemies1 = Array<String>()
    var enemies2 = Array<String>()
    var enemies3 = Array<String>()
    var shoots1 = Array<String>()
    var numname = 0
    var pos : CGPoint = CGPoint(x:  640 / 2, y:  1136 / 2)
    let shootspeedprice : [Int] = [10,30,70,120,180,270,370,490,600,1000]
    let movespeedprice : [Int] = [8,20,50,100,150,220,300,450,580,800]
    var touchstore = false
    var smart : Int = 1
    var smarttitle : [String] = ["Stay in place and shoot.","Very smart movement", ""]
    var smarttitle2 : [String] = ["" , "escapes fast from close enemies." , ""]
    var smartprice : [Int] = [0 , 100 , 1000]
    var powerprice : [Int] = [10 , 5 , 4 , 8]
    var nearenemyname : String = "player"
    var didcallteletimer = false
    var didcallshootingtimer = false
    var didcallroundtimer = false
    var theroundtimer = NSTimer()
    var playercontroltimer = NSTimer()
    var rechargepowertimer = NSTimer()
    var roundrnd = 1
    var roundcount = 1
    var powercash : Int = 0
    var swipepower : Int = -1
    var beforexp : Int = 0
    var beforelevel : Int = 1
    // level info : enemy1, enemy2, circle1, circle2
    let level1info : [UInt32] = [50,50,8,8]
    let level2info : [UInt32] = [6,6,20,20]
    let pi : CGFloat = 3.1415926535
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if ( !gameoverbool && !inshop){
        if (contact.bodyA.node != nil && contact.bodyB.node != nil){
        let bodya = contact.bodyA.node!
        let bodyb = contact.bodyB.node!
        //shoot
        if (bodya.name![0] == "s" && bodya.name![1] == "h" && bodya.name![2] == "o" || bodyb.name![0] == "s" && bodyb.name![1] == "h" && bodyb.name![2] == "o" ){
            var otherbody = bodya
            if (bodya.name![0] == "s" && bodya.name![1] == "h" && bodya.name![2] == "o"){
                
                var index = 0
                    for shoot in shoots1{
                        if (shoot == bodya.name!){
                            shoots1.removeAtIndex(index)
                        }
                        index++
                    }
                (bodya.removeFromParent())
                otherbody = bodyb
            }
            else{
                var index1 = 0
                for shoot in shoots1{
                    if (shoot == bodyb.name!){
                        shoots1.removeAtIndex(index1)
                    }
                    index1++
                }
                bodyb.removeFromParent()
            }
            //shoot collide enemy
            if (otherbody.name![0] == "e" && otherbody.name![1] == "n" && otherbody.name![2] == "e"){
                var index = 0
                if (otherbody.name![5] == "1"){
                    expenemy(otherbody.name!, enemytype: 1)
                }
                else if (otherbody.name![5] == "2"){
                    for enemy in enemies2{
                        if (enemy == otherbody.name!){
                            if (otherbody.frame.width > 40){
                                otherbody.runAction(SKAction.scaleTo(otherbody.xScale - 0.04148230125, duration: 0.1))
                                let theenemy = otherbody as! SKSpriteNode
                                let theciimg = CIImage(image: UIImage(named: "enemy2 - one ball army.png"))
                                let thefilter = CIFilter(name: "CISepiaTone")
                                thefilter.setValue(thefilter, forKey: kCIInputIntensityKey)
                                let newimg = UIImage(CIImage: thefilter.outputImage)
                                theenemy.texture = SKTexture(image: newimg!)
                                
                            }
                            else{
                                expenemy(otherbody.name!, enemytype: 2)
                            }
                            
                        }
                        index++
                    }
                }
                else{
                    
                }
                let cash : Int = NSUserDefaults.standardUserDefaults().objectForKey("cash") as! Int
                NSUserDefaults.standardUserDefaults().setObject(cash + 1, forKey: "cash")
                let lblcash = childNodeWithName("lblcash") as! SKLabelNode
                let cash2 : Int = NSUserDefaults.standardUserDefaults().objectForKey("cash") as! Int
                lblcash.text = String(cash)
                powercash++
                let lblpowercash = childNodeWithName("lblpowercash") as! SKLabelNode
                lblpowercash.text = String(powercash)
                let xp : Int = NSUserDefaults.standardUserDefaults().objectForKey("xp") as! Int
                NSUserDefaults.standardUserDefaults().setObject(xp + 1, forKey: "xp")

            }
            }
            //player
            if (bodya.name! == "player" || bodyb.name! == "player" ){
                var otherbody = bodya
                if (bodya.name! == "player"){
                    otherbody = bodyb
                }
                //player collide enemy
                if (otherbody.name![0] == "e" && otherbody.name![1] == "n" && otherbody.name![2] == "e"){
                    
                    //timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("gameover"), userInfo: nil, repeats: false)
                    stopgame()
                    
                }
            }
            //wall
            if (bodya.name! == "leftwall" || bodya.name! == "rightwall" || bodya.name! == "upwall" || bodya.name! == "downwall" || bodyb.name! == "leftwall" || bodyb.name! == "rightwall" || bodyb.name! == "upwall" || bodyb.name! == "downwall"){
                var otherbody = bodya
                if (bodya.name! == "leftwall" || bodya.name! == "rightwall" || bodya.name! == "upwall" || bodya.name! == "downwall"){
                    otherbody = bodyb
                }
                var index = 0
                if (otherbody.name![0] == "e" && otherbody.name![1] == "n" && otherbody.name![2] == "e" && otherbody.name![3] == "m" && otherbody.name![4] == "y" && otherbody.name![5] == "2"){
                    for enemy in enemies2{
                        if (enemy == otherbody.name!){
                            enemies2.removeAtIndex(index)
                        }
                        index++
                    }
                    otherbody.removeFromParent()
                }
            }
            if (bodya.name! == "shild" || bodyb.name! == "shild"){
                //if (powershildbool){
                    let shild = childNodeWithName("shild")
                    var theenemy = childNodeWithName(bodya.name!)
                    if (bodya.name! == "shild"){
                        theenemy = childNodeWithName(bodyb.name!)
                    }
                    if (theenemy!.name![5] == "2"){
                        expenemy(theenemy!.name!, enemytype: 2)
                    }
                    else if (theenemy!.name![5] == "1"){
                        expenemy(theenemy!.name!, enemytype: 1)
                    }
               // }
                shildexp()

                
            }
        
        }
        }
    }
    
    override func didMoveToView(view: SKView) {
        physicsWorld.contactDelegate = self
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "shootspeed")
        if (NSUserDefaults.standardUserDefaults().objectForKey("shootspeed") == nil){
            let cash : Int = 0 as Int
            NSUserDefaults.standardUserDefaults().setObject(cash, forKey: "cash")
            let shootspeed : Int = 0 as Int
            NSUserDefaults.standardUserDefaults().setObject(shootspeed, forKey: "shootspeed")
            let barakarr : [Int] = [20,20,20]
            NSUserDefaults.standardUserDefaults().setObject(barakarr, forKey: "barakarr")
            let timefrombarak : NSDate = NSDate()
            NSUserDefaults.standardUserDefaults().setObject(timefrombarak, forKey: "timefrombarak")
            let movespeed : Int = 0 as Int
            NSUserDefaults.standardUserDefaults().setObject(shootspeed, forKey: "movespeed")
            let selectedsmart : Int = 1 as Int
            NSUserDefaults.standardUserDefaults().setObject(selectedsmart, forKey: "selectedsmart")
            let smartarr : [Int] = [1,-1,-1]
            NSUserDefaults.standardUserDefaults().setObject(smartarr, forKey: "smartarr")
            let unlockpower : [String] = ["fastshooting","playercontrol"]
            NSUserDefaults.standardUserDefaults().setObject(unlockpower, forKey: "unlockpower")
            let touchalert : Bool = true
            NSUserDefaults.standardUserDefaults().setObject(touchalert, forKey: "touchalert")
            let selectedpower : [String] = ["shild","fastshooting","nil","nil","nil","nil","nil","nil","nil","nil","nil","nil","nil","nil"]
            NSUserDefaults.standardUserDefaults().setObject(selectedpower, forKey: "selectedpower")
            let level : Int = 1 as Int
            NSUserDefaults.standardUserDefaults().setObject(level, forKey: "level")
            let xp : Int = 0 as Int
            NSUserDefaults.standardUserDefaults().setObject(xp, forKey: "xp")
            let levelselected : Int = 1
            NSUserDefaults.standardUserDefaults().setObject(levelselected, forKey: "levelselected")
        }
        /* Setup your scene here */
        let lblcash = SKLabelNode(text: "0")
        lblcash.position.x = 20
        lblcash.position.y =  self.view!.bounds.height * 2  - 46
        lblcash.name = "lblcash"
        lblcash.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        lblcash.fontColor = UIColor.blackColor()
        self.addChild(lblcash)
        
        smart = NSUserDefaults.standardUserDefaults().valueForKey("selectedsmart") as! Int
        
            let lblcash2 = childNodeWithName("lblcash") as! SKLabelNode
            let cash : Int = NSUserDefaults.standardUserDefaults().objectForKey("cash") as! Int
            lblcash2.text = String(cash)
        
        self.childNodeWithName("levelframe")?.zPosition = -100
        self.childNodeWithName("xpframe")?.zPosition = -90
        self.childNodeWithName("lbllevel")?.zPosition = -95
        self.childNodeWithName("xprect")?.zPosition = -92
        
        let barakimg = SKSpriteNode(imageNamed: "lightning-icon")
        barakimg.physicsBody = nil
        barakimg.position.x = lblcash.position.x + lblcash.xScale / 2 + 150
        barakimg.position.y = lblcash.position.y + 12
        barakimg.xScale *= 0.17
        barakimg.yScale *= 0.17
        barakimg.name = "barakimg"
        self.addChild(barakimg)
        
        let barakarr = NSUserDefaults.standardUserDefaults().valueForKey("barakarr") as! [Int]
        let selectedsmart = NSUserDefaults.standardUserDefaults().valueForKey("selectedsmart") as! Int
        let lblbarak = SKLabelNode(fontNamed: "Verdana")
        lblbarak.text = String(barakarr[selectedsmart - 1]) + "/30"
        lblbarak.position.x = barakimg.position.x + 25
        lblbarak.position.y = lblcash.position.y
        lblbarak.name = "lblbarak"
        lblbarak.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        lblbarak.fontColor = UIColor.yellowColor()
        self.addChild(lblbarak)
        
        gotostore(1)
        
        
        
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent){
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let player = childNodeWithName("player")
            if (gameoverbool && inshop && !inanimation && page == 3 && !inselectlevelpage){
                let framepower1 = childNodeWithName("framepower1")
                let framepower2 = childNodeWithName("framepower2")
                let framepower3 = childNodeWithName("framepower3")
                let framepower4 = childNodeWithName("framepower4")
                let framepower5 = childNodeWithName("framepower5")
                let framepower6 = childNodeWithName("framepower6")
                let framepower7 = childNodeWithName("framepower7")
                let framepower8 = childNodeWithName("framepower8")
                let framepower9 = childNodeWithName("framepower9")
                let framepower10 = childNodeWithName("framepower10")
                let framepower11 = childNodeWithName("framepower11")
                let framepower12 = childNodeWithName("framepower12")
                let framepower13 = childNodeWithName("framepower13")
                let framepower14 = childNodeWithName("framepower14")
                if (CGRectContainsPoint(framepower1!.frame, location)){
                    swipepower = 1
                }else if (CGRectContainsPoint(framepower2!.frame, location)){
                    swipepower = 2
                }else if (CGRectContainsPoint(framepower3!.frame, location)){
                    swipepower = 3
                }else if (CGRectContainsPoint(framepower4!.frame, location)){
                    swipepower = 4
                }else if (CGRectContainsPoint(framepower5!.frame, location)){
                    swipepower = 5
                }else if (CGRectContainsPoint(framepower6!.frame, location)){
                    swipepower = 6
                }else if (CGRectContainsPoint(framepower7!.frame, location)){
                    swipepower = 7
                }else if (CGRectContainsPoint(framepower8!.frame, location)){
                    swipepower = 8
                }else if (CGRectContainsPoint(framepower9!.frame, location)){
                    swipepower = 9
                }else if (CGRectContainsPoint(framepower10!.frame, location)){
                    swipepower = 10
                }else if (CGRectContainsPoint(framepower11!.frame, location)){
                    swipepower = 11
                }else if (CGRectContainsPoint(framepower12!.frame, location)){
                    swipepower = 12
                }else if (CGRectContainsPoint(framepower13!.frame, location)){
                    swipepower = 13
                }else if (CGRectContainsPoint(framepower14!.frame, location)){
                    swipepower = 14
                }
            }else if powerplayercontrolbool && player != nil{
                var fixedloc = location
                if location.y > 135{
                    player?.runAction(SKAction.moveTo(fixedloc, duration: 0.1))
                }
                
            }
        }
    }
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent){
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let player = childNodeWithName("player")
            if (gameoverbool && inshop && !inanimation && page == 3){
                if swipepower != -1{
                    let selectedpower = NSUserDefaults.standardUserDefaults().valueForKey("selectedpower") as! [String]
                    if (selectedpower[swipepower - 1] != "nil"){
                    let swipeimg = childNodeWithName("imgpower" + String(swipepower))
                    swipeimg?.position = location
                    }
                }
            }else if powerplayercontrolbool && player != nil{
                var fixedloc = location
                if location.y < 135{
                    fixedloc.y = 135
                }
                player?.runAction(SKAction.moveTo(fixedloc, duration: 0.1))
            }
        }
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if inbuystore{
                let lblbuycoins = childNodeWithName("lblbuycoins")
                let lblbuyenergy = childNodeWithName("lblbuyenergy")
                let lblbuypacks = childNodeWithName("lblbuypacks")
                if canremovebuystore {
                    let buystoreframe = childNodeWithName("buystoreframe")
                    var exitrect = childNodeWithName("exitbuystore")!.frame
                    if (CGRectContainsPoint(lblbuycoins!.frame, location)){
                        movebuypage(1)
                    }else if (CGRectContainsPoint(lblbuyenergy!.frame, location)){
                        movebuypage(2)
                    }else if (CGRectContainsPoint(lblbuypacks!.frame, location)){
                        movebuypage(3)
                    }else if location.y <  self.view!.bounds.height * 2  / 2 - buystoreframe!.frame.height / 2 || location.y >  self.view!.bounds.height * 2  / 2 + buystoreframe!.frame.height / 2 || CGRectContainsPoint(exitrect, location){
                        removebuystorekoteret()
                    }
                }
            }
            else if (!gameoverbool && !inshop && !inanimation && !touchstore && !inselectlevelpage){
                let framepower1 = childNodeWithName("framepower1")
                let framepower2 = childNodeWithName("framepower2")
                let framepower3 = childNodeWithName("framepower3")
                let framepower4 = childNodeWithName("framepower4")
                if (CGRectContainsPoint(framepower1!.frame, location)){
                    touchpower(1)
                }
                else if (CGRectContainsPoint(framepower2!.frame, location)){
                    touchpower(2)
                }
                else if (CGRectContainsPoint(framepower3!.frame, location)){
                    touchpower(3)
                }
                else if (CGRectContainsPoint(framepower4!.frame, location)){
                    touchpower(4)
                }
            }
            else if (gameoverbool && !inshop && !inanimation && !touchstore && !inselectlevelpage){
                let retry = childNodeWithName("retry")
                let store = childNodeWithName("store")
                
                if (CGRectContainsPoint(retry!.frame, location) || CGRectContainsPoint(store!.frame, location)){
                    if (CGRectContainsPoint(retry!.frame, location)){
                        let selectedsmart = NSUserDefaults.standardUserDefaults().valueForKey("selectedsmart") as! Int
                        let barakarr = NSUserDefaults.standardUserDefaults().valueForKey("barakarr") as! [Int]
                        if barakarr[selectedsmart - 1] > 0{
                            var newbarakarr = barakarr
                            newbarakarr[selectedsmart - 1] -= 1
                            NSUserDefaults.standardUserDefaults().setValue(newbarakarr , forKey: "barakarr")
                        self.beforelevel = NSUserDefaults.standardUserDefaults().valueForKey("level") as! Int
                        self.beforexp = NSUserDefaults.standardUserDefaults().valueForKey("xp") as! Int
                        retry?.runAction(SKAction.rotateToAngle(-5, duration: 0.3))
                        retry?.runAction(SKAction.scaleBy(0.1, duration: 0.3), completion: { () -> Void in
                            retry!.removeFromParent()
                        })
                        let alert = childNodeWithName("alert")
                        alert?.runAction(SKAction.rotateToAngle(-5, duration: 0.3))
                        alert?.runAction(SKAction.scaleBy(0.1, duration: 0.3), completion: { () -> Void in
                            alert!.removeFromParent()
                        })
                        let player = childNodeWithName("player")
                        player?.physicsBody?.dynamic = true
                        resetpower()
                        /*if (player? != nil){
                        needwaitsec = true
                        }
                        player?.runAction(SKAction.moveTo(CGPoint(x:  self.view!.bounds.width * 2 / 2, y: 500), duration: 1), completion: { () -> Void in
                        self.needwaitsec = false
                        })*/
                        childNodeWithName("levelframe")?.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
                        childNodeWithName("xpframe")?.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
                        childNodeWithName("lbllevel")?.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
                        childNodeWithName("xprect")?.runAction(SKAction.fadeAlphaTo(0, duration: 0.5))
                        let black = childNodeWithName("black")
                        black?.removeFromParent()
                        gameoverbool = false
                        store!.runAction(SKAction.fadeAlphaTo(0, duration: 0.5), completion: { () -> Void in
                            self.childNodeWithName("store")!.removeFromParent()
                            self.childNodeWithName("levelframe")?.removeFromParent()
                            self.childNodeWithName("xpframe")?.removeFromParent()
                            self.childNodeWithName("lbllevel")?.removeFromParent()
                            self.childNodeWithName("xprect")?.removeFromParent()
                        })
                        }else{
                            addbuystorekoteret(2)
                        }
                    }else{
                            touchstore = true
                            store?.runAction(SKAction.rotateByAngle(-0.5, duration: 0.5))
                            store?.runAction(SKAction.moveToX(-100, duration: 1), completion: { () -> Void in
                                self.childNodeWithName("store")!.removeFromParent()
                            })
                            self.childNodeWithName("retry")!.runAction(SKAction.fadeAlphaTo(0, duration: 1), completion: { () -> Void in
                                self.childNodeWithName("retry")!.removeFromParent()
                            })
                            self.childNodeWithName("alert")?.runAction(SKAction.fadeAlphaTo(0, duration: 1))
                            let black = childNodeWithName("black")
                            self.childNodeWithName("levelframe")?.zPosition = -100
                            self.childNodeWithName("xpframe")?.zPosition = -90
                            self.childNodeWithName("lbllevel")?.zPosition = -95
                            self.childNodeWithName("xprect")?.zPosition = -92
                            self.theroundtimer.invalidate()
                            black?.runAction(SKAction.fadeAlphaTo(1, duration: 1), completion: { () -> Void in
                                if (self.childNodeWithName("alert") != nil){
                                    self.gotostore(1)
                                }else{
                                    self.gotostore(1)
                                }
                                self.removegameend()
                                var blackcount = 0
                                while self.childNodeWithName("black") != nil{
                                    blackcount++
                                    black?.removeFromParent()
                                    if blackcount > 20{
                                        self.removeAllChildren()
                                    }
                                }
                                self.addblack(1)
                                self.childNodeWithName("black")!.runAction(SKAction.fadeAlphaTo(0, duration: 0.5), completion: { () -> Void in
                                    self.childNodeWithName("black")!.removeFromParent()
                                    self.inshop = true
                                })
                            })
                    }
                    
                    for enemyname in enemies1{
                        var enemy = childNodeWithName(enemyname)
                        enemy?.runAction(SKAction.fadeAlphaTo(0, duration: 0.4), completion: { () -> Void in
                            self.removeFromParent()
                        })
                        
                    }
                    enemies1.removeAll(keepCapacity: false)
                    for enemyname in enemies2{
                        var enemy = childNodeWithName(enemyname)
                        enemy?.runAction(SKAction.fadeAlphaTo(0, duration: 0.4), completion: { () -> Void in
                            self.removeFromParent()
                        })
                        
                        
                    }
                    enemies2.removeAll(keepCapacity: false)
                    for shootname in shoots1{
                        let shoot = childNodeWithName(shootname)
                        shoot?.runAction(SKAction.fadeAlphaTo(0, duration: 0.4), completion: { () -> Void in
                            self.removeFromParent()
                        })
                        
                    }
                    shoots1.removeAll(keepCapacity: false)
                }
            }
            else if inselectlevelpage{
                let levelimg1 = childNodeWithName("levelimg1") as! SKSpriteNode
                let levelimg2 = childNodeWithName("levelimg2") as! SKSpriteNode
                let lblplay = childNodeWithName("lblplay")
                if CGRectContainsPoint(levelimg1.frame, location){
                    NSUserDefaults.standardUserDefaults().setValue(1, forKey: "levelselected")
                    levelimg1.texture = SKTexture(imageNamed: "level1 selected")
                    levelimg2.texture = SKTexture(imageNamed: "level1")
                }
                else if CGRectContainsPoint(levelimg2.frame, location){
                    NSUserDefaults.standardUserDefaults().setValue(2, forKey: "levelselected")
                    levelimg2.texture = SKTexture(imageNamed: "level1 selected")
                    levelimg1.texture = SKTexture(imageNamed: "level1")
                }
                else if CGRectContainsPoint(lblplay!.frame, location){
                    addblack(0)
                    let black = childNodeWithName("black")
                    black!.runAction(SKAction.fadeAlphaTo(1, duration: 1), completion: { () -> Void in
                        self.removeselectlevelpage()
                        self.addgamenodes()
                        black!.runAction(SKAction.fadeAlphaTo(0, duration: 0.5), completion: { () -> Void in
                            black!.removeFromParent()
                        })
                    })
                }
            }
            else if (inshop){
                let barakarr = NSUserDefaults.standardUserDefaults().valueForKey("barakarr") as! [Int]
                
                let lblselectlevel = childNodeWithName("lblselectlevel")
                let frameshootspeed = childNodeWithName("frameshootspeed")
                let framemovespeed = childNodeWithName("framemovespeed")
                let resetgame = childNodeWithName("resetgame")
                let lblnextsmart = childNodeWithName("lblnextsmart")
                let lblbeforesmart = childNodeWithName("lblbeforesmart")
                let lblselectbuy = childNodeWithName("lblselectbuy")
                let lblupgrade = childNodeWithName("frameupgrade")
                let lblselectball = childNodeWithName("frameselectball")
                let lblselectpowerapps = childNodeWithName("frameselectpowerapps")
                
                if (page == 3 && swipepower != -1){
                    var swipeto : Int = -1
                    let framepower1 = childNodeWithName("framepower1")
                    let framepower2 = childNodeWithName("framepower2")
                    let framepower3 = childNodeWithName("framepower3")
                    let framepower4 = childNodeWithName("framepower4")
                    let framepower5 = childNodeWithName("framepower5")
                    let framepower6 = childNodeWithName("framepower6")
                    let framepower7 = childNodeWithName("framepower7")
                    let framepower8 = childNodeWithName("framepower8")
                    let framepower9 = childNodeWithName("framepower9")
                    let framepower10 = childNodeWithName("framepower10")
                    let framepower11 = childNodeWithName("framepower11")
                    let framepower12 = childNodeWithName("framepower12")
                    let framepower13 = childNodeWithName("framepower13")
                    let framepower14 = childNodeWithName("framepower14")
                    if (CGRectContainsPoint(framepower1!.frame, location)){
                        swipeto = 1
                    }else if (CGRectContainsPoint(framepower2!.frame, location)){
                        swipeto = 2
                    }else if (CGRectContainsPoint(framepower3!.frame, location)){
                        swipeto = 3
                    }else if (CGRectContainsPoint(framepower4!.frame, location)){
                        swipeto = 4
                    }else if (CGRectContainsPoint(framepower5!.frame, location)){
                        swipeto = 5
                    }else if (CGRectContainsPoint(framepower6!.frame, location)){
                        swipeto = 6
                    }else if (CGRectContainsPoint(framepower7!.frame, location)){
                        swipeto = 7
                    }else if (CGRectContainsPoint(framepower8!.frame, location)){
                        swipeto = 8
                    }else if (CGRectContainsPoint(framepower9!.frame, location)){
                        swipeto = 9
                    }else if (CGRectContainsPoint(framepower10!.frame, location)){
                        swipeto = 10
                    }else if (CGRectContainsPoint(framepower11!.frame, location)){
                        swipeto = 11
                    }else if (CGRectContainsPoint(framepower12!.frame, location)){
                        swipeto = 12
                    }else if (CGRectContainsPoint(framepower13!.frame, location)){
                        swipeto = 13
                    }else if (CGRectContainsPoint(framepower14!.frame, location)){
                        swipeto = 14
                    }
                    var selectedpower = NSUserDefaults.standardUserDefaults().valueForKey("selectedpower") as! [String]
                    let frompower = selectedpower[swipepower - 1]
                    if swipeto != -1{
                        let topower = selectedpower[swipeto - 1]

                        if (frompower != "nil"){
                            
                            childNodeWithName("imgpower" + String(swipepower))?.position = childNodeWithName("framepower" + String(swipeto))!.position
                            childNodeWithName("imgpower" + String(swipepower))?.name = "imgpower" + String(swipeto)
                            childNodeWithName("imgpower" + String(swipeto))?.position = childNodeWithName("framepower" + String(swipeto))!.position
                            if topower != "nil"{
                                childNodeWithName("imgpower" + String(swipeto))?.name = "imgpower" + String(swipepower)
                                childNodeWithName("imgpower" + String(swipepower))?.position = childNodeWithName("framepower" + String(swipepower))!.position
                            }
                            selectedpower[swipepower - 1] = topower
                            selectedpower[swipeto - 1] = frompower
                            NSUserDefaults.standardUserDefaults().setObject(selectedpower, forKey: "selectedpower")
                        }
                    }else{
                        childNodeWithName("imgpower" + String(swipepower))?.position = childNodeWithName("framepower" + String(swipepower))!.position
                    }
                    swipepower = -1
                }
                else if (page == 2 && CGRectContainsPoint(lblnextsmart!.frame, location)){
                    movesmartpage(1)
                }
                else if (page == 2 && CGRectContainsPoint(lblbeforesmart!.frame, location)){
                    movesmartpage(-1)
                }
                else if (page == 2 && CGRectContainsPoint(lblselectbuy!.frame, location)){
                    var smartarr = NSUserDefaults.standardUserDefaults().valueForKey("smartarr") as! [Int]
                    let selectedsmart = NSUserDefaults.standardUserDefaults().valueForKey("selectedsmart") as! Int
                    let cash = NSUserDefaults.standardUserDefaults().valueForKey("cash") as! Int
                    let lblselectbuy = childNodeWithName("lblselectbuy") as! SKLabelNode
                    if (smartarr[smart - 1] == 1){
                        if (selectedsmart != smart){
                            NSUserDefaults.standardUserDefaults().setObject(smart, forKey: "selectedsmart")
                            lblselectbuy.text = "selected"
                            lblselectbuy.fontColor = UIColor.grayColor()
                        }
                    }
                    else{
                        if (cash >= smartprice[smart - 1]){
                            NSUserDefaults.standardUserDefaults().setObject(cash - smartprice[smart - 1], forKey: "cash")
                            NSUserDefaults.standardUserDefaults().setObject(smart, forKey: "selectedsmart")
                            smartarr[smart - 1] = 1
                            NSUserDefaults.standardUserDefaults().setObject(smartarr, forKey: "smartarr")
                            lblselectbuy.text = "selected"
                            lblselectbuy.fontColor = UIColor.grayColor()
                            let lblcash = childNodeWithName("lblcash") as! SKLabelNode
                            lblcash.text = String(cash - smartprice[smart - 1])
                        }
                    }
                }
                else if (CGRectContainsPoint(lblupgrade!.frame, location)){
                    if page == 2{
                        removepage(2)
                        addpage(1)
                    }else if page == 3{
                        removepage(3)
                        addpage(1)
                    }
                    page = 1
                }else if (CGRectContainsPoint(lblselectball!.frame, location)){
                    if page == 1{
                        removepage(1)
                        addpage(2)
                    }else if page == 3{
                        removepage(3)
                        addpage(2)
                    }
                    page = 2
                }else if (CGRectContainsPoint(lblselectpowerapps!.frame, location)){
                    if page == 2{
                        removepage(2)
                        addpage(3)
                    }else if page == 1{
                        removepage(1)
                        addpage(3)
                    }
                    page = 3
                }else if CGRectContainsPoint(lblselectlevel!.frame, location) && !self.inanimation && !self.inselectlevelpage{
                    self.inanimation = true
                    let selectedsmart = NSUserDefaults.standardUserDefaults().valueForKey("selectedsmart") as! Int
                    addblack(0)
                    childNodeWithName("alert")?.zPosition = 1
                    let black = childNodeWithName("black")
                    black!.runAction(SKAction.fadeInWithDuration(1), completion: { () -> Void in
                        self.addselectlevelpage()
                    })
                }
                else if (page == 1 && CGRectContainsPoint(frameshootspeed!.frame, location)){
                    let ezer : Int = NSUserDefaults.standardUserDefaults().valueForKey("shootspeed") as! Int + 1
                    if ( ezer <= 10){
                        let price = shootspeedprice[(NSUserDefaults().valueForKey("shootspeed") as! Int)]
                        let cash = NSUserDefaults.standardUserDefaults().valueForKey("cash") as! Int
                        if (cash >= price){
                            NSUserDefaults.standardUserDefaults().setObject(ezer, forKey: "shootspeed")
                            NSUserDefaults.standardUserDefaults().setObject(cash - price, forKey: "cash")
                            let lblcash = childNodeWithName("lblcash") as! SKLabelNode
                            lblcash.text = String(NSUserDefaults.standardUserDefaults().valueForKey("cash") as! Int)
                            let lblshootspeedprice = childNodeWithName("lblshootspeedprice") as! SKLabelNode
                            if (NSUserDefaults().valueForKey("shootspeed") as! Int) < 10{
                                lblshootspeedprice.text = String(shootspeedprice[(NSUserDefaults().valueForKey("shootspeed") as! Int)]) + "$"
                            }
                            else{
                                lblshootspeedprice.text = ""
                            }
                            let lblshootspeedstock = childNodeWithName("lblshootspeedstock") as! SKLabelNode
                            lblshootspeedstock.text = String(NSUserDefaults.standardUserDefaults().valueForKey("shootspeed") as! Int) + "/10"
                        }
                    }}
                else if (page == 1 && CGRectContainsPoint(framemovespeed!.frame, location)){
                    let ezer : Int = NSUserDefaults.standardUserDefaults().valueForKey("movespeed") as! Int + 1
                    if ( ezer <= 10){
                        let price = movespeedprice[(NSUserDefaults().valueForKey("movespeed") as! Int)]
                        let cash = NSUserDefaults.standardUserDefaults().valueForKey("cash") as! Int
                        if (cash >= price){
                            NSUserDefaults.standardUserDefaults().setObject(ezer, forKey: "movespeed")
                            NSUserDefaults.standardUserDefaults().setObject(cash - price, forKey: "cash")
                            let lblcash = childNodeWithName("lblcash") as! SKLabelNode
                            lblcash.text = String(NSUserDefaults.standardUserDefaults().valueForKey("cash") as! Int)
                            nummovespeed += 0.1
                            let lblmovespeedprice = childNodeWithName("lblmovespeedprice") as! SKLabelNode
                            if (NSUserDefaults().valueForKey("movespeed") as! Int) < 10{
                                lblmovespeedprice.text = String(movespeedprice[(NSUserDefaults().valueForKey("movespeed") as! Int)]) + "$"
                            }
                            else{
                                lblmovespeedprice.text = ""
                            }
                            let lblmovespeedstock = childNodeWithName("lblmovespeedstock") as! SKLabelNode
                            lblmovespeedstock.text = String(NSUserDefaults.standardUserDefaults().valueForKey("movespeed") as! Int) + "/10"
                        }
                    }
                }
                else if (CGRectContainsPoint(resetgame!.frame, location)){
                    gameoverbool = true
                    NSUserDefaults.standardUserDefaults().setObject(0, forKey: "shootspeed")
                    NSUserDefaults.standardUserDefaults().setObject(0, forKey: "movespeed")
                    NSUserDefaults.standardUserDefaults().setObject(5000, forKey: "cash")
                    let lblcash = childNodeWithName("lblcash") as! SKLabelNode
                    lblcash.text = "5000"
                    
                }
                
                
                
            }
        }
        swipepower = -1
    }
    override func update(currentTime: CFTimeInterval) {
        let lblcash = childNodeWithName("lblcash") as! SKLabelNode
        let boolezer = !gameoverbool && !needwaitsec && !inshop
        if (boolezer){
        let player = childNodeWithName("player")
            let levelselected = NSUserDefaults.standardUserDefaults().valueForKey("levelselected") as! Int
            
//new enemy
            if self.roundrnd == 0{
                 var enemy1ezer = level1info[0]
                if levelselected == 1{
                    if roundcount < 15{
                        enemy1ezer = level1info[0] - UInt32(roundcount)
                    }else if roundcount < 25{
                        enemy1ezer = level1info[0] - 15 - 2 * (UInt32(roundcount) - 15)
                    }else if roundcount <= 30{
                        enemy1ezer = level1info[0] - 25 - 4 * (UInt32(roundcount) - 25)
                    }else{
                        
                    }
                }
                else if levelselected == 2{
                    if roundcount < 10{
                        enemy1ezer = level2info[0]
                    }else if roundcount < 25{
                        enemy1ezer = level2info[0] - UInt32(roundcount)
                    }else if roundcount <= 30{
                        enemy1ezer = level2info[0] - 15 - 2 * (UInt32(roundcount) - 25)
                    }else{
                        
                    }
                }
                if (arc4random() % (enemy1ezer ) == 0){
                    for (var i = 0; i < 1; i++){
                        var enemy = SKSpriteNode(imageNamed:"enemy1 - one ball army.png")
                        enemy.position = rndenemypos()
                        enemy.name = "enemy1 " + String(numname)
                        enemy.xScale = 0.11061947
                        enemy.yScale = 0.11061947
                        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 13.5)
                        enemy.physicsBody?.affectedByGravity = false
                        enemy.physicsBody?.restitution = 1
                        enemy.physicsBody?.friction = 0.0
                        enemy.physicsBody?.linearDamping = 0.0
                        enemy.physicsBody?.angularDamping = 0.0
                        enemy.physicsBody?.categoryBitMask = bodytype.enemy1.rawValue
                        enemy.physicsBody?.contactTestBitMask = bodytype.shoot.rawValue
                        enemy.physicsBody?.contactTestBitMask += bodytype.player.rawValue
                        enemy.physicsBody?.collisionBitMask = bodytype.shoot.rawValue
                        enemy.physicsBody?.collisionBitMask = bodytype.shoot.rawValue
                        enemy.physicsBody?.collisionBitMask += bodytype.enemy1.rawValue
                        enemy.zPosition = -9
                        addChild(enemy)
                        enemies1.append("enemy1 " + String(numname))
                        numname++
                    }
                }
            }else if self.roundrnd == 1{
                var enemy2ezer = level1info[0]
                if levelselected == 1{
                    if roundcount < 15{
                        enemy2ezer = level1info[0] - UInt32(roundcount)
                    }else if roundcount < 25{
                        enemy2ezer = level1info[0] - 15 - 2 * (UInt32(roundcount) - 15)
                    }else if roundcount <= 30{
                        enemy2ezer = level1info[0] - 25 - 4 * (UInt32(roundcount) - 25)
                    }else{
                        
                    }
                }
                else if levelselected == 2{
                    if roundcount < 10{
                        enemy2ezer = level2info[0]
                    }else if roundcount < 25{
                        enemy2ezer = level2info[0] - UInt32(roundcount)
                    }else if roundcount <= 30{
                        enemy2ezer = level2info[0] - 15 - 2 * (UInt32(roundcount) - 25)
                    }else{
                        
                    }
                }
                if ( arc4random()%enemy2ezer == 1){
                    for (var i = 0; i < 1; i++){
                        var enemy = SKSpriteNode(imageNamed:"enemy2 - one ball army.png")
                        enemy.position = rndenemypos()
                        enemy.name = "enemy2 " + String(numname)
                        enemy.xScale = 0.11061947
                        enemy.yScale = 0.11061947
                        enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.frame.width / 2)
                        enemy.physicsBody?.affectedByGravity = false
                        enemy.physicsBody?.categoryBitMask = bodytype.enemy2.rawValue
                        //enemy.physicsBody?.categoryBitMask = collidertype.enemy.rawValue
                        enemy.physicsBody?.contactTestBitMask = bodytype.shoot.rawValue
                        enemy.physicsBody?.contactTestBitMask += bodytype.player.rawValue
                        enemy.physicsBody?.contactTestBitMask += bodytype.wall.rawValue
                        //enemy.physicsBody?.collisionBitMask = bodytype.player.rawValue
                        enemy.physicsBody?.collisionBitMask = bodytype.shoot.rawValue
                        enemy.physicsBody?.collisionBitMask += bodytype.enemy2.rawValue
                        enemy.zPosition = -10
                        enemy.runAction(SKAction.scaleBy(3.5, duration: 10))
                        enemy.physicsBody?.mass *= 10
                        addChild(enemy)
                        enemies2.append("enemy2 " + String(numname))
                        numname++
                        var theenemy = childNodeWithName("enemy2 " + String(numname-1))
                        if (player == nil){
                            pos = rndplayerpos()
                        }
                        else{
                            pos = player!.position
                        }
                        var dxx : CGFloat = 0 , dyy : CGFloat = 0
                        if (pos.x >= theenemy!.position.x){
                            dxx = pos.x -  theenemy!.position.x
                        }
                        else{
                            dxx = -( theenemy!.position.x - pos.x)
                        }
                        if (pos.y >=  theenemy!.position.y){
                            dyy = pos.y -  theenemy!.position.y
                        }
                        else{
                            dyy = -( theenemy!.position.y - pos.y)
                        }
                        theenemy?.physicsBody?.applyForce(CGVector(dx: dxx * 3, dy: dyy * 3))
                        var dx = theenemy!.position.x - pos.x
                        var dy = theenemy!.position.y - pos.y
                        var angleToTurn = atan2(dy, dx);
                        theenemy?.zRotation = angleToTurn
                    }
                }
                
            }
        
            else if roundrnd == 2 && cansendcircle{
                cansendcircle = false
                if levelselected == 1{
                    self.addcircle1(Int(level1info[2]) + roundcount)
                }else if levelselected == 2{
                    self.addcircle1(Int(level2info[2]) + roundcount * 2)
                }
                
            } else if roundrnd == 3 && cansendcircle{
                cansendcircle = false
                if levelselected == 1{
                    self.addcircle2(Int(level1info[3]) + roundcount)
                }else if levelselected == 2{
                    self.addcircle2(Int(level2info[3]) + roundcount * 2)
                }
                
            }
//enemy1 move
            if (player != nil){
        for enemyname in enemies1{
            var enemy = childNodeWithName(enemyname)
            pos = player!.position
            var dxx : CGFloat = 0 , dyy : CGFloat = 0
            if (player!.position.x >= enemy!.position.x){
                dxx = player!.position.x -  enemy!.position.x
            }
            else{
                dxx = -( enemy!.position.x - player!.position.x)
            }
            if (player!.position.y >=  enemy!.position.y){
                dyy = player!.position.y -  enemy!.position.y
            }
            else{
                dyy = -( enemy!.position.y - player!.position.y)
            }
            enemy?.physicsBody?.applyForce(CGVector(dx: dxx * 0.006, dy: dyy * 0.006))
            var dx = enemy!.position.x - player!.position.x
            var dy = enemy!.position.y - player!.position.y
            var angleToTurn = atan2(dy, dx);
            enemy?.zRotation = angleToTurn
        }
        }
        }
        else{
            
        }
    }
    
    func stopgame(){
        gameoverbool = true
        self.playercontroltimer.invalidate()
        self.powerplayercontrolbool = false
        self.roundcount = 1
        let player = childNodeWithName("player")
        player?.physicsBody?.dynamic = false
        for enemyname in enemies1{
            var enemy = childNodeWithName(enemyname)
            enemy?.physicsBody = nil
            
        }
        for enemyname in enemies2{
            var enemy = childNodeWithName(enemyname)
            let newenemy = SKSpriteNode(imageNamed: "enemy2 - one ball army.png")
            newenemy.position = enemy!.position
            newenemy.name = "enemy2 " + String(numname)
            newenemy.xScale = enemy!.xScale
            newenemy.yScale = enemy!.yScale
            newenemy.zPosition = -10
            newenemy.physicsBody = nil
            newenemy.zRotation = enemy!.zRotation
            enemies2.append(newenemy.name!)
            addChild(newenemy)
            numname++
            enemy?.removeFromParent()
            
            
        }
        for shootname in shoots1{
            let shoot = childNodeWithName(shootname)
            shoot?.physicsBody = nil
        }
        let retry = SKSpriteNode(imageNamed: "Retry")
        retry.name = "retry"
        retry.xScale /= 1.3
        retry.yScale /= 1.3
        retry.position = CGPoint(x:  self.view!.bounds.width * 2  - 100 - retry.xScale / 2, y: 300)
        retry.physicsBody = nil
        retry.zPosition = 12
        retry.alpha = 0
        self.addChild(retry)
        retry.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        let store = SKSpriteNode(imageNamed: "store - one ball army.png")
        store.name = "store"
        store.position = CGPoint(x:  self.view!.bounds.width * 2 / 2 - 140, y: 300)
        store.physicsBody = nil
        store.zPosition = 12
        store.xScale /= 1.3
        store.yScale /= 1.3
        store.alpha = 0
        self.addChild(store)
        store.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        let levelframe = SKSpriteNode(imageNamed: "blueframe")
        levelframe.name = "levelframe"
        levelframe.xScale *= 2
        levelframe.yScale *= 2
        levelframe.position = CGPoint(x:  self.view!.bounds.width * 2  / 2, y:  self.view!.bounds.height * 2 / 2 - 100)
        levelframe.physicsBody = nil
        levelframe.zPosition = 11
        levelframe.alpha = 0
        self.addChild(levelframe)
        levelframe.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        let xpframe = SKSpriteNode(imageNamed: "rectframe")
        xpframe.name = "xpframe"
        xpframe.xScale *= 0.8
        xpframe.yScale *= 0.7
        xpframe.position = CGPoint(x:  self.view!.bounds.width * 2  / 2, y:  self.view!.bounds.height * 2 / 2 - 110)
        xpframe.physicsBody = nil
        xpframe.zPosition = 13
        xpframe.alpha = 0
        self.addChild(xpframe)
        let lbllevel = SKLabelNode(text: String(beforelevel))
        lbllevel.position.x = 140
        lbllevel.position.y =  self.view!.bounds.height * 2  / 2 - 30
        lbllevel.name = "lbllevel"
        lbllevel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        lbllevel.fontColor = UIColor.purpleColor()
        lbllevel.fontName = "GeezaPro-Bold"
        lbllevel.fontSize = 50
        lbllevel.zPosition = 13
        self.addChild(lbllevel)
        xpframe.runAction(SKAction.fadeAlphaTo(1, duration: 1))
        let xprect = SKSpriteNode(imageNamed: "blue")
        xprect.name = "xprect"
        let ezer1 = Double(beforexp)
        let ezer2 = Double(xpneed())
        xprect.xScale *= 400 * CGFloat(ezer1/ezer2)
        xprect.yScale *= 65
        xprect.position = CGPoint(x: 120 + xprect.xScale / 2 , y:  self.view!.bounds.height * 2 / 2 - 110)
        xprect.physicsBody = nil
        xprect.zPosition = 12
        xprect.alpha = 0
        self.addChild(xprect)
        xprect.runAction(SKAction.fadeAlphaTo(0.9, duration: 1), completion: { () -> Void in
            if (self.gameoverbool && !self.inshop && !self.inanimation && !self.touchstore){
                var xp = NSUserDefaults.standardUserDefaults().valueForKey("xp") as! Int
                var level = NSUserDefaults.standardUserDefaults().valueForKey("level") as! Int
                if xp > self.xpneed(){
                    xprect.position.x = 120 + 200 * CGFloat(Double(self.beforexp)/Double(self.xpneed()))
                    xprect.runAction(SKAction.moveToX(320, duration: 0.8))
                        xprect.runAction(SKAction.scaleXTo(400, duration: 0.8), completion: { () -> Void in
                        if (self.gameoverbool && !self.inshop && !self.inanimation && !self.touchstore){
                            let levelezer = self.refreshlevel()
                            let touchalert = NSUserDefaults.standardUserDefaults().valueForKey("touchalert") as! Bool
                            if (!touchalert){
                            let alert = SKSpriteNode(imageNamed: "alert")
                            alert.name = "alert"
                            alert.position = CGPoint(x: store.position.x - 35, y: store.position.y + 40)
                            alert.physicsBody = nil
                            alert.zPosition = 13
                            alert.xScale *= 0.01
                            alert.yScale *= 0.01
                            alert.alpha = 0
                            self.addChild(alert)
                            
                            alert.runAction(SKAction.fadeAlphaTo(1, duration: 0.7))
                            alert.runAction(SKAction.scaleTo(0.2, duration: 0.5), completion: { () -> Void in
                                alert.runAction(SKAction.scaleBy(0.5, duration: 0.2))
                            })
                                }
                            
                            xp = NSUserDefaults.standardUserDefaults().valueForKey("xp") as! Int
                            level = NSUserDefaults.standardUserDefaults().valueForKey("level") as! Int
                                xprect.xScale = 0
                                xprect.position.x = 120
                                let scaleezer = 400 * CGFloat(Double(xp)/Double(self.xpneed()))
                                xprect.runAction(SKAction.moveToX(120 + scaleezer / 2, duration: 0.8))
                                xprect.runAction(SKAction.scaleXTo(scaleezer, duration: 0.8))
                            
                            lbllevel.runAction(SKAction.rotateByAngle(2 * CGFloat(self.pi), duration: 0.9))
                            lbllevel.runAction(SKAction.moveToX(1000, duration: 0.5), completion: { () -> Void in
                                if (self.gameoverbool && !self.inshop && !self.inanimation && !self.touchstore){
                                    lbllevel.position.x = -50
                                    lbllevel.text = String(levelezer)
                                    lbllevel.runAction(SKAction.moveToX(140, duration: 0.5))
                                }
                                
                            })
                            
                        }
                    })
                }
                else{
                    let scaleezer = 400 * CGFloat(Double(xp)/Double(self.xpneed()))
                    xprect.runAction(SKAction.scaleXTo(scaleezer, duration: 1), completion: { () -> Void in
                        let x = self.refreshlevel()
                    })
                    let ezer1 = Double(xp)
                    let ezer2 = Double(self.xpneed())
                    let ezer3 = 400 * CGFloat(ezer1/ezer2)
                    xprect.runAction(SKAction.moveToX(120 + ezer3 / 2, duration: 1))
                }
            }
        })
        //let stezer = "beforexp = " + String(beforexp) + " , xpneed = " + String(xpneed()) + " , beforexp/xpneed = " + String(beforexp/xpneed())
        addblack(0.5)
        
    }
    func playershoot(dx : CGFloat,dy : CGFloat){
        if (dx != 10){
        let player = childNodeWithName("player")
        var shoot = SKSpriteNode(imageNamed:"shoot1 - one ball army.png")
        var a = sin(player!.zRotation) * (player!.xScale) * 25
        var b = cos(player!.zRotation) * (player!.yScale) * 25
        shoot.position.x = player!.position.x + b
        shoot.position.y = player!.position.y + a
        shoot.name = "shoot " + String(numname)
        shoot.xScale = 0.0829646025
        shoot.yScale = 0.0829646025
        shoot.physicsBody = SKPhysicsBody(circleOfRadius: 5.0625)
        shoot.physicsBody?.affectedByGravity = false
        shoot.physicsBody?.categoryBitMask = bodytype.shoot.rawValue
        shoot.physicsBody?.collisionBitMask = bodytype.enemy1.rawValue
        shoot.physicsBody?.contactTestBitMask = bodytype.enemy1.rawValue
        shoot.zPosition = -15
        addChild(shoot)
        numname++
        var theshoot = childNodeWithName("shoot " + String(numname-1))
        shoots1.append(theshoot!.name!)
                var newdx = dx / 2 - dx / 6 + CGFloat(arc4random()) % (dx / 3)
                var newdy = dy / 2 - dy / 6 + CGFloat(arc4random()) % (dy / 3)
                if (dx < 0){
                    newdx = dx / 2 + dx / 6 + CGFloat(arc4random()) % (dx / 3)
                }
                if (dy < 0){
                    newdy = dy / 2 + dy / 6 + CGFloat(arc4random()) % (dy / 3)
                }
                theshoot?.physicsBody?.applyForce(CGVector(dx: newdx / 2, dy: newdy / 2))
    }
    }
    func removegameend(){
        self.childNodeWithName("player")?.removeFromParent()
        //self.childNodeWithName("retry")?.removeFromParent()
        //self.childNodeWithName("store")?.removeFromParent()
        self.childNodeWithName("downwall")?.removeFromParent()
        self.childNodeWithName("framepower1")?.removeFromParent()
        self.childNodeWithName("imgpower1")?.removeFromParent()
        self.childNodeWithName("lblpower1")?.removeFromParent()
        self.childNodeWithName("imgpower2")?.removeFromParent()
        self.childNodeWithName("framepower2")?.removeFromParent()
        self.childNodeWithName("lblpower2")?.removeFromParent()
        self.childNodeWithName("framepower3")?.removeFromParent()
        self.childNodeWithName("imgpower3")?.removeFromParent()
        self.childNodeWithName("lblpower3")?.removeFromParent()
        self.childNodeWithName("framepower4")?.removeFromParent()
        self.childNodeWithName("imgpower4")?.removeFromParent()
        self.childNodeWithName("lblpower4")?.removeFromParent()
        self.childNodeWithName("lblpowercash")?.removeFromParent()
        self.childNodeWithName("levelframe")?.removeFromParent()
        self.childNodeWithName("xpframe")?.removeFromParent()
        self.childNodeWithName("lbllevel")?.removeFromParent()
        self.childNodeWithName("xprect")?.removeFromParent()
        self.childNodeWithName("alert")?.removeFromParent()
    }
    func gotostore(pagetogo : Int){
        self.beforelevel = NSUserDefaults.standardUserDefaults().valueForKey("level") as! Int
        self.beforexp = NSUserDefaults.standardUserDefaults().valueForKey("xp") as! Int
        refreshlevel()
        touchstore = false
        inshop = true
        gameoverbool = true
        self.page = pagetogo
        addstorekoteret()
        resetpower()
        addpage(pagetogo)
    }
    func resetpower(){
        self.powercash = 0
        powerprice[0] = firstpowerprice.shild.rawValue
        powerprice[1] = firstpowerprice.fastshooting.rawValue
        powerprice[2] = firstpowerprice.playercontrol.rawValue
        powerprice[3] = firstpowerprice.power4.rawValue
        if (childNodeWithName("lblpower1") != nil){
            let lblpowercash = childNodeWithName("lblpowercash") as! SKLabelNode
            lblpowercash.text = String(0)
        let lblpower1 = childNodeWithName("lblpower1") as! SKLabelNode
        lblpower1.text = String(powerprice[0])
        let lblpower2 = childNodeWithName("lblpower2") as! SKLabelNode
        lblpower2.text = String(powerprice[1])
        let lblpower3 = childNodeWithName("lblpower3") as! SKLabelNode
        lblpower3.text = String(powerprice[2])
        let lblpower4 = childNodeWithName("lblpower4") as! SKLabelNode
        lblpower4.text = String(powerprice[3])
        }
    }
    func addgamenodes(){
        self.inshop = false
        self.inanimation = true
        //let barakarr = NSUserDefaults.standardUserDefaults().valueForKey("barakarr") as! [Int]
        let selectedpower = NSUserDefaults.standardUserDefaults().valueForKey("selectedpower") as! [String]
        //let selectedsmart = NSUserDefaults.standardUserDefaults().valueForKey("selectedsmart") as! Int
        //NSUserDefaults.standardUserDefaults().setValue(barakarr[selectedsmart - 1] - 1, forKey: "barakarr")
        self.beforelevel = NSUserDefaults.standardUserDefaults().valueForKey("level") as! Int
        self.beforexp = NSUserDefaults.standardUserDefaults().valueForKey("xp") as! Int
        refreshlevel()
        let black = self.childNodeWithName("black")
        self.addplayer(CGPoint(x: 320, y: 500 + 136), addtimer: true)
        self.removepage(self.page)
        self.removestorekoteret()
        let downwall = SKSpriteNode(color: UIColor.blackColor(), size: CGSize(width: 1000, height: 10))
        downwall.name = "downwall"
        downwall.position = CGPoint(x: 320, y: 131)
        downwall.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 1000, height: 10))
        downwall.physicsBody?.affectedByGravity = false
        downwall.physicsBody?.dynamic = false
        downwall.physicsBody?.allowsRotation = false
        self.addChild(downwall)
        let framepower1 = SKSpriteNode(imageNamed: "frame2")
        framepower1.physicsBody = nil
        framepower1.position.x = 80
        framepower1.position.y = 80
        framepower1.size.height = 75
        framepower1.size.width = 80
        framepower1.name = "framepower1"
        addChild(framepower1)
        if selectedpower[0] != "nil"{
            let imgpower1 = SKSpriteNode(imageNamed: selectedpower[0])
            imgpower1.physicsBody = nil
            imgpower1.position.x = 80
            imgpower1.position.y = 80
            imgpower1.size.height = 60
            imgpower1.size.width = 60
            imgpower1.name = "imgpower1"
            addChild(imgpower1)
        }
        let lblpower1 = SKLabelNode(fontNamed: "GeezaPro-Bold")
        lblpower1.name = "lblpower1"
        lblpower1.text = ""
        if selectedpower[0] != "nil"{
            if selectedpower[0] == "shild"{
                lblpower1.text = String(powerprice[0])
            }else if selectedpower[0] == "fastshooting"{
                lblpower1.text = String(powerprice[1])
            }else if selectedpower[0] == "playercontrol"{
                lblpower1.text = String(powerprice[2])
            }else if selectedpower[0] == "power4"{
                lblpower1.text = String(powerprice[3])
            }
        }
        lblpower1.position =  CGPoint(x: 80, y: 10)
        lblpower1.fontColor = UIColor.greenColor()
        lblpower1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        self.addChild(lblpower1)
        let framepower2 = SKSpriteNode(imageNamed: "frame2")
        framepower2.physicsBody = nil
        framepower2.position.x = 200
        framepower2.position.y = 80
        framepower2.size.height = 75
        framepower2.size.width = 80
        framepower2.name = "framepower2"
        addChild(framepower2)
        if selectedpower[1] != "nil"{
            let imgpower2 = SKSpriteNode(imageNamed: selectedpower[1])
            imgpower2.physicsBody = nil
            imgpower2.position.x = 200
            imgpower2.position.y = 80
            imgpower2.size.height = 60
            imgpower2.size.width = 60
            imgpower2.name = "imgpower2"
            addChild(imgpower2)
        }
        let lblpower2 = SKLabelNode(fontNamed: "GeezaPro-Bold")
        lblpower2.name = "lblpower2"
        lblpower2.text = ""
        if selectedpower[1] != "nil"{
            if selectedpower[1] == "shild"{
                lblpower2.text = String(powerprice[0])
            }else if selectedpower[1] == "fastshooting"{
                lblpower2.text = String(powerprice[1])
            }else if selectedpower[1] == "playercontrol"{
                lblpower2.text = String(powerprice[2])
            }else if selectedpower[1] == "power4"{
                lblpower2.text = String(powerprice[3])
            }
        }
        lblpower2.position =  CGPoint(x: 200, y: 10)
        lblpower2.fontColor = UIColor.greenColor()
        lblpower2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        self.addChild(lblpower2)
        let framepower3 = SKSpriteNode(imageNamed: "frame2")
        framepower3.physicsBody = nil
        framepower3.position.x = 320
        framepower3.position.y = 80
        framepower3.size.height = 75
        framepower3.size.width = 80
        framepower3.name = "framepower3"
        addChild(framepower3)
        if selectedpower[2] != "nil"{
            let imgpower3 = SKSpriteNode(imageNamed: selectedpower[2])
            imgpower3.physicsBody = nil
            imgpower3.position.x = 320
            imgpower3.position.y = 80
            imgpower3.size.height = 60
            imgpower3.size.width = 60
            imgpower3.name = "imgpower3"
            addChild(imgpower3)
        }
        let lblpower3 = SKLabelNode(fontNamed: "GeezaPro-Bold")
        lblpower3.name = "lblpower3"
        lblpower3.text = ""
        if selectedpower[2] != "nil"{
            if selectedpower[2] == "shild"{
                lblpower3.text = String(powerprice[0])
            }else if selectedpower[2] == "fastshooting"{
                lblpower3.text = String(powerprice[1])
            }else if selectedpower[2] == "playercontrol"{
                lblpower3.text = String(powerprice[2])
            }else if selectedpower[2] == "power4"{
                lblpower3.text = String(powerprice[3])
            }
        }
        lblpower3.position =  CGPoint(x: 320, y: 10)
        lblpower3.fontColor = UIColor.greenColor()
        lblpower3.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        self.addChild(lblpower3)
        let framepower4 = SKSpriteNode(imageNamed: "frame2")
        framepower4.physicsBody = nil
        framepower4.position.x = 440
        framepower4.position.y = 80
        framepower4.size.height = 75
        framepower4.size.width = 80
        framepower4.name = "framepower4"
        addChild(framepower4)
        if selectedpower[3] != "nil"{
            let imgpower4 = SKSpriteNode(imageNamed: selectedpower[3])
            imgpower4.physicsBody = nil
            imgpower4.position.x = 440
            imgpower4.position.y = 80
            imgpower4.size.height = 60
            imgpower4.size.width = 60
            imgpower4.name = "imgpower4"
            addChild(imgpower4)
        }
        let lblpower4 = SKLabelNode(fontNamed: "GeezaPro-Bold")
        lblpower4.name = "lblpower4"
        lblpower4.text = ""
        if selectedpower[3] != "nil"{
            if selectedpower[3] == "shild"{
                lblpower4.text = String(powerprice[0])
            }else if selectedpower[3] == "fastshooting"{
                lblpower4.text = String(powerprice[1])
            }else if selectedpower[3] == "playercontrol"{
                lblpower4.text = String(powerprice[2])
            }else if selectedpower[3] == "power4"{
                lblpower4.text = String(powerprice[3])
            }
        }
        lblpower4.position =  CGPoint(x: 440, y: 10)
        lblpower4.fontColor = UIColor.greenColor()
        lblpower4.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        self.addChild(lblpower4)
        let lblpowercash = SKLabelNode(fontNamed: "GeezaPro-Bold")
        lblpowercash.name = "lblpowercash"
        lblpowercash.text = String(powercash)
        lblpowercash.position =  CGPoint(x: 560, y: 62)
        lblpowercash.fontColor = UIColor.orangeColor()
        lblpowercash.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        self.addChild(lblpowercash)
        black!.runAction(SKAction.fadeOutWithDuration(0.5), completion: { () -> Void in
            self.page = 1
            self.needwaitsec = false
            self.inanimation = false
            self.gameoverbool = false
            self.childNodeWithName("black")?.removeFromParent()
            if (!self.didcallshootingtimer){
                var timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: "shootingtimer", userInfo: nil, repeats: true)
                self.didcallshootingtimer = true
            }
            if !self.didcallroundtimer{
                self.theroundtimer.invalidate()
                self.theroundtimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "roundtimer", userInfo: nil, repeats: true)
            }

        })
    }
    func touchpower(powernum : Int){
        if self.childNodeWithName("ring" + String(powernum)) == nil{
            let selectedpower = NSUserDefaults.standardUserDefaults().valueForKey("selectedpower") as! [String]
            if (selectedpower[powernum - 1] != "nil"){
                var thislblpower = childNodeWithName("lblpower" + String(powernum)) as! SKLabelNode
                var thisdeltapowerprice = deltapowerprice.shild.rawValue
                let thispowerprice = powerprice[powernum - 1]
                if (selectedpower[powernum - 1] == "fastshooting"){
                    thisdeltapowerprice = deltapowerprice.fastshooting.rawValue
                }
                else if (selectedpower[powernum - 1] == "playercontrol"){
                    thisdeltapowerprice = deltapowerprice.playercontrol.rawValue
                }
                else if (selectedpower[powernum - 1] == "power4"){
                    thisdeltapowerprice = deltapowerprice.power4.rawValue
                }
                
                let b1 = powercash >= thispowerprice
                let b2 = selectedpower[powernum - 1] == "shild" && powershildactive
                if (b1 && !b2){
                    rechargepower(powernum)
                    powercash -= thispowerprice
                    powerprice[powernum - 1] = thispowerprice + thisdeltapowerprice
                    thislblpower.text = String(powerprice[powernum - 1])
                    if (selectedpower[powernum - 1] == "shild"){
                        powershild()
                    }
                    else if (selectedpower[powernum - 1] == "fastshooting"){
                        powerfastshooting()
                    }
                    else if selectedpower[powernum - 1 ] == "playercontrol"{
                        powerplayercontrol()
                    }
                }
                
            }

        }
    }
    func addplayer(position : CGPoint, addtimer: Bool){
        let playerimg = NSUserDefaults.standardUserDefaults().valueForKey("selectedsmart") as! Int
        var playerimgstr = "player - one ball army.png"
        if (playerimg == 2){
            playerimgstr = "player2 - one ball army.png"
        }
        else if (playerimg == 3){
            playerimgstr = "player3 - one ball army.png"
            if (addtimer && !didcallteletimer){
            var timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "playertele", userInfo: nil, repeats: true)
                didcallteletimer = true
            }
        }
        let player = SKSpriteNode(imageNamed: playerimgstr)
        player.position = position
        player.xScale = 0.1769911504
        player.yScale = 0.1769911504
        player.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.affectedByGravity = false
        player.name = "player"
        player.physicsBody?.categoryBitMask = bodytype.player.rawValue
        player.physicsBody?.collisionBitMask = bodytype.enemy1.rawValue
        player.physicsBody?.contactTestBitMask = bodytype.enemy1.rawValue
        player.zPosition = -5
        addChild(player)
    }
    func powershild(){
        if !powershildactive{
            powershildbool = true
            powershildactive = true
            let shild = SKSpriteNode(imageNamed: "shild.png")
            shild.position.x = -10000
            if (childNodeWithName("player") != nil){
                shild.position = childNodeWithName("player")!.position
            }
            shild.xScale = 0.22
            shild.yScale = 0.22
            shild.physicsBody = SKPhysicsBody(circleOfRadius: 30)
            shild.physicsBody?.allowsRotation = false
            shild.physicsBody?.affectedByGravity = false
            shild.physicsBody?.dynamic = false
            shild.name = "shild"
            shild.physicsBody?.categoryBitMask = bodytype.powershild.rawValue
            shild.physicsBody?.collisionBitMask = bodytype.powershild.rawValue
            shild.physicsBody?.contactTestBitMask = bodytype.enemy1.rawValue + bodytype.enemy2.rawValue
            shild.zPosition = -4
            addChild(shild)
            

        }
    }
    func powerfastshooting(){
        let player = childNodeWithName("player")
        self.powerfastshootingbool = true
        player?.runAction(SKAction.rotateByAngle(11, duration: 1), completion: { () -> Void in
            self.powerfastshootingbool = false
        })
        player?.runAction(SKAction.customActionWithDuration(1, actionBlock: { (player, time) -> Void in
            if (self.powerfastshootingbool && player != nil){
                println(String(stringInterpolationSegment: player!.zRotation) + "///////////")
                self.playershoot(100 * cos(player!.zRotation), dy: 100 * sin(player!.zRotation))
                self.numshootspeed++
            }

        }))
    }
    func powerplayercontrol(){
        self.powerplayercontrolbool = true
      self.playercontroltimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "stopplayercontrol", userInfo: nil, repeats: false)
        
    }
    func stopplayercontrol(){
        self.powerplayercontrolbool = false
        self.playercontroltimer.invalidate()
    }
    func rechargepower(powernum : Int){
        var circle = UIBezierPath()
        circle.addArcWithCenter(CGPoint(x: 0, y: 0), radius: 10, startAngle: 0.0, endAngle: 1, clockwise: true)
        let ring = SKShapeNode(path: circle.CGPath)
        ring.name = "ring" + String(powernum)
        ring.lineWidth = 12
        ring.alpha = 0.5
        ring.strokeColor = UIColor.blueColor()
        ring.position = CGPoint(x: 80 + 120 * (powernum - 1), y: 80)
        ring.xScale = -1
        ring.zPosition = 1
        ring.zRotation += 1.5 * self.pi
        self.addChild(ring)
    }
    func shildexp(){
        let shild = childNodeWithName("shild")
        self.powershildactive = false
        shild!.xScale = 0.9
        shild!.yScale = 0.9
        shild!.zPosition = 10
        shild!.physicsBody = SKPhysicsBody(circleOfRadius: 140)
        shild!.physicsBody?.allowsRotation = false
        shild!.physicsBody?.affectedByGravity = false
        shild!.physicsBody?.dynamic = false
        shild!.physicsBody?.categoryBitMask = bodytype.powershild.rawValue
        shild!.physicsBody?.collisionBitMask = bodytype.powershild.rawValue
        shild!.physicsBody?.contactTestBitMask = bodytype.enemy1.rawValue + bodytype.enemy2.rawValue
        shild?.runAction(SKAction.rotateByAngle(0, duration: 3), completion: { () -> Void in
            shild!.runAction(SKAction.scaleTo(0, duration: 0.5), completion: { () -> Void in
                shild!.removeFromParent()
                self.powershildbool = false
            })
        })
        numname++
    }
    func expenemy(enemyname : String , enemytype : Int){
        let theenemy = childNodeWithName(enemyname) as! SKSpriteNode
        var smoke = SKEmitterNode(fileNamed: "smoke.sks")
        smoke.name = "smoke" +  String(numname)
        smoke.position = theenemy.position
        smoke.xScale *= 1
        smoke.yScale *= 1
        smoke.zPosition = 11
        self.addChild(smoke)
        let smoke2 = childNodeWithName("smoke" + String(numname)) as! SKEmitterNode
        smoke2.runAction(SKAction.fadeAlphaBy(-0.2, duration: 0.6), completion: { () -> Void in
            smoke2.particleBirthRate = 0
            smoke2.runAction(SKAction.fadeAlphaBy(-0.9, duration: 0.6), completion: { () -> Void in
                smoke2.removeFromParent()
            })
        })
        var exp = SKEmitterNode(fileNamed: "yellowexp.sks")
        exp.name = "exp" +  String(numname)
        exp.position = theenemy.position
        exp.xScale *= 0.4
        exp.yScale *= 0.4
        exp.particleColorSequence = nil
        exp.zPosition = 11
        exp.particleColorBlendFactor = 1
         if (enemytype == 2){
            exp.particleColor = SKColor.redColor()
        }
        self.addChild(exp)
        let exp2 = childNodeWithName("exp" + String(numname)) as! SKEmitterNode
        exp2.runAction(SKAction.fadeAlphaBy(0, duration: 0.01), completion: { () -> Void in
            exp2.particleBirthRate = 0
            exp2.runAction(SKAction.fadeAlphaBy(-0.8, duration: 1), completion: { () -> Void in
                exp2.removeFromParent()
            })
        })
        numname++
        var indexezer = 0, indexinarr = 0
        if (enemytype == 1){
            for enemynameezer in enemies1{
                if enemynameezer == enemyname{
                    indexinarr = indexezer
                }
                indexezer++
            }
            enemies1.removeAtIndex(indexinarr)
        }
        else if (enemytype == 2){
            for enemynameezer in enemies2{
                if enemynameezer == enemyname{
                    indexinarr = indexezer
                }
                indexezer++
            }
            enemies2.removeAtIndex(indexinarr)
        }
        theenemy.removeFromParent()
    }
    func addblack(alpha: CGFloat){
        let black = SKSpriteNode(imageNamed: "black")
        black.name = "black"
        black.position = CGPoint(x: self.view!.bounds.width * 2 / 2, y:  self.view!.bounds.height * 2 / 2)
        black.physicsBody = nil
        black.zPosition = 10
        black.size = CGSize(width:  self.view!.bounds.width * 2  + 100, height:  self.view!.bounds.height * 2  + 100)
        black.alpha = alpha
        self.addChild(black)
    }
    func rndenemypos() -> CGPoint{
        let mindistance : CGFloat = 100
        let myball = childNodeWithName("player")
        var x = CGFloat(arc4random()) %  ( self.view!.bounds.width * 2  - 50) + 25
        var y = CGFloat(arc4random()) %  (1000 - 50) + 25 + 136
        while (x + mindistance > myball?.position.x && x - mindistance < myball?.position.x && y + mindistance > myball?.position.y && y - mindistance < myball?.position.y){
            x = CGFloat(arc4random()) %  (1000 - 50) + 25
            y = CGFloat(arc4random()) %  ( self.view!.bounds.width * 2  - 50) + 25 + 136
        }
        return CGPoint(x: x, y: y)
        
    }
    func movepage (nextbefore : Int){
        if page == 1{
            removepage(1)
        }
        else if (page == 2){
            removepage(2)
        }
        else{
            removepage(3)
        }
        
        if (nextbefore == 1){
            if (page == 1){
                page = 2
            }
            else if ( page == 2){
                page = 3
            }
            else{
                page = 1
            }
        }
        else{
            if ( page == 1){
                page = 3
            }
            else if (page == 2){
                page = 1
            }
            else{
                page = 2
            }
        }
        addpage(page)
    }
    func addstorekoteret(){
        let lblcash = childNodeWithName("lblcash")
        
        let lblselectlevel = SKLabelNode(text: "select level")
        lblselectlevel.position.x =  self.view!.bounds.width * 2  - 20
        lblselectlevel.position.y = childNodeWithName("lblcash")!.position.y
        lblselectlevel.name = "lblselectlevel"
        lblselectlevel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        lblselectlevel.fontColor = UIColor.blueColor()
        self.addChild(lblselectlevel)
        
        let resetgame = SKLabelNode(text: "reset the game")
        resetgame.position.x =  self.view!.bounds.width * 2  / 2
        resetgame.position.y = 170
        resetgame.name = "resetgame"
        resetgame.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        resetgame.fontColor = UIColor.brownColor()
        self.addChild(resetgame)
        
        let lblupgrade = SKLabelNode(fontNamed: "AvenirNext")
        lblupgrade.position.x = 40
        lblupgrade.position.y = 60
        lblupgrade.name = "lblupgrade"
        lblupgrade.text = "upgrade"
        lblupgrade.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        lblupgrade.fontColor = UIColor.orangeColor()
        self.addChild(lblupgrade)
        
        let frameupgrade = SKSpriteNode(imageNamed: "frame")
        frameupgrade.physicsBody = nil
        frameupgrade.position.x = 95
        frameupgrade.position.y = 70
        frameupgrade.xScale /= 2
        frameupgrade.yScale /= 3
        frameupgrade.name = "frameupgrade"
        addChild(frameupgrade)
        
        let lblselectball = SKLabelNode(fontNamed: "AvenirNext")
        lblselectball.position.x =  self.view!.bounds.width * 2  / 2 - 35
        lblselectball.position.y = 60
        lblselectball.name = "lblselectball"
        lblselectball.text = "select ball"
        lblselectball.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        lblselectball.fontColor = UIColor.orangeColor()
        self.addChild(lblselectball)
        
        let frameselectball = SKSpriteNode(imageNamed: "frame")
        frameselectball.physicsBody = nil
        frameselectball.position.x =  self.view!.bounds.width * 2  / 2 - 35
        frameselectball.position.y = 70
        frameselectball.xScale /= 1.9
        frameselectball.yScale /= 3
        frameselectball.name = "frameselectball"
        addChild(frameselectball)
        
        let lblselectpowerapps = SKLabelNode(fontNamed: "AvenirNext")
        lblselectpowerapps.fontSize /= 1.2
        lblselectpowerapps.position.x =  self.view!.bounds.width * 2  - 35
        lblselectpowerapps.position.y = 60
        lblselectpowerapps.name = "lblselectpowerapps"
        lblselectpowerapps.text = "select power ups"
        lblselectpowerapps.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        lblselectpowerapps.fontColor = UIColor.orangeColor()
        self.addChild(lblselectpowerapps)
        
        let frameselectpowerapps = SKSpriteNode(imageNamed: "frame")
        frameselectpowerapps.physicsBody = nil
        frameselectpowerapps.position.x =  self.view!.bounds.width * 2  - 137
        frameselectpowerapps.position.y = 70
        frameselectpowerapps.xScale /= 1.4
        frameselectpowerapps.yScale /= 3
        frameselectpowerapps.name = "frameselectpowerapps"
        addChild(frameselectpowerapps)
        
        let touchalert = NSUserDefaults.standardUserDefaults().objectForKey("touchalert") as! Bool
        if !touchalert{
            let alert = SKSpriteNode(imageNamed: "alert")
            alert.name = "alert"
            alert.position = CGPoint(x: frameselectpowerapps.position.x + 70, y: frameselectpowerapps.position.y + 30)
            alert.physicsBody = nil
            alert.zPosition = 13
            alert.xScale *= 1
            alert.yScale *= 1
            alert.alpha = 0
            self.addChild(alert)
            
            alert.runAction(SKAction.fadeAlphaTo(1, duration: 0.7))
            alert.runAction(SKAction.scaleTo(0.2, duration: 0.5), completion: { () -> Void in
                alert.runAction(SKAction.scaleBy(0.5, duration: 0.2))
            })

        }
    }
    func removestorekoteret(){
        childNodeWithName("lblselectlevel")?.removeFromParent()
        childNodeWithName("resetgame")?.removeFromParent()
        childNodeWithName("lblupgrade")?.removeFromParent()
        childNodeWithName("frameupgrade")?.removeFromParent()
        childNodeWithName("lblselectball")?.removeFromParent()
        childNodeWithName("frameselectball")?.removeFromParent()
        childNodeWithName("lblselectpowerapps")?.removeFromParent()
        childNodeWithName("frameselectpowerapps")?.removeFromParent()
        childNodeWithName("alert")?.removeFromParent()
    }
    func addbuystorekoteret(page : Int){
        self.inbuystore = true
        self.canremovebuystore = false
        self.buystorepage = page
        
        let black = SKSpriteNode(imageNamed: "black")
        black.name = "black2"
        black.position = CGPoint(x:  self.view!.bounds.width * 2 / 2, y:  self.view!.bounds.height * 2 / 2)
        black.physicsBody = nil
        black.zPosition = 900
        black.size = CGSize(width:  self.view!.bounds.width * 2  + 100, height:  self.view!.bounds.height * 2  + 100)
        black.alpha = 0
        self.addChild(black)
        
        childNodeWithName("black2")?.runAction(SKAction.fadeAlphaTo(0.9, duration: 0.25), completion: { () -> Void in
            let buystoreframe = SKSpriteNode(imageNamed: "blueframe")
            buystoreframe.name = "buystoreframe"
            buystoreframe.xScale *= 2
            buystoreframe.yScale *= 2.5
            buystoreframe.position = CGPoint(x: -buystoreframe.frame.width * 0.5, y:  self.view!.bounds.height * 2 / 2)
            buystoreframe.physicsBody = nil
            buystoreframe.zPosition = 1000
            buystoreframe.alpha = 1
            self.addChild(buystoreframe)
            buystoreframe.runAction(SKAction.moveToX( self.view!.bounds.width * 2  / 2, duration: 0.5), completion: { () -> Void in
                let exitbuystore = SKSpriteNode(imageNamed: "x-icon.png")
                exitbuystore.name = "exitbuystore"
                exitbuystore.xScale *= 0.1
                exitbuystore.yScale *= 0.1
                exitbuystore.position = CGPoint(x:  self.view!.bounds.width * 2  + exitbuystore.frame.width * 0.5, y:  self.view!.bounds.height * 2 / 2 + 255)
                exitbuystore.physicsBody = nil
                exitbuystore.zPosition = 1001
                exitbuystore.alpha = 1
                self.addChild(exitbuystore)
                exitbuystore.runAction(SKAction.moveToX( self.view!.bounds.width * 2  - exitbuystore.frame.width / 2 - 45, duration: 0.5))
                exitbuystore.runAction(SKAction.rotateToAngle(self.pi / 2, duration: 0.5), completion: { () -> Void in
                    self.canremovebuystore = true
                })
            })
            let lblbuycoins = SKLabelNode(text: String("Coins"))
            lblbuycoins.fontName = "Verdana"
            lblbuycoins.position.x = -buystoreframe.frame.width  + 50
            lblbuycoins.position.y =  self.view!.bounds.height * 2 / 2 + 250
            lblbuycoins.zPosition = 1001
            lblbuycoins.name = "lblbuycoins"
            lblbuycoins.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
                lblbuycoins.fontColor = UIColor.yellowColor()
                if page == 1{
                    lblbuycoins.fontColor = UIColor.redColor()
                }
            self.addChild(lblbuycoins)
            lblbuycoins.runAction(SKAction.moveByX(buystoreframe.frame.width , y: 0, duration: 0.5))
            let lblbuyenergy = SKLabelNode(text: String("Energy"))
            lblbuyenergy.fontName = "Verdana"
            lblbuyenergy.position.x = -buystoreframe.frame.width + 220
            lblbuyenergy.position.y =  self.view!.bounds.height * 2 / 2 + 250
            lblbuyenergy.zPosition = 1001
            lblbuyenergy.name = "lblbuyenergy"
            lblbuyenergy.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            lblbuyenergy.fontColor = UIColor.yellowColor()
            if page == 2{
                lblbuyenergy.fontColor = UIColor.redColor()
            }
            self.addChild(lblbuyenergy)
            lblbuyenergy.runAction(SKAction.moveByX(buystoreframe.frame.width, y: 0, duration: 0.5))
            let lblbuypacks = SKLabelNode(text: String("Packs"))
            lblbuypacks.fontName = "Verdana"
            lblbuypacks.position.x = -buystoreframe.frame.width + 390
            lblbuypacks.position.y =  self.view!.bounds.height * 2 / 2 + 250
            lblbuypacks.zPosition = 1001
            lblbuypacks.name = "lblbuypacks"
            lblbuypacks.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
            lblbuypacks.fontColor = UIColor.yellowColor()
            if page == 3{
                lblbuyenergy.fontColor = UIColor.redColor()
            }
            self.addChild(lblbuypacks)
            lblbuypacks.runAction(SKAction.moveByX(buystoreframe.frame.width, y: 0, duration: 0.5))
            
        })
    }
    func removebuystorekoteret(){
        self.canremovebuystore = false
        self.buystorepage = -1
        let buystoreframe = self.childNodeWithName("buystoreframe")
        let exitbuystore = self.childNodeWithName("exitbuystore")
        buystoreframe?.runAction(SKAction.moveByX(-buystoreframe!.frame.width, y: 0, duration: 0.5), completion: { () -> Void in
            buystoreframe!.removeFromParent()
            self.childNodeWithName("black2")?.runAction(SKAction.fadeAlphaTo(0, duration: 0.25), completion: { () -> Void in
                self.childNodeWithName("black2")!.removeFromParent()
                self.inbuystore = false
            })
        })
        exitbuystore?.runAction(SKAction.rotateToAngle(-CGFloat(self.pi) / 2, duration: 0.5))
        exitbuystore?.runAction(SKAction.moveByX(exitbuystore!.frame.width + 45, y: 0, duration: 0.5), completion: { () -> Void in
            exitbuystore!.removeFromParent()
        })
        self.childNodeWithName("lblbuycoins")?.runAction(SKAction.moveByX(-buystoreframe!.frame.width, y: 0, duration: 0.5), completion: { () -> Void in
            self.childNodeWithName("lblbuycoins")!.removeFromParent()
        })
        self.childNodeWithName("lblbuyenergy")?.runAction(SKAction.moveByX(-buystoreframe!.frame.width, y: 0, duration: 0.5), completion: { () -> Void in
            self.childNodeWithName("lblbuyenergy")!.removeFromParent()
        })
        self.childNodeWithName("lblbuypacks")?.runAction(SKAction.moveByX(-buystoreframe!.frame.width, y: 0, duration: 0.5), completion: { () -> Void in
            self.childNodeWithName("lblbuypacks")!.removeFromParent()
        })
    }
    func addpage(pagenum : Int){
        if (pagenum == 1){
            // shoot speed
            let frameshootspeed = SKSpriteNode(imageNamed: "frame")
            frameshootspeed.physicsBody = nil
            frameshootspeed.position.x = 162
            frameshootspeed.position.y =  self.view!.bounds.height * 2  - 300
            frameshootspeed.name = "frameshootspeed"
            addChild(frameshootspeed)
            
            let lblshootspeed = SKLabelNode(text: "shooting faster")
            lblshootspeed.position.x = 162
            lblshootspeed.position.y =  self.view!.bounds.height * 2  - 250
            lblshootspeed.name = "lblshootspeed"
            lblshootspeed.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            lblshootspeed.fontColor = UIColor.redColor()
            self.addChild(lblshootspeed)
            
            let lblshootspeedprice = SKLabelNode(fontNamed: "AvenirNext-Bold")
            if (NSUserDefaults().valueForKey("shootspeed") as! Int) == 10{
                 lblshootspeedprice.text = ""
            }
            else{
                lblshootspeedprice.text = String(shootspeedprice[(NSUserDefaults().valueForKey("shootspeed") as! Int)]) + "$"
            }
            lblshootspeedprice.position.x = 162
            lblshootspeedprice.position.y =  self.view!.bounds.height * 2  - 380
            lblshootspeedprice.name = "lblshootspeedprice"
            lblshootspeedprice.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            lblshootspeedprice.fontColor = UIColor.greenColor()
            self.addChild(lblshootspeedprice)
            
            let lblshootspeedstock = SKLabelNode(text: String(NSUserDefaults.standardUserDefaults().valueForKey("shootspeed") as! Int) + "/10")
            lblshootspeedstock.position.x = 162
            lblshootspeedstock.position.y =  self.view!.bounds.height * 2  - 335
            lblshootspeedstock.name = "lblshootspeedstock"
            lblshootspeedstock.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            lblshootspeedstock.fontColor = UIColor.blueColor()
            self.addChild(lblshootspeedstock)
            
            // move speed
            let framemovespeed = SKSpriteNode(imageNamed: "frame")
            framemovespeed.physicsBody = nil
            framemovespeed.position.x = 162 * 3 - 6
            framemovespeed.position.y =  self.view!.bounds.height * 2  - 300
            framemovespeed.name = "framemovespeed"
            addChild(framemovespeed)
            
            let lblmovespeed = SKLabelNode(text: "moving faster")
            lblmovespeed.position.x = 162 * 3 - 6
            lblmovespeed.position.y =  self.view!.bounds.height * 2  - 250
            lblmovespeed.name = "lblmovespeed"
            lblmovespeed.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            lblmovespeed.fontColor = UIColor.redColor()
            self.addChild(lblmovespeed)
            
            let lblmovespeedprice = SKLabelNode(fontNamed: "AvenirNext-Bold")
            if ((NSUserDefaults().valueForKey("movespeed") as! Int) == 10){
                 lblmovespeedprice.text = ""
            }
            else{
                lblmovespeedprice.text = String(movespeedprice[(NSUserDefaults().valueForKey("movespeed") as! Int)]) + "$"

            }
            lblmovespeedprice.position.x = 162 * 3 - 6
            lblmovespeedprice.position.y =  self.view!.bounds.height * 2  - 380
            lblmovespeedprice.name = "lblmovespeedprice"
            lblmovespeedprice.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            lblmovespeedprice.fontColor = UIColor.greenColor()
            self.addChild(lblmovespeedprice)
            
            let lblmovespeedstock = SKLabelNode(text: String(NSUserDefaults.standardUserDefaults().valueForKey("movespeed") as! Int) + "/10")
            lblmovespeedstock.position.x = 162 * 3 - 6
            lblmovespeedstock.position.y =  self.view!.bounds.height * 2  - 335
            lblmovespeedstock.name = "lblmovespeedstock"
            lblmovespeedstock.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            lblmovespeedstock.fontColor = UIColor.blueColor()
            self.addChild(lblmovespeedstock)
        }
        else if (pagenum == 2){
            addsmartpage(smart)
        }
        else{
            NSUserDefaults.standardUserDefaults().setObject(true, forKey: "touchalert")
            childNodeWithName("alert")?.runAction(SKAction.rotateByAngle(-10, duration: 1))
            childNodeWithName("alert")?.runAction(SKAction.moveToX(2000, duration: 3), completion: { () -> Void in
                self.childNodeWithName("alert")?.removeFromParent()
            })
            let selectedpower = NSUserDefaults.standardUserDefaults().valueForKey("selectedpower") as! [String]
            let framepower1 = SKSpriteNode(imageNamed: "frame2")
            framepower1.physicsBody = nil
            framepower1.position.x = 95
            framepower1.position.y = 930
            framepower1.size.height = 100
            framepower1.size.width = 106
            framepower1.name = "framepower1"
            addChild(framepower1)
            if (selectedpower[0] != "nil"){
                let imgpower1 = SKSpriteNode(imageNamed: selectedpower[0])
                imgpower1.physicsBody = nil
                imgpower1.position.x = 95
                imgpower1.position.y = 930
                imgpower1.size.height = 80
                imgpower1.size.width = 80
                imgpower1.name = "imgpower1"
                addChild(imgpower1)
            }
            let framepower2 = SKSpriteNode(imageNamed: "frame2")
            framepower2.physicsBody = nil
            framepower2.position.x = 245
            framepower2.position.y = 930
            framepower2.size.height = 100
            framepower2.size.width = 106
            framepower2.name = "framepower2"
            addChild(framepower2)
            if (selectedpower[1] != "nil"){
                let imgpower2 = SKSpriteNode(imageNamed: selectedpower[1])
                imgpower2.physicsBody = nil
                imgpower2.position.x = 245
                imgpower2.position.y = 930
                imgpower2.size.height = 80
                imgpower2.size.width = 80
                imgpower2.name = "imgpower2"
                addChild(imgpower2)
            }
            let framepower3 = SKSpriteNode(imageNamed: "frame2")
            framepower3.physicsBody = nil
            framepower3.position.x = 395
            framepower3.position.y = 930
            framepower3.size.height = 100
            framepower3.size.width = 106
            framepower3.name = "framepower3"
            addChild(framepower3)
            if (selectedpower[2] != "nil"){
                let imgpower3 = SKSpriteNode(imageNamed: selectedpower[2])
                imgpower3.physicsBody = nil
                imgpower3.position.x = 395
                imgpower3.position.y = 930
                imgpower3.size.height = 80
                imgpower3.size.width = 80
                imgpower3.name = "imgpower3"
                addChild(imgpower3)
            }
            let framepower4 = SKSpriteNode(imageNamed: "frame2")
            framepower4.physicsBody = nil
            framepower4.position.x = 545
            framepower4.position.y = 930
            framepower4.size.height = 100
            framepower4.size.width = 106
            framepower4.name = "framepower4"
            addChild(framepower4)
            if (selectedpower[3] != "nil"){
                let imgpower4 = SKSpriteNode(imageNamed: selectedpower[3])
                imgpower4.physicsBody = nil
                imgpower4.position.x = 545
                imgpower4.position.y = 930
                imgpower4.size.height = 80
                imgpower4.size.width = 80
                imgpower4.name = "imgpower4"
                addChild(imgpower4)
            }
            let framepower5 = SKSpriteNode(imageNamed: "frame2")
            framepower5.physicsBody = nil
            framepower5.position.x = 76
            framepower5.position.y = 650
            framepower5.size.height = 86
            framepower5.size.width = 92
            framepower5.name = "framepower5"
            addChild(framepower5)
            if (selectedpower[4] != "nil"){
                let imgpower5 = SKSpriteNode(imageNamed: selectedpower[4])
                imgpower5.physicsBody = nil
                imgpower5.position.x = 76
                imgpower5.position.y = 650
                imgpower5.size.height = 70
                imgpower5.size.width = 70
                imgpower5.name = "imgpower5"
                addChild(imgpower5)
            }
            let framepower6 = SKSpriteNode(imageNamed: "frame2")
            framepower6.physicsBody = nil
            framepower6.position.x = 198
            framepower6.position.y = 650
            framepower6.size.height = 86
            framepower6.size.width = 92
            framepower6.name = "framepower6"
            addChild(framepower6)
            if (selectedpower[5] != "nil"){
                let imgpower6 = SKSpriteNode(imageNamed: selectedpower[5])
                imgpower6.physicsBody = nil
                imgpower6.position.x = 198
                imgpower6.position.y = 650
                imgpower6.size.height = 70
                imgpower6.size.width = 70
                imgpower6.name = "imgpower6"
                addChild(imgpower6)
            }
            let framepower7 = SKSpriteNode(imageNamed: "frame2")
            framepower7.physicsBody = nil
            framepower7.position.x = 320
            framepower7.position.y = 650
            framepower7.size.height = 86
            framepower7.size.width = 92
            framepower7.name = "framepower7"
            addChild(framepower7)
            if (selectedpower[6] != "nil"){
                let imgpower7 = SKSpriteNode(imageNamed: selectedpower[6])
                imgpower7.physicsBody = nil
                imgpower7.position.x = 320
                imgpower7.position.y = 650
                imgpower7.size.height = 70
                imgpower7.size.width = 70
                imgpower7.name = "imgpower7"
                addChild(imgpower7)
            }
            let framepower8 = SKSpriteNode(imageNamed: "frame2")
            framepower8.physicsBody = nil
            framepower8.position.x = 442
            framepower8.position.y = 650
            framepower8.size.height = 86
            framepower8.size.width = 92
            framepower8.name = "framepower8"
            addChild(framepower8)
            if (selectedpower[7] != "nil"){
                let imgpower8 = SKSpriteNode(imageNamed: selectedpower[7])
                imgpower8.physicsBody = nil
                imgpower8.position.x = 442
                imgpower8.position.y = 650
                imgpower8.size.height = 70
                imgpower8.size.width = 70
                imgpower8.name = "imgpower8"
                addChild(imgpower8)
            }
            let framepower9 = SKSpriteNode(imageNamed: "frame2")
            framepower9.physicsBody = nil
            framepower9.position.x = 564
            framepower9.position.y = 650
            framepower9.size.height = 86
            framepower9.size.width = 92
            framepower9.name = "framepower9"
            addChild(framepower9)
            if (selectedpower[8] != "nil"){
                let imgpower9 = SKSpriteNode(imageNamed: selectedpower[8])
                imgpower9.physicsBody = nil
                imgpower9.position.x = 564
                imgpower9.position.y = 650
                imgpower9.size.height = 70
                imgpower9.size.width = 70
                imgpower9.name = "imgpower9"
                addChild(imgpower9)
            }
            let framepower10 = SKSpriteNode(imageNamed: "frame2")
            framepower10.physicsBody = nil
            framepower10.position.x = 76
            framepower10.position.y = 500
            framepower10.size.height = 86
            framepower10.size.width = 92
            framepower10.name = "framepower10"
            addChild(framepower10)
            if (selectedpower[9] != "nil"){
                let imgpower10 = SKSpriteNode(imageNamed: selectedpower[9])
                imgpower10.physicsBody = nil
                imgpower10.position.x = 76
                imgpower10.position.y = 500
                imgpower10.size.height = 70
                imgpower10.size.width = 70
                imgpower10.name = "imgpower10"
                addChild(imgpower10)
            }
            let framepower11 = SKSpriteNode(imageNamed: "frame2")
            framepower11.physicsBody = nil
            framepower11.position.x = 198
            framepower11.position.y = 500
            framepower11.size.height = 86
            framepower11.size.width = 92
            framepower11.name = "framepower11"
            addChild(framepower11)
            if (selectedpower[10] != "nil"){
                let imgpower11 = SKSpriteNode(imageNamed: selectedpower[10])
                imgpower11.physicsBody = nil
                imgpower11.position.x = 198
                imgpower11.position.y = 500
                imgpower11.size.height = 70
                imgpower11.size.width = 70
                imgpower11.name = "imgpower11"
                addChild(imgpower11)
            }
            let framepower12 = SKSpriteNode(imageNamed: "frame2")
            framepower12.physicsBody = nil
            framepower12.position.x = 320
            framepower12.position.y = 500
            framepower12.size.height = 86
            framepower12.size.width = 92
            framepower12.name = "framepower12"
            addChild(framepower12)
            if (selectedpower[11] != "nil"){
                let imgpower12 = SKSpriteNode(imageNamed: selectedpower[11])
                imgpower12.physicsBody = nil
                imgpower12.position.x = 320
                imgpower12.position.y = 500
                imgpower12.size.height = 70
                imgpower12.size.width = 70
                imgpower12.name = "imgpower12"
                addChild(imgpower12)
            }
            let framepower13 = SKSpriteNode(imageNamed: "frame2")
            framepower13.physicsBody = nil
            framepower13.position.x = 442
            framepower13.position.y = 500
            framepower13.size.height = 86
            framepower13.size.width = 92
            framepower13.name = "framepower13"
            addChild(framepower13)
            if (selectedpower[12] != "nil"){
                let imgpower13 = SKSpriteNode(imageNamed: selectedpower[12])
                imgpower13.physicsBody = nil
                imgpower13.position.x = 442
                imgpower13.position.y = 500
                imgpower13.size.height = 70
                imgpower13.size.width = 70
                imgpower13.name = "imgpower13"
                addChild(imgpower13)
            }
            let framepower14 = SKSpriteNode(imageNamed: "frame2")
            framepower14.physicsBody = nil
            framepower14.position.x = 564
            framepower14.position.y = 500
            framepower14.size.height = 86
            framepower14.size.width = 92
            framepower14.name = "framepower14"
            addChild(framepower14)
            if (selectedpower[13] != "nil"){
                let imgpower14 = SKSpriteNode(imageNamed: selectedpower[13])
                imgpower14.physicsBody = nil
                imgpower14.position.x = 564
                imgpower14.position.y = 500
                imgpower14.size.height = 70
                imgpower14.size.width = 70
                imgpower14.name = "imgpower14"
                addChild(imgpower14)
            }
        }
    }
    func removepage(pagenum : Int){
        if (pagenum == 1){
            childNodeWithName("frameshootspeed")?.removeFromParent()
            childNodeWithName("framemovespeed")?.removeFromParent()
            childNodeWithName("lblshootspeed")?.removeFromParent()
            childNodeWithName("lblmovespeed")?.removeFromParent()
            childNodeWithName("lblshootspeedstock")?.removeFromParent()
            childNodeWithName("lblmovespeedstock")?.removeFromParent()
            childNodeWithName("lblshootspeedprice")?.removeFromParent()
            childNodeWithName("lblmovespeedprice")?.removeFromParent()
        }
        else if ( pagenum == 2){
            childNodeWithName("playerimg")?.removeFromParent()
            childNodeWithName("lblsmarttitle")?.removeFromParent()
            childNodeWithName("lblsmarttitle2")?.removeFromParent()
            childNodeWithName("lblselectbuy")?.removeFromParent()
            childNodeWithName("lblnextsmart")?.removeFromParent()
            childNodeWithName("lblbeforesmart")?.removeFromParent()
            childNodeWithName("smartbarakimg")?.removeFromParent()
            childNodeWithName("lblsmartbarak")?.removeFromParent()
        }
        else{
            for i in 1...14{
                childNodeWithName("imgpower" + String(i))?.removeFromParent()
                childNodeWithName("framepower" + String(i))?.removeFromParent()
            }
        }
    }
    func addselectlevelpage(){
        self.removepage(self.page)
        self.removestorekoteret()
        
        self.inselectlevelpage = true
        
        let lblplay = SKLabelNode(text: "play")
        lblplay.position.x =  self.view!.bounds.width * 2  - 40
        lblplay.position.y = childNodeWithName("lblcash")!.position.y - 3
        lblplay.name = "lblplay"
        lblplay.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        lblplay.fontColor = UIColor.blueColor()
        lblplay.fontSize += 8
        lblplay.fontName = "Arial"
        self.addChild(lblplay)
        
        let levelselected = NSUserDefaults.standardUserDefaults().valueForKey("levelselected") as! Int
        var img1 = "level1 selected.png" , img2 = "level2.png"
        
        if levelselected == 2{
            img1 = "level1.png"
            img2 = "level2 selected.png"
        }
        let levelimg1 = SKSpriteNode(imageNamed: img1)
        levelimg1.physicsBody = nil
        levelimg1.position.x =  self.view!.bounds.width * 2  / 2
        levelimg1.position.y = 800
        levelimg1.xScale *= 0.95
        levelimg1.yScale *= 0.95
        levelimg1.name = "levelimg1"
        self.addChild(levelimg1)
        let levelimg2 = SKSpriteNode(imageNamed: img2)
        levelimg2.physicsBody = nil
        levelimg2.position.x =  self.view!.bounds.width * 2  / 2
        levelimg2.position.y = 280
        levelimg2.xScale *= 0.95
        levelimg2.yScale *= 0.95
        levelimg2.name = "levelimg2"
        self.addChild(levelimg2)
        
        let black = childNodeWithName("black")
        black!.runAction(SKAction.fadeOutWithDuration(0.5), completion: { () -> Void in
            self.inanimation = false
            self.childNodeWithName("black")?.removeFromParent()
            
        })

    }
    func removeselectlevelpage(){
        self.inselectlevelpage = false
        self.childNodeWithName("lblplay")?.removeFromParent()
        self.childNodeWithName("levelimg1")?.removeFromParent()
        self.childNodeWithName("levelimg2")?.removeFromParent()
    }
    func baraktimer(){
        var barakarr = NSUserDefaults.standardUserDefaults().objectForKey("barakarr") as! [Int]
        let selectedsmart = NSUserDefaults.standardUserDefaults().objectForKey("selectedsmart") as! Int
        var index = 0
        for barak in barakarr{
            if barak < 30{
                barakarr[index]++
            }
            index++
        }
        if self.childNodeWithName("lblbarak") != nil{
            let lblbarak = self.childNodeWithName("lblbarak") as! SKLabelNode
            lblbarak.text = String(barakarr[selectedsmart - 1] + 1) + "/30"
        }
        NSUserDefaults.standardUserDefaults().setValue(barakarr, forKey: "barakarr")
        NSUserDefaults.standardUserDefaults().setValue(NSDate(), forKey: "timefrombarak")
    }
    func movebuypage (pagenum : Int){
        self.buystorepage = pagenum
        let lblbuycoins = childNodeWithName("lblbuycoins") as! SKLabelNode
        let lblbuyenergy = childNodeWithName("lblbuyenergy") as! SKLabelNode
        let lblbuypacks = childNodeWithName("lblbuypacks") as! SKLabelNode
        lblbuycoins.fontColor = UIColor.yellowColor()
        lblbuyenergy.fontColor = UIColor.yellowColor()
        lblbuypacks.fontColor = UIColor.yellowColor()
        if pagenum == 1{
            lblbuycoins.fontColor = UIColor.redColor()
        }else if pagenum == 2{
            lblbuyenergy.fontColor = UIColor.redColor()
        }else{
            lblbuypacks.fontColor = UIColor.redColor()
        }
        self.removebuypage(self.buystorepage)
        self.addbuypage(pagenum)
    }
    func addbuypage(pagenum : Int){
        
    }
    func removebuypage(pagenum : Int){
        
    }
    func movesmartpage (nextbefore : Int){
        if page == 1{
            removesmartpage(1)
        }
        else if (page == 2){
            removesmartpage(2)
        }
        else{
            removesmartpage(3)
        }
        
        if (nextbefore == 1){
            if (smart == 1){
                smart = 2
            }
            else if ( smart == 2){
                smart = 3
            }
            else{
                smart = 1
            }
        }
        else{
            if ( smart == 1){
                smart = 3
            }
            else if (smart == 2){
                smart = 1
            }
            else{
                smart = 2
            }
        }
        addsmartpage(smart)
    }
    func addsmartpage (pagenum : Int){
        var imgname = "player - one ball army"
        if (pagenum == 2){
            imgname = "player2 - one ball army"
        }
        else if (pagenum == 3){
            imgname = "player3 - one ball army"
        }
        let playerimg = SKSpriteNode(imageNamed: imgname)
        playerimg.physicsBody = nil
        playerimg.position.x = 150
        playerimg.position.y =  self.view!.bounds.height * 2  - 350
        playerimg.name = "playerimg"
        addChild(playerimg)
        
        let lblsmarttitle = SKLabelNode(fontNamed: "Arial")
        lblsmarttitle.text = smarttitle[pagenum - 1]
        lblsmarttitle.fontSize = 22
        lblsmarttitle.position.x = 150 * 2
        lblsmarttitle.position.y =  self.view!.bounds.height * 2  - 300
        lblsmarttitle.name = "lblsmarttitle"
        lblsmarttitle.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        lblsmarttitle.fontColor = UIColor.blackColor()
        self.addChild(lblsmarttitle)
        
        let lblsmarttitle2 = SKLabelNode(fontNamed: "Arial")
        lblsmarttitle2.text = smarttitle2[pagenum - 1]
        lblsmarttitle2.fontSize = 22
        lblsmarttitle2.position.x = 150 * 2
        lblsmarttitle2.position.y =  self.view!.bounds.height * 2  - 300 - 30
        lblsmarttitle2.name = "lblsmarttitle2"
        lblsmarttitle2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        lblsmarttitle2.fontColor = UIColor.blackColor()
        self.addChild(lblsmarttitle2)
        
        let smartbarakimg = SKSpriteNode(imageNamed: "lightning-icon")
        smartbarakimg.physicsBody = nil
        smartbarakimg.position.x = lblsmarttitle2.position.x
        smartbarakimg.position.y = lblsmarttitle2.position.y - 70
        smartbarakimg.xScale *= 0.17
        smartbarakimg.yScale *= 0.17
        smartbarakimg.name = "smartbarakimg"
        self.addChild(smartbarakimg)
        
        let barakarr = NSUserDefaults.standardUserDefaults().valueForKey("barakarr") as! [Int]
        let lblsmartbarak = SKLabelNode(text: String(barakarr[pagenum - 1]) + "/30")
        lblsmartbarak.fontName = "Verdana"
        lblsmartbarak.position.x = smartbarakimg.position.x + 25
        lblsmartbarak.position.y = smartbarakimg.position.y - 14
        lblsmartbarak.name = "lblsmartbarak"
        lblsmartbarak.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        lblsmartbarak.fontColor = UIColor.yellowColor()
        self.addChild(lblsmartbarak)
        
        let lblselectbuy = SKLabelNode(fontNamed: "Arial")
        let arr = NSUserDefaults.standardUserDefaults().valueForKey("smartarr") as! [Int]
        if ( arr[pagenum - 1] == 1){
            if (NSUserDefaults.standardUserDefaults().valueForKey("selectedsmart") as! Int == smart){
                lblselectbuy.text = "selected"
                lblselectbuy.fontColor = UIColor.grayColor()
            }
            else{
                lblselectbuy.text = "select"
                lblselectbuy.fontColor = UIColor.greenColor()
            }
        }
        else{
            lblselectbuy.text = String(smartprice[pagenum - 1]) + "$"
            lblselectbuy.fontColor = UIColor.greenColor()
        }
        lblselectbuy.position.x =  self.view!.bounds.width * 2  / 2
        lblselectbuy.position.y = 380
        lblselectbuy.name = "lblselectbuy"
        lblselectbuy.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        self.addChild(lblselectbuy)
        
        let lblnextsmart = SKLabelNode(fontNamed: "Arial")
        lblnextsmart.text = ">"
        lblnextsmart.fontSize += 15
        lblnextsmart.position.x =  self.view!.bounds.width * 2  - 30
        lblnextsmart.position.y =  self.view!.bounds.height * 2  / 2
        lblnextsmart.name = "lblnextsmart"
        lblnextsmart.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        lblnextsmart.fontColor = UIColor.brownColor()
        self.addChild(lblnextsmart)
        
        let lblbeforesmart = SKLabelNode(fontNamed: "Arial")
        lblbeforesmart.text = "<"
        lblbeforesmart.fontSize += 15
        lblbeforesmart.position.x = 50
        lblbeforesmart.position.y =  self.view!.bounds.height * 2  / 2
        lblbeforesmart.name = "lblbeforesmart"
        lblbeforesmart.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
        lblbeforesmart.fontColor = UIColor.brownColor()
        self.addChild(lblbeforesmart)
    }
    func removesmartpage (pagenum : Int){
        childNodeWithName("playerimg")?.removeFromParent()
        childNodeWithName("lblsmarttitle")?.removeFromParent()
        childNodeWithName("lblsmarttitle2")?.removeFromParent()
        childNodeWithName("lblselectbuy")?.removeFromParent()
        childNodeWithName("lblnextsmart")?.removeFromParent()
        childNodeWithName("lblbeforesmart")?.removeFromParent()
        childNodeWithName("smartbarakimg")?.removeFromParent()
        childNodeWithName("lblsmartbarak")?.removeFromParent()
    }
    func chkplayerpos(playerposition : CGPoint) -> Bool{
        
        let mindistance : CGFloat = 100
        let myball = childNodeWithName("player")
        var x = playerposition.x
        var y = playerposition.y
        for enemyname in enemies1{
            var enemy = childNodeWithName(enemyname)
            if (x + mindistance > enemy?.position.x && x - mindistance < enemy?.position.x && y + mindistance > enemy?.position.y && y - mindistance < enemy?.position.y){
                return false
            }
        }
        for enemyname in enemies2{
            var enemy = childNodeWithName(enemyname)
            if (x + mindistance > enemy?.position.x && x - mindistance < enemy?.position.x && y + mindistance > enemy?.position.y && y - mindistance < enemy?.position.y){
                return false
            }
        }
        return true
    }
    func rndplayerpos() -> CGPoint{
        let player = childNodeWithName("player")
        var x = CGFloat(arc4random()) %  ( self.view!.bounds.width * 2  - 50) + 25
        var y = CGFloat(arc4random()) %  (1000 - 50) + 25 + 136
        while (!chkplayerpos(CGPoint(x: x, y: y))){
            y = CGFloat(arc4random()) %  (1000 - 50) + 25 + 136
            x = CGFloat(arc4random()) %  ( self.view!.bounds.width * 2  - 50) + 25
        }
        return CGPoint(x: x, y: y)
    }
    func playertele(){
        let player = self.childNodeWithName("player")
        if (player?.physicsBody?.dynamic == true){
        let pos1 = player?.position
        player?.position = rndplayerpos()
        let pos2 = player?.position
        player?.removeFromParent()
        var tele = SKEmitterNode(fileNamed: "teleport.sks")
        tele.name = "tele" +  String(numname)
        tele.position = pos1!
        tele.xScale *= 0.4
        tele.yScale *= 0.4
        self.addChild(tele)
        let tele2 = childNodeWithName("tele" + String(numname)) as! SKEmitterNode
        tele2.runAction(SKAction.moveTo(pos2!, duration: 0.5), completion: { () -> Void in
            self.addplayer(pos2! , addtimer: false)
            tele2.particleBirthRate = 0
            tele2.runAction(SKAction.fadeAlphaBy(-0.8, duration: 1), completion: { () -> Void in
                tele2.removeFromParent()
            })
        })
        numname++

        player?.physicsBody?.dynamic = false
        player?.physicsBody?.dynamic = true
        }
    }
    func shootingtimer(){
        
        if (!self.inshop && !self.gameoverbool){
            updaterechargepower()
            if  !powerfastshootingbool{
                let player = childNodeWithName("player")
                var dx :CGFloat = 10, dy : CGFloat = 10
                //recharge power
                
                if (!powerfastshootingbool && player != nil && (enemies1.count > 0 || enemies2.count > 0 || enemies3.count > 0)){
                    var nearenemyinfo : CGFloat = 2000
                    for enemyname in enemies1{
                        var enemy = childNodeWithName(enemyname)
                        if (abs(player!.position.x - enemy!.position.x) + abs(player!.position.y - enemy!.position.y) < nearenemyinfo){
                            nearenemyname = enemy!.name!
                            nearenemyinfo = abs(player!.position.x - enemy!.position.x) + abs(player!.position.y - enemy!.position.y)
                        }
                    }
                    for enemyname in enemies2{
                        var enemy = childNodeWithName(enemyname)
                        if (abs(player!.position.x - enemy!.position.x) + abs(player!.position.y - enemy!.position.y) < nearenemyinfo){
                            nearenemyname = enemy!.name!
                            nearenemyinfo = abs(player!.position.x - enemy!.position.x) + abs(player!.position.y - enemy!.position.y)
                        }
                    }
                    
                    let enemy = childNodeWithName(nearenemyname)
                    var moveto = enemy?.position
                    if (player?.position.x < 100 && player?.position.y < 100 + 136){
                        moveto = CGPoint(x: -500, y: -500)
                    }
                    else if (player?.position.x < 100 && player?.position.y > 1000 - 100){
                        moveto = CGPoint(x: -500, y: 1000 + 500)
                    }
                    else if (player?.position.x >  self.view!.bounds.width * 2  - 100 && player?.position.y < 100 + 136){
                        moveto = CGPoint(x:  self.view!.bounds.width * 2  + 500, y: -500)
                    }
                    else if (player?.position.x >  self.view!.bounds.width * 2  - 100 && player?.position.y >  self.view!.bounds.height * 2  - 100){
                        moveto = CGPoint(x:  self.view!.bounds.width * 2  + 500, y: 1000 + 500)
                    }
                    
                    var dxx : CGFloat = 0 , dyy : CGFloat = 0
                    if (player!.position.x >= moveto!.x){
                        dxx = (player!.position.x -  moveto!.x)
                    }
                    else{
                        dxx = -( moveto!.x - player!.position.x)
                    }
                    if (player!.position.y >=  moveto!.y){
                        dyy = (player!.position.y -  moveto!.y)
                    }
                    else{
                        dyy = -( moveto!.y - player!.position.y)
                    }
                    
                    let addtoall =  1 + 90000000 * 1 / pow((abs(dxx) + abs(dyy)),3.5)
                    let movex = dxx * 0.02 * CGFloat(nummovespeed) * addtoall
                    let movey = dyy * 0.02 * CGFloat(nummovespeed) * addtoall
                    let selectedplayer = NSUserDefaults.standardUserDefaults().valueForKey("selectedsmart") as! Int
                    if !self.powerplayercontrolbool{
                        if (selectedplayer == 1){
                            
                        }
                        else if (selectedplayer == 2){
                            player?.physicsBody?.applyForce(CGVector(dx: movex, dy: movey))
                        }
                        else{
                            player?.physicsBody?.applyForce(CGVector(dx: movex, dy: movey))
                        }
                        
                    }
                    
                    var dx = moveto!.x - player!.position.x
                    var dy = moveto!.y - player!.position.y
                    var angleToTurn = atan2(dy, dx);
                    if (!self.powerfastshootingbool){
                        player?.zRotation = angleToTurn
                    }
                    if (numshootspeed % (shootspeed - (NSUserDefaults.standardUserDefaults().valueForKey("shootspeed") as! Int)) == 0 && (enemies1.count > 0 || enemies2.count > 0 || enemies3.count > 0)) && player != nil{
                        playershoot(dx, dy: dy)
                    }
                    //power shild move
                    if (powershildbool){
                        let powershild = childNodeWithName("shild")
                        if (player?.position != nil && powershildactive){
                            powershild?.position = player!.position
                        }
                        else if (player?.position == nil){
                            powershild?.position.x = -10000
                        }
                    }
                    numshootspeed++

            }
            
        }
    }
}
    func updaterechargepower(){
        let selectedpower = NSUserDefaults.standardUserDefaults().valueForKey("selectedpower") as! [String]
        let ezerring1 = childNodeWithName("ring1")
        let ezerring2 = childNodeWithName("ring2")
        let ezerring3 = childNodeWithName("ring3")
        let ezerring4 = childNodeWithName("ring4")
        if ezerring1 != nil{
            let ring1 = childNodeWithName("ring1") as! SKShapeNode
            var timeforrecharge : CGFloat = 0
            if selectedpower[0] == "shild"{
                timeforrecharge = 10
            }else if selectedpower[0] == "fastshooting"{
                timeforrecharge = 5
            }else if selectedpower[0] == "playercontrol"{
                timeforrecharge = 4
            }
            let endangleezer = (2 * self.pi ) / (100 * timeforrecharge)
            self.ringendangle[0] = self.ringendangle[0] + endangleezer
            if self.ringendangle[0] > 2 * self.pi{
                ring1.removeFromParent()
                self.ringendangle[0] = 0
            }
            var circle = UIBezierPath()
            circle.addArcWithCenter(CGPoint(x: 0, y: 0), radius: 25, startAngle: 0.0, endAngle: self.ringendangle[0], clockwise: true)
            ring1.path = circle.CGPath
        }
        if ezerring2 != nil{
            let ring2 = childNodeWithName("ring2") as! SKShapeNode
            var timeforrecharge : CGFloat = 0
            if selectedpower[1] == "shild"{
                timeforrecharge = 10
            }else if selectedpower[1] == "fastshooting"{
                timeforrecharge = 5
            }else if selectedpower[1] == "playercontrol"{
                timeforrecharge = 4
            }
            let endangleezer = (2 * self.pi ) / (100 * timeforrecharge)
            self.ringendangle[1] = self.ringendangle[1] + endangleezer
            if self.ringendangle[1] > 2 * self.pi{
                ring2.removeFromParent()
                self.ringendangle[1] = 0
            }
            var circle = UIBezierPath()
            circle.addArcWithCenter(CGPoint(x: 0, y: 0), radius: 25, startAngle: 0.0, endAngle: self.ringendangle[1], clockwise: true)
            ring2.path = circle.CGPath
        }
        if ezerring3 != nil{
            let ring3 = childNodeWithName("ring3") as! SKShapeNode
            var timeforrecharge : CGFloat = 0
            if selectedpower[2] == "shild"{
                timeforrecharge = 10
            }else if selectedpower[2] == "fastshooting"{
                timeforrecharge = 5
            }else if selectedpower[2] == "playercontrol"{
                timeforrecharge = 4
            }
            let endangleezer = (2 * self.pi ) / (100 * timeforrecharge)
            self.ringendangle[2] = self.ringendangle[2] + endangleezer
            if self.ringendangle[2] > 2 * self.pi{
                ring3.removeFromParent()
                self.ringendangle[2] = 0
            }
            var circle = UIBezierPath()
            circle.addArcWithCenter(CGPoint(x: 0, y: 0), radius: 25, startAngle: 0.0, endAngle: self.ringendangle[2], clockwise: true)
            ring3.path = circle.CGPath
        }
        if ezerring4 != nil{
            let ring4 = childNodeWithName("ring4") as! SKShapeNode
            var timeforrecharge : CGFloat = 0
            if selectedpower[3] == "shild"{
                timeforrecharge = 10
            }else if selectedpower[3] == "fastshooting"{
                timeforrecharge = 5
            }else if selectedpower[3] == "playercontrol"{
                timeforrecharge = 4
            }
            let endangleezer = (2 * self.pi ) / (100 * timeforrecharge)
            self.ringendangle[3] = self.ringendangle[3] + endangleezer
            if self.ringendangle[3] > 2 * self.pi{
                ring4.removeFromParent()
                self.ringendangle[3] = 0
            }
            var circle = UIBezierPath()
            circle.addArcWithCenter(CGPoint(x: 0, y: 0), radius: 25, startAngle: 0.0, endAngle: self.ringendangle[3], clockwise: true)
            ring4.path = circle.CGPath
        }
    }
    func roundtimer(){
        self.roundrnd = Int(arc4random()) % 4
        self.roundcount++
        self.cansendcircle = true
    }
    func xpneed() -> Int{
        let xp = NSUserDefaults.standardUserDefaults().valueForKey("xp") as! Int
        let level = NSUserDefaults.standardUserDefaults().valueForKey("level") as! Int
        return (10 * Int(pow(2, Double(level) - 1)))
    }
    func refreshlevel() -> Int{
        var baraktimer = NSTimer.scheduledTimerWithTimeInterval(60 * 5, target: self, selector: "baraktimer", userInfo: nil, repeats: true)
        let lastdate = NSUserDefaults.standardUserDefaults().valueForKey("timefrombarak") as! NSDate
        let timefrombarak = NSDate().timeIntervalSinceDate(lastdate)
        var xp = NSUserDefaults.standardUserDefaults().valueForKey("xp")as! Int
        var level = NSUserDefaults.standardUserDefaults().valueForKey("level") as! Int
        while xp > 10 * Int(pow(2,Double(level)-1)){
            xp = xp - xpneed()
            level++
        }
        var unlockpower = NSUserDefaults.standardUserDefaults().valueForKey("unlockpower") as! [String]
        var index : Int = 0
        for x in unlockpower{
            if x == "fastshooting" && level >= 3{
                unlockpower.removeAtIndex(index)
                var selectedpower = NSUserDefaults.standardUserDefaults().valueForKey("selectedpower") as! [String]
                selectedpower[1] = "fastshooting"
                NSUserDefaults.standardUserDefaults().setObject(selectedpower, forKey: "selectedpower")
                NSUserDefaults.standardUserDefaults().setValue(false, forKey: "touchalert")
            }
            else if x == "playercontrol" && level >= 2{
                unlockpower.removeAtIndex(index)
                var selectedpower = NSUserDefaults.standardUserDefaults().valueForKey("selectedpower") as! [String]
                selectedpower[2] = "playercontrol"
                NSUserDefaults.standardUserDefaults().setObject(selectedpower, forKey: "selectedpower")
                NSUserDefaults.standardUserDefaults().setValue(false, forKey: "touchalert")
            }
            index++
        }
        NSUserDefaults.standardUserDefaults().setValue(level, forKey: "level")
        NSUserDefaults.standardUserDefaults().setValue(xp, forKey: "xp")
        NSUserDefaults.standardUserDefaults().setValue(unlockpower, forKey: "unlockpower")
        return level
    }
    func addcircle1(numenemies : Int){
        let player = self.childNodeWithName("player")
        for (var i = 0; i < numenemies; i++){
            var enemy = SKSpriteNode(imageNamed:"enemy1 - one ball army.png")
            enemy.position.x = 250 * cos(((1.98 * self.pi * CGFloat(i))/CGFloat(numenemies))) + self.view!.bounds.width + 30 * sin(((9.98 * self.pi * CGFloat(i))/CGFloat(numenemies)))
            enemy.position.y = 250 * sin(((1.98 * self.pi * CGFloat(i))/CGFloat(numenemies))) + self.view!.bounds.height + 100
            enemy.name = "enemy1 " + String(numname)
            enemy.xScale = 0.11061947
            enemy.yScale = 0.11061947
            enemy.physicsBody = SKPhysicsBody(circleOfRadius: 13.5 * 0.8)
            enemy.physicsBody?.affectedByGravity = false
            enemy.physicsBody?.restitution = 1
            enemy.physicsBody?.friction = 0.0
            enemy.physicsBody?.linearDamping = 0.0
            enemy.physicsBody?.angularDamping = 0.0
            enemy.physicsBody?.categoryBitMask = bodytype.enemy1.rawValue
            enemy.physicsBody?.contactTestBitMask = bodytype.shoot.rawValue
            enemy.physicsBody?.contactTestBitMask += bodytype.player.rawValue
            enemy.physicsBody?.collisionBitMask = bodytype.shoot.rawValue
            enemy.physicsBody?.collisionBitMask = bodytype.shoot.rawValue
            enemy.physicsBody?.collisionBitMask += bodytype.enemy1.rawValue
            enemy.zPosition = -9
            enemy.physicsBody?.mass *= 20
            self.addChild(enemy)
            self.enemies1.append("enemy1 " + String(numname))
            self.numname++
            var theenemy = self.childNodeWithName("enemy1 " + String(self.numname-1))
            if (player == nil){
                self.pos = self.rndplayerpos()
            }
            else{
                self.pos = player!.position
            }
            var dxx : CGFloat = 0 , dyy : CGFloat = 0
            if (self.pos.x >= theenemy!.position.x){
                dxx = self.pos.x -  theenemy!.position.x
            }
            else{
                dxx = -( theenemy!.position.x - self.pos.x)
            }
            if (self.pos.y >=  theenemy!.position.y){
                dyy = self.pos.y -  theenemy!.position.y
            }
            else{
                dyy = -( theenemy!.position.y - self.pos.y)
            }
            theenemy?.physicsBody?.applyForce(CGVector(dx: dxx/4, dy: dyy/4))
            var dx = theenemy!.position.x - self.pos.x
            var dy = theenemy!.position.y - self.pos.y
            var angleToTurn = atan2(dy, dx);
            theenemy?.zRotation = angleToTurn
        }
    }
    func addcircle2(numenemies : Int){
        let player = self.childNodeWithName("player")
        for (var i = 0; i < numenemies * 4; i++){
            var enemy = SKSpriteNode(imageNamed:"enemy2 - one ball army.png")
            enemy.position.x = 250 * cos(((1.99 * self.pi * CGFloat(i))/CGFloat(numenemies))) + self.view!.bounds.width
            enemy.position.y = 250 * sin(((1.99 * self.pi * CGFloat(i))/CGFloat(numenemies))) + self.view!.bounds.height + 100
            enemy.name = "enemy2 " + String(self.numname)
            enemy.xScale = 0.11061947 * 0.8
            enemy.yScale = 0.11061947 * 0.8
            enemy.physicsBody = SKPhysicsBody(circleOfRadius: enemy.frame.width / 2)
            enemy.physicsBody?.affectedByGravity = false
            enemy.physicsBody?.categoryBitMask = bodytype.enemy2.rawValue
            //enemy.physicsBody?.categoryBitMask = collidertype.enemy.rawValue
            enemy.physicsBody?.contactTestBitMask = bodytype.shoot.rawValue
            enemy.physicsBody?.contactTestBitMask += bodytype.player.rawValue
            enemy.physicsBody?.contactTestBitMask += bodytype.wall.rawValue
            //enemy.physicsBody?.collisionBitMask = bodytype.player.rawValue
            enemy.physicsBody?.collisionBitMask = bodytype.shoot.rawValue
            enemy.physicsBody?.collisionBitMask += bodytype.enemy2.rawValue
            enemy.zPosition = -10
            enemy.runAction(SKAction.scaleBy(3.5, duration: 10))
            enemy.physicsBody?.mass *= 40
            self.addChild(enemy)
            self.enemies2.append("enemy2 " + String(self.numname))
            self.numname++
            var theenemy = self.childNodeWithName("enemy2 " + String(self.numname-1))
            if (player == nil){
                self.pos = self.rndplayerpos()
            }
            else{
                self.pos = player!.position
            }
            var dxx : CGFloat = 0 , dyy : CGFloat = 0
            if (self.pos.x >= theenemy!.position.x){
                dxx = self.pos.x -  theenemy!.position.x
            }
            else{
                dxx = -( theenemy!.position.x - self.pos.x)
            }
            if (self.pos.y >=  theenemy!.position.y){
                dyy = self.pos.y -  theenemy!.position.y
            }
            else{
                dyy = -( theenemy!.position.y - self.pos.y)
            }
            theenemy?.physicsBody?.applyForce(CGVector(dx: dxx, dy: dyy))
            var dx = theenemy!.position.x - self.pos.x
            var dy = theenemy!.position.y - self.pos.y
            var angleToTurn = atan2(dy, dx);
            theenemy?.zRotation = angleToTurn
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
