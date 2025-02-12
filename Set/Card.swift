//
//  Card.swift
//  Set
//
//  Created by MacOS on 2/4/25.
//

import Foundation

struct Card: Equatable, Identifiable {
    
    var color: CardColor
    var number: Int
    var shape: CardShape
    var shading: Shading
    var isSelected = false
    var isMatched = false
    var borderColor: CardBorderColor = .black
    
    var id: String
}
