//
//  DBHelperProtocol.swift
//  flashcard
//
//  Created by Victor Gustafsson on 2023-01-11.
//

import Foundation

protocol DBHelperProtocol {
    associatedtype Model
    func add(model: Model)
    func delete(model: Model)
    func update(model: Model)
    func getItem(id: Int, completion: (Model) -> Void)
    func getItems(completion: ([Model]) -> Void)
}

protocol DBCardProtocol: DBHelperProtocol {
    func updateCompleted(cardId: Int, isCompleted: Bool)
    func getItems(deckId : Int, completion: ([Model]) -> Void)
}

protocol DBDeckProtocol: DBHelperProtocol {
    func delete(deckId: Int , model: Model)
}


