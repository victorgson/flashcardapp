//
//  TabBarController.swift
//  flashcard
//
//  Created by Victor Gustafsson on 2022-11-15.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let decks = DeckTableViewController(style: .insetGrouped)
        
        let deckItem = UITabBarItem(title: "Decks", image: UIImage(systemName: "rectangle.fill.on.rectangle.fill"), selectedImage: UIImage(systemName: "house.fill"))

        decks.tabBarItem = deckItem

        self.viewControllers = [decks]
    }
}
