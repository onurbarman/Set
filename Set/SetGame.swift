//
//  SetGame.swift
//  Set
//
//  Created by MacOS on 2/4/25.
//

import Foundation

struct SetGame {
    let soundManager = SoundManager.instance
    
    let numberOfPairsOfCards = 81
    
    private(set) var cards: Array<Card>
    private var cardsOnDeck: Array<Card>
    private var setCards: Array<Card>
    
    private(set) var score: Int
    private(set) var isGameOver: Bool
    
    private(set) var isDealThreeMoreCardButtonEnabled = true
    
    init() {
        cards = []
        cardsOnDeck = []
        setCards = []
        score = 0
        isGameOver = false
        
        for colorIndex in 0..<CardColor.allCases.count {
            for shapeIndex in 0..<CardShape.allCases.count {
                for shadingIndex in 0..<Shading.allCases.count {
                    for numberIndex in 0..<3 {
                        cardsOnDeck.append(
                            Card(
                                color: CardColor.allCases[colorIndex],
                                number: numberIndex+1,
                                shape: CardShape.allCases[shapeIndex],
                                shading: Shading.allCases[shadingIndex],
                                id: "\(colorIndex)\(shapeIndex)\(shadingIndex)\(numberIndex)")
                        )
                    }
                }
            }
        }
        
        cardsOnDeck.shuffle()
        
        for _ in 0..<12 {
            cards.append(cardsOnDeck[0])
            cardsOnDeck.remove(at: 0)
        }
    }
    
    mutating func choose(cardId: String) {
        let selectedCards = cards.filter { $0.isSelected }
        let setCards = cards.filter { $0.isSelected && $0.isMatched }
        
        if selectedCards.count < 4 {
            if selectedCards.count == 3 {
                if setCards.count == 3 {
                    if let selectedCardId = cards.firstIndex(where: { $0.id == cardId} ) {
                        if !cards[selectedCardId].isMatched {
                            dealThreeMoreCard()
                        }
                    }
                } else {
                    selectedCards.forEach { item in
                        if let index = cards.firstIndex(where: { $0.id == item.id }) {
                            cards[index].isSelected = false
                            cards[index].borderColor = .black
                        }
                    }
                }
            }
            
            if let selectedCardId = cards.firstIndex(where: { $0.id == cardId}) {
                if !cards[selectedCardId].isMatched {
                    cards[selectedCardId].isSelected = !cards[selectedCardId].isSelected
                    soundManager.playSelectSound()
                    if cards[selectedCardId].isSelected {
                        cards[selectedCardId].borderColor = .yellow
                    } else {
                        cards[selectedCardId].borderColor = .black
                    }
                    
                    if cards.count(where: { $0.isSelected }) == 3 {
                        checkSet()
                    }
                }
            }
        }
    }
    
    mutating func checkSet() {
        let selectedCards = cards.filter { $0.isSelected && !$0.isMatched }
        
        if selectedCards.count == 3 {
            let allSameColor = selectedCards.allSatisfy { $0.color == selectedCards.first?.color }
            var allDifferentColor = true
            
            if !allSameColor {
                for index in selectedCards.indices {
                    for itemIndex in selectedCards.indices {
                        if index != itemIndex {
                            if selectedCards[index].color == selectedCards[itemIndex].color {
                                allDifferentColor = false
                                break
                            }
                        }
                    }
                }
            }
            
            let allSameNumber = selectedCards.allSatisfy { $0.number == selectedCards.first?.number }
            var allDifferentNumber = true
            
            if !allSameNumber {
                for index in selectedCards.indices {
                    for itemIndex in selectedCards.indices {
                        if index != itemIndex {
                            if selectedCards[index].number == selectedCards[itemIndex].number {
                                allDifferentNumber = false
                                break
                            }
                        }
                    }
                }
            }
            
            let allSameShape = selectedCards.allSatisfy { $0.shape == selectedCards.first?.shape }
            var allDifferentShape = true
            
            if !allSameShape {
                for index in selectedCards.indices {
                    for itemIndex in selectedCards.indices {
                        if index != itemIndex {
                            if selectedCards[index].shape == selectedCards[itemIndex].shape {
                                allDifferentShape = false
                                break
                            }
                        }
                    }
                }
            }
            
            let allSameShading = selectedCards.allSatisfy { $0.shading == selectedCards.first?.shading }
            var allDifferentShading = true
            
            if !allSameShading {
                for index in selectedCards.indices {
                    for itemIndex in selectedCards.indices {
                        if index != itemIndex {
                            if selectedCards[index].shading == selectedCards[itemIndex].shading {
                                allDifferentShading = false
                                break
                            }
                        }
                    }
                }
            }
            
            if (allSameColor || allDifferentColor)
                && (allSameNumber || allDifferentNumber)
                && (allSameShape || allDifferentShape)
                && (allSameShading || allDifferentShading) {
                selectedCards.forEach { item in
                    if let chosenIndex = cards.firstIndex(where: { $0.id == item.id }) {
                        cards[chosenIndex].isMatched = true
                        cards[chosenIndex].borderColor = .green
                    }
                }
                soundManager.playSuccessSound()
                score += 10
                
                if cards.count == 3 {
                    isGameOver = true
                }
            } else {
                selectedCards.forEach { item in
                    if let chosenIndex = cards.firstIndex(where: { $0.id == item.id }) {
                        cards[chosenIndex].isMatched = false
                        cards[chosenIndex].borderColor = .red
                    }
                }
                soundManager.playFailSound()
                score -= 1
            }
            
        } else {
            selectedCards.forEach { item in
                if let chosenIndex = cards.firstIndex(where: { $0.id == item.id }) {
                    cards[chosenIndex].isMatched = false
                    cards[chosenIndex].borderColor = .red
                }
            }
            soundManager.playFailSound()
            score -= 1
        }
    }
    
    mutating func dealThreeMoreCard() {
        let selectedCardCount = cards.count(where: { $0.isSelected })
        
        if selectedCardCount < 3 {
            takeThreeCard()
        } else if selectedCardCount == 3 {
            let potentialSetCards = cards.filter {
                $0.isSelected && $0.isMatched
            }
            
            if potentialSetCards.count == 3 {
                potentialSetCards.forEach { potentialSetCard in
                    setCards.append(potentialSetCard)
                    cards.removeAll(where: { $0.id == potentialSetCard.id})
                }
                takeThreeCard()
            } else {
                takeThreeCard()
            }
        }
        
        if cardsOnDeck.count == 0 {
            isDealThreeMoreCardButtonEnabled = false
        }
    }
    
    mutating func takeThreeCard() {
        if isDealThreeMoreCardButtonEnabled {
            soundManager.playDealThreeMoreCardSound()
            for _ in 0..<3 {
                cards.append(cardsOnDeck[0])
                cardsOnDeck.remove(at: 0)
            }
        }
    }
}
