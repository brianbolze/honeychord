//
//  GridScanner.swift
//  Honeychord
//
//  Created by BrianBolze on 1/2/18.
//  Copyright © 2018 Bolze, LLC. All rights reserved.
//

import UIKit

class HexGridScanner {
    
    private let hexSize : CGSize
    private let gridGap : CGSize
    private let gridGapStep : CGSize
    private let gridOrigin : CGPoint
    private let gridStep : CGSize
    
    
    init(hexSize: CGSize, gridGap: CGFloat) {
        self.hexSize = hexSize
        self.gridGap = CGSize(width: gridGap, height: 0)
        let gridGapStepX = gridGap*sqrt(3)
        self.gridGapStep = CGSize(width: gridGapStepX, height: 0)
        self.gridOrigin = CGPoint(x: (2*gridGapStepX - hexSize.width/4), y: gridGap)
        self.gridStep = CGSize(width: ((3*hexSize.width/4) + gridGapStepX), height: hexSize.height/2 + gridGap)
    }
    
    func getGridLocation(forPoint point: CGPoint) -> (x: Int, y: Int)? {
        
        let centered = CGPoint(x: point.x - gridOrigin.x, y: point.y - gridOrigin.y)
        var subCol = Int(centered.x/gridStep.width)
        // let xRel = centered.x % gridStep.width
        let colIsEven = subCol%2 == 0
        
        var row : Int
        if colIsEven {
            let newY = centered.y - gridStep.height
            row = 2 + 2*Int(newY/(2*gridStep.height))
            if (newY<0) {
                row -= 2
            }
        } else {
            row = 1 + 2*Int(centered.y/(2*gridStep.height))
        }
        
        let xRel = centered.x - (CGFloat(subCol)*gridStep.width)
        let yRel : CGFloat
        if colIsEven {
            yRel = centered.y - (CGFloat((row/2)-1)*gridStep.height*2) - gridStep.height
        } else {
            yRel = centered.y - (CGFloat((row/2))*gridStep.height*2)
        }
        
        // print("xRel: \(xRel), yRel: \(yRel)")
        
        let m = sqrt(CGFloat(3))
        let c = gridStep.height
        
        if (yRel > (m*xRel)+c) {
            // print("bottom left edge!")
            row += 1
            subCol -= 1

        } else if (yRel < (-m*xRel)+c) {
            row -= 1
            subCol -= 1
            // print("top left edge!")
        }
        
        return (row, subCol/2)
    }
    
    private func centerXForSubCol(subCol col: Int) -> CGFloat {
        return gridOrigin.x + CGFloat(col)*gridStep.width
    }
    
    private func closestRowForSubCol(col: Int, centeredY y: CGFloat) -> Int {
        var row = Int(y/gridStep.height)
        if (y.truncatingRemainder(dividingBy: gridStep.height)/gridStep.height > 0.5) {
            row += 1
        }
        return row
    }
    
}
