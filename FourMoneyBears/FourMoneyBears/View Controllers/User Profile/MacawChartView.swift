//
//  MacawChartView.swift
//  FourMoneyBears
//
//  Created by Austin Potts on 7/25/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import Macaw
import Firebase


class MacawChartView: MacawView {
    
    // This needs to be changed to last five days which equals the users rank over five days
    static let lastFiveShows = userData()
    
    // This needs to be changed to 50 for totoal 50 crowns can be earned a day
    static let maxValue = 500
    
    static let maxValueLineHeight = 180
    static let lineWidth: Double = 375
    
    // Conver into number that fits into coordiante system
    static let dataDivisor = Double(maxValue/maxValueLineHeight)
    static let adjustedData: [Double] = lastFiveShows.map({ $0.crowns / dataDivisor})
    static var animations: [Animation] = [] // Macaw object
    
    required init?(coder aDecoder: NSCoder){
        super.init(node: MacawChartView.createChart(), coder: aDecoder)
        backgroundColor = .clear
    }
    
    // The group is what has an array of nodes, the nodes are what create all of the visuals
    private static func createChart() -> Group {
        var items: [Node] = addYaxisItem() + addXaxisItem()
        items.append(createBars())
        
        return Group(contents: items, place: .identity)
    }
    
    private static func addYaxisItem() -> [Node]{
        let maxLines = 5 // max numbers of Y axis going up
        let lineInterval = Int(maxValue/maxLines)
        let yAxisHeight: Double = 200
        let lineSpacing: Double = 30
        
        var newNodes: [Node] = []
        
        for i in 1...maxLines {
            let y = yAxisHeight - (Double(i) * lineSpacing)
            
            let valueLine = Line(x1: -5, y1: y, x2: lineWidth, y2: y).stroke(fill: Color.white.with(a: 0.10))
            
            let valueText = Text(text: "\(i * lineInterval)", align: .max, baseline:  .mid, place: .move(dx: -10, dy: y))
            valueText.fill = Color.white
            
            newNodes.append(valueLine)
            newNodes.append(valueText)
        }
        
        let yAxis = Line(x1: 0, y1: 0, x2: 0, y2: yAxisHeight).stroke(fill: Color.white.with(a: 0.25))
        newNodes.append(yAxis)
        
        return newNodes
    }
    
    private static func addXaxisItem() -> [Node]{
        let chartBaseY: Double  = 200
        var newNodes: [Node] = []
        
        for i in 1...adjustedData.count {
            let x = (Double(i) * 50) // spacing in between lines
            // i - 1 = 0
            let valueText = Text(text: lastFiveShows[i - 1].day, align: .max, baseline: .mid, place: .move(dx: x, dy: chartBaseY + 15) )
            valueText.fill = Color.white
            newNodes.append(valueText)
        }
        
        let xAxis = Line(x1: 0, y1: chartBaseY, x2: lineWidth, y2: chartBaseY).stroke(fill: Color.white.with(a: 0.25))
        newNodes.append(xAxis)
        
        return newNodes
    }
    
    private static func createBars() -> Group {
        
        let fill = LinearGradient(degree: 90, from: Color(val: 0xff4704), to: Color(val: 0xff4705).with(a: 0.33))
        
        print("Adj Data: \(adjustedData)")
        let items = adjustedData.map {_ in Group()}
        
        // Creating array of animations
        // Enumerate = Get int in item
        animations = items.enumerated().map {(i: Int, item: Group) in
            item.contentsVar.animation(delay: Double(i) * 0.1) { t in
                let height = adjustedData[i] * t
                let rect = Rect(x: Double(i) * 50 + 25, y: 200 - height, w: 30, h: height)
                return [rect.fill(with: fill)]
            }
        }
        
        return items.group()
    }
    
    static func playAnimations(){
        animations.combine().play()
    }
    
    
    
    // private static func userData() -> [User]
        // for user in users { let mon = User(name: "M", rank: Int(user.rank ?? "") ?? 0) }
    struct UserData {
              let day: String
              let crowns: Double
          }
    
    private static func userData() -> [UserData] {
        
        let userPlace = Users()
        
        var rank = 0.0
        
        let uid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //self.userHealthLabel.text = dictionary["rank"] as? String
            
                userPlace.setValuesForKeys(dictionary)
               
            }
            
            
            rank = Double(userPlace.rank ?? "") ?? 0
            print("RANK!!! \(rank)")
            
            let sun = UserData(day: "S", crowns: rank)
            let mon = UserData(day: "M", crowns: rank)
            let tue = UserData(day: "T", crowns: rank)
            let wed = UserData(day: "W", crowns: rank)
            let thur = UserData(day: "T", crowns: rank)
            let fri = UserData(day: "F", crowns: rank)
            let sat = UserData(day: "S", crowns: rank)
            
                
           print("Collection2::\([sun,mon, tue, wed, thur, fri, sat])")
        
            
            print(snapshot)
        }, withCancel: nil)
        
        
        print("RANK2!!!! \(rank)")
              
        let sun = UserData(day: "S", crowns: 100)
        let mon = UserData(day: "M", crowns: rank)
        let tue = UserData(day: "T", crowns: rank)
        let wed = UserData(day: "W", crowns: rank)
        let thur = UserData(day: "T", crowns: rank)
        let fri = UserData(day: "F", crowns: rank)
        let sat = UserData(day: "S", crowns: rank)
        
            
        print("Collection::\([sun,mon, tue, wed, thur, fri, sat])")
        return [sun, mon, tue, wed, thur, fri, sat]
        
    }
    
}


