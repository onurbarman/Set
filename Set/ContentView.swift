//
//  ContentView.swift
//  Set
//
//  Created by MacOS on 2/4/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: SetGameViewModel
    
    var body: some View {
        VStack {
            if viewModel.isGameOver {
            
                Text("Game Over").font(.title)
                
                Text("Score: \(viewModel.score)")
                    .font(.largeTitle)
                    .padding(.top, 8)
                
                Button("New Game") {
                    viewModel.createNewGame()
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 36)
                
            } else {
                Text("Score: \(viewModel.score)").font(.title)
                    
                ScrollView {
                    cards.animation(.default, value: viewModel.cards)
                }
                    
                HStack {
                    Button("New Game") {
                        viewModel.createNewGame()
                    }
                    Spacer()
                    Button("Deal 3 More Cards") {
                        viewModel.dealThreeMoreCard()
                    }
                    .disabled(!viewModel.isDealThreeMoreCardButtonEnabled)
                }.padding(.horizontal, 24)
                
            }
        }
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(
            columns: [
                GridItem(spacing: 0),
                GridItem(spacing: 0),
                GridItem(spacing: 0),
                GridItem(spacing: 0)
            ],
            spacing: 0
        ){
            ForEach(viewModel.cards) { card in
                CardView(card: card)
                    .aspectRatio(2/3, contentMode: .fit)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(cardId: card.id)
                    }
            }
        }
    }
}

#Preview {
    ContentView(viewModel: SetGameViewModel())
}
