//
//  Node.swift
//  PathFinder
//
//  Created by Khaled Elshamy on 8/1/20.
//  Copyright © 2020 Khaled Elshamy. All rights reserved.
//

import UIKit

enum state {
    
    case empty, Obstacle, start, finish, Path
    
}

class Node: NSObject {
    
    var type: state = .empty
    var x: Int = 0
    var y: Int = 0
    
    var g: Int = -100
    var h: Int = -100
    var f: Int {
        return g + h
    }
    
    var from: Node!
    
    var color: UIColor {
        get {
            if type == .empty {
                return UIColor.white
            } else if type == .Obstacle {
                return UIColor.black
            } else if type == .start {
                return UIColor.red
            } else if type == .finish {
                return UIColor.green
            } else if type == .Path {
                return UIColor.blue
            } 
            return UIColor.orange
        }
    }
    
}
