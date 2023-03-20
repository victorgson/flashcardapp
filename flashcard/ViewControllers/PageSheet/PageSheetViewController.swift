//
//  PageSheetViewController.swift
//  flashcard
//
//  Created by Victor Gustafsson on 2022-11-25.
//

import UIKit
import Combine


class PageSheetViewController: UIViewController{
    
    let db = DBCardHelper()
//    let cardImagePickerController = CardImagePickerController()

    var isDeck: Bool!
    var isEditMode: Bool!

    var imageForQuestion: UIImage?
    var imageForAnswer: UIImage?
    
    var cameraVC = CardImagePickerController(sourceType: .camera)
    var libraryVC = CardImagePickerController(sourceType: .photoLibrary)
    
    // Combine
    var cancellables: [AnyCancellable] = []
    let action = PassthroughSubject<(deckName: String?, frontText: String?, backText: String?, imageForQuestion: UIImage?, imageforAnswer: UIImage?), Never>()
    let editAction = PassthroughSubject<(updatedFrontText: String?, updatedBackText: String?), Never>()
    let imageAction = PassthroughSubject<UIImage, Never>()
    
    let topLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false;
        label.textAlignment = .center
        return label
    }()
    
    let deckNameTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Enter deck name..."
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .secondarySystemBackground
        return tf
        
    }()
    
    let frontCardTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Question"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .secondarySystemBackground
        return tf
    }()
    
    let backCardTextField : UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Answer"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .secondarySystemBackground
        return tf
    }()
    
    let createButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: "AccentColor")
        return button
    }()
    
    lazy var addImageForQuestion : UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        
        button.setImage(UIImage(systemName: "camera.circle.fill", withConfiguration: config), for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.accessibilityIdentifier = "question"
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    lazy var addImageForAnswer : UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        
        button.setImage(UIImage(systemName: "camera.circle.fill", withConfiguration: config), for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.accessibilityIdentifier = "answer"
        return button
    }()
    
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isPagingEnabled = true
//        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        return view
        
    }()
    
    private lazy var contentView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
   
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(isDeck: Bool = true, isEditMode: Bool = false){
        super.init(nibName: nil, bundle: nil)
        self.isDeck = isDeck
        self.isEditMode = isEditMode
        
        if isDeck {
            self.layoutForDeck()
        } else if isEditMode {
            self.layoutForEditCard()
        }
        else {
            self.layoutForCard()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        createButton.addTarget(self, action: #selector(handleButtonPressed), for: .touchUpInside)
        addImageForQuestion.addTarget(self, action: #selector(showImagePickerController(_ :)), for: .touchUpInside)
        addImageForAnswer.addTarget(self, action: #selector(showImagePickerController(_ :)), for: .touchUpInside)
        view.backgroundColor = .systemBackground
        
//        imageForAnswer = nil
//        imageForQuestion = nil
        
        observeImagesFromPicker()
        
    }
    
    override func viewDidLayoutSubviews() {
        addImageForQuestion.layer.masksToBounds = true
        addImageForQuestion.layer.cornerRadius = addImageForQuestion.frame.size.width / 2
        
        addImageForAnswer.layer.masksToBounds = true
        addImageForAnswer.layer.cornerRadius = addImageForQuestion.frame.size.width / 2
    }
    
    func layoutForDeck() {
        view.addSubviews(topLabel, deckNameTextField, createButton)
        
        createButton.setTitle("Create Deck", for: .normal)
        topLabel.text = "Create a new deck"
        topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        deckNameTextField.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 32).isActive = true
        deckNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        deckNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        deckNameTextField.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        createButton.topAnchor.constraint(equalTo: deckNameTextField.bottomAnchor, constant: 32).isActive = true
        createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
    }
    
    func layoutForCard() {
        
        view.addSubviews(topLabel, frontCardTextField, backCardTextField, createButton, addImageForQuestion, addImageForAnswer)
        
        createButton.setTitle("Create Card", for: .normal)
        topLabel.text = "Create a new card"
        
        topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        frontCardTextField.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 32).isActive = true
        frontCardTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        frontCardTextField.trailingAnchor.constraint(equalTo: addImageForQuestion.leadingAnchor, constant: -10).isActive = true
        frontCardTextField.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        addImageForQuestion.centerYAnchor.constraint(equalTo: frontCardTextField.centerYAnchor, constant: 0).isActive = true
        addImageForQuestion.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        addImageForQuestion.widthAnchor.constraint(equalToConstant: 60).isActive = true
        addImageForQuestion.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        backCardTextField.topAnchor.constraint(equalTo: frontCardTextField.bottomAnchor, constant: 8).isActive = true
        backCardTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        backCardTextField.trailingAnchor.constraint(equalTo: addImageForAnswer.leadingAnchor, constant: -10).isActive = true
        backCardTextField.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        
        
        addImageForAnswer.centerYAnchor.constraint(equalTo: backCardTextField.centerYAnchor, constant: 0).isActive = true
        addImageForAnswer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        addImageForAnswer.widthAnchor.constraint(equalToConstant: 60).isActive = true
        addImageForAnswer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        createButton.topAnchor.constraint(equalTo: backCardTextField.bottomAnchor, constant: 32).isActive = true
        createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        
    }
    
    func populateEditCard(cardId: Int) {
        let viewModel = CardViewModel()
        
        viewModel.getCard(id: cardId) { card in
            frontCardTextField.text = card.questionString
            backCardTextField.text = card.answerString
        }
    }
    
    func layoutForEditCard() {
        
        view.addSubviews(topLabel, frontCardTextField, backCardTextField, createButton)
        
        createButton.setTitle("Save Card", for: .normal)
        topLabel.text = "Edit card"
        
        topLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        topLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        topLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        frontCardTextField.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 32).isActive = true
        frontCardTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        frontCardTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        frontCardTextField.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        backCardTextField.topAnchor.constraint(equalTo: frontCardTextField.bottomAnchor, constant: 8).isActive = true
        backCardTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        backCardTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        backCardTextField.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        createButton.topAnchor.constraint(equalTo: backCardTextField.bottomAnchor, constant: 32).isActive = true
        createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32).isActive = true
        
    }
    
    @objc func handleButtonPressed() {
        if isDeck {
            action.send((deckName: deckNameTextField.text, frontText: nil, backText: nil, imageForQuestion: nil, imageforAnswer: nil))
        } else if isEditMode {
            editAction.send((updatedFrontText: frontCardTextField.text, updatedBackText: backCardTextField.text))
        }
        else {

            if(imageForQuestion != nil && imageForAnswer != nil) {
                action.send((deckName: nil, frontText: frontCardTextField.text, backText: backCardTextField.text, imageForQuestion: imageForQuestion, imageforAnswer: imageForAnswer))
            } else if (imageForQuestion != nil) {
                action.send((deckName: nil, frontText: frontCardTextField.text, backText: backCardTextField.text, imageForQuestion: imageForQuestion, imageforAnswer: nil))
            } else if (imageForAnswer != nil) {
                action.send((deckName: nil, frontText: frontCardTextField.text, backText: backCardTextField.text, imageForQuestion: nil, imageforAnswer: imageForAnswer))
            } else {
                action.send((deckName: nil, frontText: frontCardTextField.text, backText: backCardTextField.text, imageForQuestion: nil, imageforAnswer: nil))
            }
            
            resetImages()
            resetTextField()
        }
        dismiss(animated: true, completion: {
        })
    }
    
    func resetImages() {
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        self.addImageForQuestion.setImage(UIImage(systemName: "camera.circle.fill", withConfiguration: config), for: .normal)
        self.addImageForAnswer.setImage(UIImage(systemName: "camera.circle.fill", withConfiguration: config), for: .normal)
               self.imageForAnswer = nil
               self.imageForQuestion = nil
    }
    
    func resetTextField () {
        deckNameTextField.text = ""
        frontCardTextField.text = ""
        backCardTextField.text = ""
    }
}

extension PageSheetViewController {
    
    func setButtonImage(image: UIImage, button: UIButton){
        button.setImage(image, for: .normal)
    }
    
    @objc
    func showImagePickerController(_ sender: UIButton) {
        let photoLibrary = UIAction(title: "Choose from Library", image: UIImage(systemName: "camera")) { [weak self] _ in

            if(sender.accessibilityIdentifier == "question") {
                self?.libraryVC.identifier = Identifier.question
                
            } else if (sender.accessibilityIdentifier == "answer"){
                self?.libraryVC.identifier = Identifier.answer
            }
            self?.present(self!.libraryVC, animated: true, completion: nil)
        }
        
        let camera = UIAction(title: "Take with camera", image: UIImage(systemName: "camera")) { [weak self] _ in
          
            if(sender.accessibilityIdentifier == "question") {
                self?.cameraVC.identifier = Identifier.question
                
            } else if (sender.accessibilityIdentifier == "answer"){
                self?.cameraVC.identifier = Identifier.answer
            }
            self?.present(self!.cameraVC, animated: true, completion: nil)
        }
        let menu = UIMenu(title: "", children: [photoLibrary, camera])
        sender.menu = menu
 
    }
    
}

// Observe PassthroughSubjects, tänk om, kanske closures?
extension PageSheetViewController {
    func observeImagesFromPicker() {
        
        cameraVC.questionAction.sink{ [weak self] image in
            print(image)
            self?.imageForQuestion = image
            self?.setButtonImage(image: image, button: self!.addImageForQuestion)
        }.store(in: &cancellables)

        cameraVC.answerAction.sink(receiveValue: {[weak self] image in
            print(image)
            self?.imageForAnswer = image
            self?.setButtonImage(image: image, button: self!.addImageForAnswer)
        }).store(in: &cancellables)
        
        libraryVC.questionAction.sink{ [weak self] image in
            print(image)
            self?.imageForQuestion = image
            self?.setButtonImage(image: image, button: self!.addImageForQuestion)
        }.store(in: &cancellables)

        libraryVC.answerAction.sink(receiveValue: {[weak self] image in
            print(image)
            self?.imageForAnswer = image
            self?.setButtonImage(image: image, button: self!.addImageForAnswer)
        }).store(in: &cancellables)
    }
}


