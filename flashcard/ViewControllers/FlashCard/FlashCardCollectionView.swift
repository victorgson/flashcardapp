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
        view.dataSource = self
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAndLayout()

    }
    
    let currentIndex = PassthroughSubject<Int, Never>()
    let currentId = PassthroughSubject<Int, Never>()
    let totalItems = PassthroughSubject<Int, Never>()
    let cardIndexToDelete = PassthroughSubject<Int, Never>()
    
    
 
    
}

// TODO: Skapa FlashCardViewModel
extension FlashCardCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FlashCardCollectionViewCell
        
        if let d = data[indexPath.item].questionImage {
            print(d)
            cell.hasQuestionImage = true
            cell.frontImage.image = UIImage(data: d)
        }
        
        if let answerImage = data[indexPath.item].answerImage {
            cell.hasAnswerImage = true
            cell.backImage.image = UIImage(data: answerImage)
        }
  
        cell.frontLabel.text = data[indexPath.item].questionString
        cell.backLabel.text = data[indexPath.item].answerString

        
        if(data[indexPath.item].isCompleted ?? false) {
            cell.completedIcon.isHidden = false
        }
        cell.layout()
        return cell
        
    }
    
    
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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalItems.send(data.count)
        return data.count
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
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
