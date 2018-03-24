//
//  Obs.swift
//  tiny game1
//
//  Created by ofer on 05/10/2016.
//  Copyright © 2016 ofertande. All rights reserved.
//

import SpriteKit

class Stage{
    var name : String
    var levels : [Level]
    var levelsString : String
    
    /*init(name : String, levels : [Level]) {
        self.levels = levels
        self.name = name
    }*/
    init(str : String){
        levelsString = str
        let arr = str.characters.split(separator: "$")
        name = String(arr[0])
        let str2 = String(arr[1])
        levels = []
        let strArr = str2.characters.split(separator: "#")
        for obsString in strArr{
            let at = String(obsString)
            levels.append(Level(str: at))
        }
    }
    func stagePrecent() -> CGFloat{
        var count = 0
        let levelComplete = stages[stage].levelsComplete()
        for level in levelComplete{
            if level == 1{
                count += 1
            }
        }
        return CGFloat(count) / CGFloat(levels.count)
    }
    func levelsComplete() -> [Int]{
        let levelComplete = nsUser.value(forKey: "levelComplete") as! [[Int]]
        return levelComplete[stage]
    }
    func defaultLevel() -> Int{
        let levelsComplete = self.levelsComplete()
        for i in 0...levelsComplete.count-1{
            if levelsComplete[i] == 0{
                return i
            }
        }
        return 0
    }
}
let stages = [Stage(str: "Getting Started$700,-310,150,1!800,-160,150,1!1100,310,150,1!1200,160,150,1!1800,-100,400,2!2200,180,360,1!2700,-180,360,2@10@1#r3,300,8@30@0#700,-330,60,2!760,-270,60,2!820,-210,60,2!880,-150,60,2!940,-90,60,2!1000,-30,60,2!1060,30,60,2!1120,90,60,2!1180,150,60,1!700,90,60,1!760,150,60,1!820,210,60,1!880,270,60,1!940,330,60,1!1700,100,520,2@12@1#r1,600,16@25@0#r2,300,14@20@0"),
Stage(str: "Begginer$r2,100,20@10@0#700,-200,300,1!800,-100,300,2!900,0,300,2@10@0")]
