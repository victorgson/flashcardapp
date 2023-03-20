//
//  SetsTableViewCell.swift
//  flashcard
//
//  Created by Victor Gustafsson on 2022-11-17.
//

import UIKit

class DeckTableViewCell: UITableViewCell {
    
    let container : UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let termsLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var completed : UIImageView = {
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func layout(){
        backgroundColor = .systemGray5
        selectionStyle = .default
        contentView.addSubviews(titleLabel, termsLabel, completed)
        
        NSLayoutConstraint.activate([
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            
            termsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            termsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            completed.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            completed.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16)
        ])
    }
}
