//
//  UIViewControllerExt.swift
//  flashcard
//
//  Created by Victor Gustafsson on 2022-11-25.
//

import Foundation
import UIKit

extension UIViewController {
    
    @objc func hideKeyboardWhenTappedAround() {
         let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
         tap.cancelsTouchesInView = false
         view.addGestureRecognizer(tap)
     }

     @objc func dismissKeyboard() {
         view.endEditing(true)
     }
}
