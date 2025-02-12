//
//  Diamond.swift
//  Set
//
//  Created by MacOS on 2/4/25.
//

import SwiftUI

struct Diamond: Shape {
    let centerAngleX = 100
    let startAngleX = 0
    let endAngleX = 200
    let startAngleY = 0
    let centerAngleY = 30
    let endAngleY = 60
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let startingPoint = CGPoint(x: rect.maxX, y: center.y)
        
        p.move(to: startingPoint)
        
        let secondPoint = CGPoint(x: center.x, y: rect.maxY)
        let thirdPoint = CGPoint(x: rect.minX, y: center.y)
        let fourthPoint = CGPoint(x: center.x, y: rect.minY)
        p.addLine(to: secondPoint)
        p.addLine(to: thirdPoint)
        p.addLine(to: fourthPoint)
        p.addLine(to: startingPoint)
        p.closeSubpath()
        return p
    }
}

extension Diamond {
    func stroke() -> some View {
        Diamond().stroke(lineWidth: 3)
    }
}
