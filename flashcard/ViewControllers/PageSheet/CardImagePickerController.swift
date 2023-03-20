//
//  CardImagePickerController.swift
//  flashcard
//
//  Created by Victor Gustafsson on 2023-01-18.
//

import Foundation
import UIKit
import Combine

enum Identifier {
    case question
    case answer
}

class CardImagePickerController: UIImagePickerController {
    
    var identifier: Identifier?
    
    let questionAction = PassthroughSubject<UIImage, Never>()
    let answerAction = PassthroughSubject<UIImage, Never>()
    
        
    convenience init(sourceType: SourceType) {
        self.init()
        self.sourceType = sourceType
    }
    override func viewDidLoad() {
        self.delegate = self
        self.allowsEditing = true
    }
    
}

extension CardImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if(identifier == .question) {
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                questionAction.send(editedImage)
        
            } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
     
                questionAction.send(originalImage)
            }
        }
        if (identifier == .answer) {
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
      
                answerAction.send(editedImage)
            } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
   
                answerAction.send(originalImage)
            }
        }
        dismiss(animated: true)
    }
}
