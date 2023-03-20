//
//  FlashCardViewModel.swift
//  flashcard
//
//  Created by Victor Gustafsson on 2023-03-20.
//

import UIKit


class FlashCardViewModel: NSObject, UICollectionViewDataSource {
    
    let viewModel: CardViewModel
    init(viewModel: CardViewModel) {
        self.viewModel = viewModel
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCards()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FlashCardCollectionViewCell else {
            return FlashCardCollectionViewCell()
        }
        cell.item = viewModel.data[indexPath.row]
        return cell
    }
}
