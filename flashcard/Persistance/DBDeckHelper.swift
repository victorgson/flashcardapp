//
//  DBDeckHelper.swift
//  flashcard
//
//  Created by Victor Gustafsson on 2023-01-11.
//

import Foundation
import SQLite

class DBDeckHelper: DBDeckProtocol {
    
    typealias Model = DeckModel
    
    let helper = DBHelper()
    let db : Connection
    
    init() {
        // TODO: Fix, can't force unwrap here
        db = helper.database!
    }
    
    func add(model: DeckModel) {
        do {
            try db.run(helper.decks.insert(helper.name <- model.deckName))
        } catch {
            print(error)
        }
    }
    
    func delete(deckId: Int, model: DeckModel) {
        do {
            let deckToDelete = helper.decks.filter(helper.id == model.id)
            let cardsToDelete = helper.flashcards.filter(helper.deckId == deckId)
            
            
            try db.run(cardsToDelete.delete())
            try db.run(deckToDelete.delete())
            
        } catch {
            print(error)
        }
    }
    func delete(model: DeckModel) {
        // N/A
    }

    
    func update(model: DeckModel) {
        do {
            let deckToUpdate = helper.decks.filter(helper.id == model.id )
            try db.run(deckToUpdate.update(helper.name <- model.deckName))
        } catch {
            print(error)
        }
    }
    
    func getItem(id: Int, completion: (DeckModel) -> Void) {
        do {
            for deck in try db.prepare(helper.decks.where(helper.deckId == id)) {
                completion(DeckModel(id: deck[helper.id], deckName: deck[helper.name]))
            } } catch {
                print(error)
            }
    }
    
    func getItems(completion: ([DeckModel]) -> Void) {
        var decks: [DeckModel] = []
        do {
            for deck in try db.prepare(helper.decks) {
                decks.append(DeckModel(id: deck[helper.id], deckName: deck[helper.name]))
            } } catch {
                print(error)
            }
        completion(decks)
    }
    
}






