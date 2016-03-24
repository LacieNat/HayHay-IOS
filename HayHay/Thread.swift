//
//  Thread.swift
//  HayHay
//
//  Created by Lacie on 3/22/16.
//  Copyright © 2016 Lacie. All rights reserved.
//

import UIKit

class Thread {
    //MARK: Properties
    var content:String
    var time:String
    var topic:Int?
    
    init?(content:String, time:String, topic:Int?) {
        self.content = content
        self.time = time
        self.topic=topic
        
        if content.isEmpty || time.isEmpty {
            return nil
        }
    }
    
}
