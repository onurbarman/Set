//
//  SetGameViewModel.swift
//  Set
//
//  Created by MacOS on 2/5/25.
//

import Foundation

class SetGameViewModel: ObservableObject {
    
    private static func createSetGame() -> SetGame {
        return SetGame()
    }
    
    @Published private var model: SetGame
    
    init() {
        self.model = SetGameViewModel.createSetGame()
    }
    
    var cards: Array<Card> {
        return model.cards
    }
    
    var isDealThreeMoreCardButtonEnabled: Bool {
        return model.isDealThreeMoreCardButtonEnabled
    }
    
    var score: Int {
        return model.score
    }
    
    var isGameOver: Bool {
        return model.isGameOver
    }
    
    // MARK - Intents
    
    func choose(cardId: String) {
        model.choose(cardId: cardId)
    }
    
    func dealThreeMoreCard() {
        model.dealThreeMoreCard()
    }
    
    func createNewGame() {
        model = SetGameViewModel.createSetGame()
    }
}
