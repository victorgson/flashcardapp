//
//  CardModel.swift
//  flashcard
//
//  Created by Victor Gustafsson on 2022-11-17.
//

import Foundation
import UIKit

struct CardModel {
    var id: Int
    var questionString: String
    var answerString: String
    var questionImage: Data?
    var answerImage: Data?
    var isCompleted: Bool?
}


