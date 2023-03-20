//
//  FlashCardCollectionViewCollectionViewController.swift
//  flashcard
//
//  Created by Victor Gustafsson on 2022-11-17.
//

import UIKit
import Combine


class FlashCardCollectionView: UIView {
    var data: [CardModel]!

    let db = DBCardHelper()
    
    let flashCardViewModel: FlashCardViewModel
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.alwaysBounceHorizontal = false
        view.delegate = self
        view.dataSource = flashCardViewModel
        return view
    }()
    
    init(flashCardViewModel: FlashCardViewModel) {
        self.flashCardViewModel = flashCardViewModel
        super.init(frame: .zero)
        setupAndLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    let currentIndex = PassthroughSubject<Int, Never>()
    let currentId = PassthroughSubject<Int, Never>()
    let totalItems = PassthroughSubject<Int, Never>()
    let cardIndexToDelete = PassthroughSubject<Int, Never>()
    
    
 
    
}
extension FlashCardCollectionView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let transitionOptions = UIView.AnimationOptions.transitionFlipFromRight
        
        UIView.transition(with: self, duration: 0.5, options: transitionOptions) {
   
            let cell = collectionView.cellForItem(at: indexPath) as! FlashCardCollectionViewCell
            cell.flipCard()
            
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentIndex.send(indexPath.item)
        currentId.send(data[indexPath.item].id)
    }
        
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.frame.width
        let parentHeight = self.frame.height
        return CGSize(width: cellWidth, height: parentHeight)
    }
}

extension FlashCardCollectionView {
    
    func setupAndLayout() {
        self.addSubviews(collectionView)
        collectionView.register(FlashCardCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
}
