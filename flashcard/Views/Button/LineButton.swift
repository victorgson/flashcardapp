//
//  LineButton.swift
//  flashcard
//
//  Created by Victor Gustafsson on 2023-01-19.
//

import UIKit

class LineButton: UIButton {

    
    override var isSelected: Bool {
        didSet {
            line.backgroundColor = isSelected ? UIColor(named: "grey") : UIColor(named: "black")
        }
    }
    
    private lazy var line: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(.black, for: .selected)
        setTitleColor(.black, for: .normal)
        //titleLabel?.font = UIFont(name: Font.Family.bold, size: Font.Size.headline3)

        addSubview(line)
        NSLayoutConstraint.activate([
            line.heightAnchor.constraint(equalToConstant: 2),
            line.leadingAnchor.constraint(equalTo: leadingAnchor),
            line.trailingAnchor.constraint(equalTo: trailingAnchor),
            line.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}
