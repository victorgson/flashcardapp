//
//  FlashCardCollectionViewCell.swift
//  flashcard
//
//  Created by Victor Gustafsson on 2022-11-17.
//

import UIKit

class FlashCardCollectionViewCell: UICollectionViewCell {
    
    let cardBackTag: Int = 0
    let cardFrontTag: Int = 1
    var hasQuestionImage: Bool?
    var hasAnswerImage: Bool?
    
    var cardViews : (frontView: UIView, backView: UIView)?
    
    let frontView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var frontImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var backImage : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let backView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 10
        return view
    }()
    
    var frontLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var backLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy var completedIcon : UIImageView = {
        let imageView = UIImageView()
        var completed = true
        
        if(completed) {
            let img = UIImage(systemName: "checkmark.circle.fill")!.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = .systemGreen
            imageView.image = img
        }
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    let frontLayoutGuide = UILayoutGuide()
    let backLayoutGuide = UILayoutGuide()
    
    lazy var questionImageConstraints = [ frontImage.topAnchor.constraint(equalTo: frontView.topAnchor, constant: 24),
                                     frontImage.bottomAnchor.constraint(equalTo: frontLayoutGuide.bottomAnchor, constant: 0),
                                     frontImage.leadingAnchor.constraint(equalTo: frontView.leadingAnchor, constant: 16),
                                     frontImage.trailingAnchor.constraint(equalTo: frontView.trailingAnchor, constant: -16),
                                     
                                     frontLabel.leadingAnchor.constraint(equalTo: frontView.leadingAnchor, constant: 16),
                                     frontLabel.trailingAnchor.constraint(equalTo: frontView.trailingAnchor, constant: -16),
                                     frontLabel.bottomAnchor.constraint(equalTo: frontView.bottomAnchor, constant: 0),
                                     frontLabel.topAnchor.constraint(equalTo: frontLayoutGuide.bottomAnchor, constant: 0),
                                     
    ]
    
    lazy var answerImageConstraints = [
        
        backImage.topAnchor.constraint(equalTo: backView.topAnchor, constant: 24),
        backImage.bottomAnchor.constraint(equalTo: backLayoutGuide.bottomAnchor, constant: 0),
        backImage.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
        backImage.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
        
        backLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
        backLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
        backLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: 0),
        backLabel.topAnchor.constraint(equalTo: backLayoutGuide.bottomAnchor, constant: 0)
        
    ]
    
    lazy var noQuestionImageConstraints = [
        frontLabel.leadingAnchor.constraint(equalTo: frontView.leadingAnchor, constant: 16),
        frontLabel.trailingAnchor.constraint(equalTo: frontView.trailingAnchor, constant: -16),
        frontLabel.bottomAnchor.constraint(equalTo: frontView.bottomAnchor, constant: 0),
        frontLabel.topAnchor.constraint(equalTo: frontView.topAnchor, constant: 0),
    ]
    lazy var noAnswerImageConstraints = [
        backLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16),
        backLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16),
        backLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: 0),
        backLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 0),
    ]
    
    
    func layout() {
        
        cardViews = (frontView: frontView, backView: backView)
        
        contentView.addSubviews(backView, frontView, completedIcon)
        
        frontView.addSubviews(frontLabel, frontImage)
        backView.addSubviews(backLabel, backImage)
        
        
        frontView.addLayoutGuide(frontLayoutGuide)
        backView.addLayoutGuide(backLayoutGuide)
        completedIcon.isHidden = true
        
        
        frontLayoutGuide.topAnchor.constraint(equalTo: frontView.topAnchor, constant: 24).isActive = true
        frontLayoutGuide.bottomAnchor.constraint(equalTo: frontView.centerYAnchor, constant: 100).isActive = true
        
        backLayoutGuide.topAnchor.constraint(equalTo: frontView.topAnchor, constant: 24).isActive = true
        backLayoutGuide.bottomAnchor.constraint(equalTo: frontView.centerYAnchor, constant: 100).isActive = true
        
        frontView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        frontView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        frontView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        frontView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        backView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        backView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        backView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
//        backLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 16).isActive = true
//        backLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -16).isActive = true
//        backLabel.topAnchor.constraint(equalTo: backView.topAnchor).isActive = true
//        backLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor).isActive = true
        
        completedIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        completedIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        
        
        if(hasQuestionImage ?? false) {
            NSLayoutConstraint.activate(questionImageConstraints)

        }
        else {
            NSLayoutConstraint.activate(noQuestionImageConstraints)
        }
        
        if(hasAnswerImage ?? false) {
            NSLayoutConstraint.activate(answerImageConstraints)

        }
        else {
            NSLayoutConstraint.activate(noAnswerImageConstraints)
        }
        frontView.isHidden = false
        backView.isHidden = true
        
    }
    
    
    func flipCard() {
        backView.isHidden.toggle()
        frontView.isHidden.toggle()
        
    }
    override func prepareForReuse() {
        frontLabel.text = ""
        backLabel.text = ""
        completedIcon.isHidden = true
        NSLayoutConstraint.deactivate(questionImageConstraints)
        NSLayoutConstraint.deactivate(noQuestionImageConstraints)
        NSLayoutConstraint.deactivate(answerImageConstraints)
        NSLayoutConstraint.deactivate(noAnswerImageConstraints)
        frontImage.image = nil
        backImage.image = nil
        hasAnswerImage = false
        hasQuestionImage = false
  
    }
}
