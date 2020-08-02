//
//  NodeView.swift
//  PathFinder
//
//  Created by Khaled Elshamy on 8/1/20.
//  Copyright © 2020 Khaled Elshamy. All rights reserved.
//


import UIKit


class NodeView: UIView {
    
    let size: Int = 20
    var grid: [[Node]] = []
    var visited: [[Node]]  = []
    
    var initialPos:[Int] = []
    var goalPos:[Int] = []
    
    var dr = [1,-1,0,0]
    var dc = [0,0,1,-1]
    
    var flag = false
    
    override func awakeFromNib() {
        initialPos = [size - 1 , 0]
        goalPos = [0,size - 1]
        
        for _ in 0..<size {
            var final: [Node] = []
            for _ in 0..<size {
                let node = Node()
                node.type = .empty
                final.append(node)
            }
            grid.append(final)
        }
        grid[initialPos[0]][initialPos[1]].type = .start
        grid[goalPos[0]][goalPos[1]].type = .finish
        
        visited = grid
        self.setNeedsDisplay()
        
        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                grid[i][j].x = i
                grid[i][j].y = j
            }
        }
    }
    
    
    
   
    @IBAction func Solve(_ sender: UIButton) {
        
        resetNodes()
        search(initialPos: initialPos, goalPos: goalPos, grid: grid)
        //        for i in path {
        //            if nodes[i.y][i.x].type != .pointA && nodes[i.y][i.x].type != .pointB {
        //                nodes[i.y][i.x].type = .Path
        //            }
        //        }
        //        nodes[0][size-1].type = .pointB
        //        nodes[size-1][0].type = .pointA
        self.setNeedsDisplay()
    }
    // MARK: - add blocks to the grid
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var locOfTouch = CGPoint()
        for i in touches {
            locOfTouch = i.location(in: self)
        }
        let colNum = Int(locOfTouch.x / (self.frame.size.width / CGFloat(size)))
        let rowNum = Int(locOfTouch.y / (self.frame.size.height / CGFloat(size)))
        if rowNum <= size-1 && colNum <= size-1 {
            if grid[rowNum][colNum].type == .Obstacle {
                grid[rowNum][colNum].type = .empty
                self.setNeedsDisplay()
            } else if grid[rowNum][colNum].type == .empty || grid[rowNum][colNum].type == .Path || visited[rowNum][colNum].type == .Obstacle {
                grid[rowNum][colNum].type = .Obstacle
                self.setNeedsDisplay()
            }else {
                resetNodes()
                search(initialPos: initialPos, goalPos: goalPos, grid: grid)
                //        for i in path {
                //            if nodes[i.y][i.x].type != .pointA && nodes[i.y][i.x].type != .pointB {
                //                nodes[i.y][i.x].type = .Path
                //            }
                //        }
                //        nodes[0][size-1].type = .pointB
                //        nodes[size-1][0].type = .pointA
                self.setNeedsDisplay()
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        var locOfTouch = CGPoint()
        for i in touches {
            locOfTouch = i.location(in: self)
        }
        let colNum = Int(locOfTouch.x / (self.frame.size.width / CGFloat(size)))
        let rowNum = Int(locOfTouch.y / (self.frame.size.height / CGFloat(size)))
        if rowNum <= size-1 && colNum <= size-1 && rowNum >= 0 && colNum >= 0 {
            if grid[rowNum][colNum].type == .empty || grid[rowNum][colNum].type == .Path || visited[rowNum][colNum].type == .Obstacle {
                grid[rowNum][colNum].type = .Obstacle
                self.setNeedsDisplay()
            }
        }
    }
    
    
    // MARK: - Calculate the manhattan distance ( heuristic function)
    private func Heuristic(x1: Int, y1: Int, x2: Int, y2: Int) -> Int{
      return abs(x2 - x1) + abs(y2 - y1);
    }
  
    // MARK: - check if this cell is valid or not
    private func CheckValidCell(x:Int,y:Int,grid: [[Node]], visited: [[Node]]) -> Bool{
        if x<0 || y < 0 || x >= grid.count || y >= grid[0].count || grid[x][y].type == .Obstacle || visited[x][y].type == .Obstacle {
            return false
        }
        
        return true
    }
    
    // MARK: - expand neighbors
    private func ExpandNeighbors(x:Int,y:Int,h:Int,g:Int,nodes: inout PriorityQueue<Node>, visited: inout [[Node]]){
        let node = Node()
        node.x = x
        node.y = y
        node.h = h
        node.g = g
        
        nodes.enqueue(node)
        visited[x][y].type = .Obstacle
    }
    
    
    // MARK: - implementation of A* search algorithm
    private func search(initialPos: [Int],goalPos: [Int],grid: [[Node]]){
        let initialX = initialPos[0]
        let initialY = initialPos[1]
        let goalX = goalPos[0]
        let goalY = goalPos[1]
        
        var nodes = PriorityQueue<Node>(sort: { $0.h < $1.h })
        var h = Heuristic(x1: initialX, y1:initialY, x2: goalX, y2: goalY)
        var g = 0
        
        ExpandNeighbors(x: initialX, y: initialY, h: h, g: g, nodes: &nodes, visited: &visited)
        
        while !nodes.isEmpty  {
            
            let front: Node = nodes.peek()!
            nodes.dequeue()
            print(front.h)
            grid[front.x][front.y].type = .Path
            
            for index in 0..<4 {
                let check: Bool = CheckValidCell(x: front.x + dr[index], y: front.y + dc[index], grid: self.grid, visited: self.visited)
                if check {
                    g = front.g + 1
                    h = Heuristic(x1: front.x + dr[index], y1: front.y + dc[index], x2: goalX, y2: goalY)
                    
                    if front.x + dr[index] == goalX && front.y + dc[index] == goalY {
                        self.grid[initialX][initialY].type = .start
                        self.grid[goalX][goalY].type = .finish
                        flag = true
                        break
                    }
                    
                    ExpandNeighbors(x: front.x + dr[index], y: front.y + dc[index], h: h, g: g, nodes: &nodes, visited: &self.visited)
                }
            }
            
            if flag {
                break
            }
        }
        
    }
    
    

    @IBAction
    func clear() {
        resetAllNodes()
    }

    func resetNodes() {
        let tempNodes = grid
        grid = []
        for _ in 0..<size {
            var final: [Node] = []
            for _ in 0..<size {
                let node: Node = Node()
                node.type = .empty
                final.append(node)
            }
            grid.append(final)
        }
        grid[initialPos[0]][initialPos[1]].type = .start
        grid[goalPos[0]][goalPos[1]].type = .finish
        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                grid[i][j].x = j
                grid[i][j].y = i
            }
        }
        for i in 0..<tempNodes.count {
            for j in 0..<tempNodes[i].count {
                if tempNodes[i][j].type == .Obstacle {
                    grid[i][j].type = .Obstacle
                }
            }
        }
        self.setNeedsDisplay()
    }

    func resetAllNodes() {
        grid = []
        for _ in 0..<size {
            var final: [Node] = []
            for _ in 0..<size {
                let node = Node()
                node.type = .empty
                final.append(node)
            }
            grid.append(final)
        }
        grid[initialPos[0]][initialPos[1]].type = .start
        grid[goalPos[0]][goalPos[1]].type = .finish
        self.setNeedsDisplay()
    }
    
    
    // MARK: - draw grid
    
    override func draw(_ rect: CGRect) {
        self.subviews.map({ $0.removeFromSuperview() })
        let width = self.frame.size.width / CGFloat(size)
        let height = self.frame.size.height / CGFloat(size)
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        for i in 0..<grid.count {
            for j in 0..<grid[i].count {
                let rect = CGRect(x: x, y: y, width: width, height: height)
                createRect(rect: rect, color: grid[i][j].color)
                x += width
                grid[i][j].x = i
                grid[i][j].y = j
            }
            y += height
            x = 0
        }
    }
    
    
    private func createRect(rect: CGRect, color: UIColor) {
        let cont = UIGraphicsGetCurrentContext()
        cont?.setFillColor(color.cgColor)
        cont?.setStrokeColor(UIColor.orange.cgColor)
        cont?.fill(rect)
        cont?.stroke(rect, width: 2)
    }
    
}
