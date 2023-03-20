//
//  CardViewModel.swift
//  flashcard
//
//  Created by Victor Gustafsson on 2022-11-25.
//

import Foundation
import Combine

class CardViewModel {
    
    let db = DBCardHelper()
    @Published var data: [CardModel] = []
    
    func getCardsWithoutCompleted(inDeck: Int)  {
        var filteredArray: [CardModel] = []
        
        db.getItems(deckId: inDeck) { (cards) -> () in
            for card in cards {
                if(card.isCompleted == false) {
                    filteredArray.append(card)
                }
            }
            data = filteredArray
        }
    }
    
    
    func getAllCards(inDeck: Int) -> Int   {
        var totalCards: Int = 0
        db.getItems(deckId: inDeck) { (cards) -> () in
            data = cards
            totalCards = cards.count
        }
        
        return totalCards

    }
    
    func getCard(id: Int, completion: (CardModel) -> Void)  {
        db.getItem(id: id) { card in
           completion(card)
        }
    }
    
    func updateCard(model: CardModel) {
        db.update(model: model)
    }
    
    func setComplete(complete: Bool, id: Int) {
        db.update(complete: complete, id: id)
    }
    
    func deleteCard(model: CardModel) {
        db.delete(model: model)
    }
    
    func addCard(model: CardModel) {
        db.add(model: model)
    }
    
    
    func numberOfCards() -> Int {
        return data.count
    }
    
    
}
