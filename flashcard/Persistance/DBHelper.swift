//
//  databaseService.swift
//  flashcard
//
//  Created by Victor Gustafsson on 2022-11-18.
//

import Foundation
import SQLite
import Combine
import UIKit

// viewModel > DBHelper > Deck/CardHelper >
// Skicka med db till deck/cardhelper

class DBHelper {
    
    let decks = Table("decks")
    let id = Expression<Int>("id")
    let name = Expression<String>("deckName")
    
    
    let flashcards = Table("cards")
    let deckId = Expression<Int>("deckId")
    let frontText = Expression<String>("frontText")
    let backText = Expression<String>("backText")
    let questionImage = Expression<Data?>("questionImage")
    let answerImage = Expression<Data?>("answerImage")
    let isCompleted = Expression<Bool>("isCompleted")
    
    
    let cardUpdated = PassthroughSubject<Bool, Never>()
    var database: Connection?
    
    init(database: Connection? = SQLiteDatabase.sharedInstance.database)  {
        
        guard let database = database else { return }
        self.database = database
        
        do {
            try createTable(database: database)
       
        } catch {
            fatalError("No database connection")
        }
        
    }
    
    func createTable(database: Connection?) throws  {
        guard let database = database else {
            throw fatalError("No database")
        }
        
        do{
            try database.run(decks.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(name)
            })
            
            try database.run(flashcards.create(ifNotExists: true) { t in
                t.column(id, primaryKey: true)
                t.column(frontText)
                t.column(backText)
                t.column(deckId)
                t.column(questionImage)
                t.column(answerImage)
                t.column(isCompleted)
                t.foreignKey(deckId, references: decks, id)
            })
            
        } catch {
            print(error)
            
        }
    }
}
