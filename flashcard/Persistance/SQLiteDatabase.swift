//
//  SQLiteDatabase.swift
//  flashcard
//
//  Created by Victor Gustafsson on 2022-11-18.
//

import Foundation
import SQLite



class SQLiteDatabase {
    
    static let sharedInstance = SQLiteDatabase()
    var database: Connection?
    
    init() {
        
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first!
        
        print(path)

        do{
            database = try Connection("\(path)/db.sqlite3")
            
        } catch {
            print(error)
        }

    }
    
}
