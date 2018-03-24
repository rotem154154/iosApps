//
//  Obs.swift
//  tiny game1
//
//  Created by ofer on 05/10/2016.
//  Copyright © 2016 ofertande. All rights reserved.
//

import SpriteKit

class Level{
    var obs : [Obs]
    var obsString : String
    var time : TimeInterval
    /*
    init(obs : [Obs], time : TimeInterval) {
        self.obs = obs
        self.time = time
        self.complete = false
    }
 */
    init() {
        obs = []
        obsString = ""
        time = 0
    }
    init(str : String){
        let arr = str.characters.split(separator: "@")
        let at1 = String(arr[0])
        let at2 = TimeInterval((String(arr[1]) as NSString).doubleValue)
        let at3 = Int((String(arr[2]) as NSString).intValue)
        self.obsString = at1
        self.obs = obsStringToArr(obsString: at1)
        self.time = at2
        /*
        if at3 == 1{
            complete = true
        }else{
            complete = false
        }*/
    }
    
}
