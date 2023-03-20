//
//  UIViewExt.swift
//  flashcard
//
//  Created by Victor Gustafsson on 2022-11-17.
//

import Foundation
import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...){
        views.forEach({self.addSubview($0)})
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0.5, height: 1)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
}
