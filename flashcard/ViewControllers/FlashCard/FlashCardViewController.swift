//
//  FlashCardCollectionViewController.swift
//  flashcard
//
//  Created by Victor Gustafsson on 2022-11-17.
//

import UIKit
import Combine


class FlashCardViewController: UIViewController {
    
    lazy var practiceMoreBtn : UIButton = {
        let btn = UIButton();
        btn.translatesAutoresizingMaskIntoConstraints = false;
        btn.setTitle("Practice more", for: .normal)
        btn.backgroundColor = .systemRed
        btn.layer.cornerRadius = 20
        return btn;
    }()
    
    lazy var markCompleteBtn : UIButton = {
        let btn = UIButton();
        btn.translatesAutoresizingMaskIntoConstraints = false;
        btn.setTitle("Complete", for: .normal)
        btn.backgroundColor = .systemGreen
        btn.layer.cornerRadius = 20
        return btn;
    }()
    

    let pageControl = UIPageControl()
    
    let viewModel = CardViewModel()
    lazy var flashCardViewModel = FlashCardViewModel(viewModel: viewModel)
    
    lazy var vc = PageSheetViewController(isDeck: false)
    
    lazy var editCardVC = PageSheetViewController(isDeck: false, isEditMode: true)
    
    let layoutGuide = UILayoutGuide()
    
    lazy var collectionView : FlashCardCollectionView = {
        var collectionView = FlashCardCollectionView(flashCardViewModel: flashCardViewModel)
        return collectionView
    }()
    
//    lazy var delete = UIAction(title: "Delete", image: UIImage(systemName: "trash.fill")) { [weak self] _ in
//        guard let self else { return }
//        self.viewModel.deleteCard(model: CardModel(id: (self.currentId)!, questionString: "String", answerString: "", isCompleted: false))
//        self.viewModel.getAllCards(inDeck: (self.deckId)!)
//    }
    
//    lazy var showComplete = UIAction(title: "Show/Hide all completed cards", image: UIImage(systemName: "checkmark.circle.fill")) { [weak self] _ in
//
//        self?.handleShowCompletedCards()
//
//   }
//
//    lazy var share = UIAction(title: "Share deck", image: UIImage(systemName: "square.and.arrow.up.fill")) {[weak self] _ in
//
//        //To be implemented
//
//   }
//
//    lazy var edit = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) {[weak self] _ in
//        self?.editCardVC.modalPresentationStyle = .pageSheet
//        self?.editCardVC.sheetPresentationController?.detents = [.medium()]
//        self?.navigationController?.present(self!.editCardVC, animated: true)
//
//        self?.editCardVC.populateEditCard(cardId: self!.currentId!) // Fixa om de inte finns något kort
//
//    }
    
    var deckId: Int?
    var currentId: Int?
    var currentIndex: Int?
    
    var showingCompletedCards = false

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    init(deckId: Int) {
       self.deckId = deckId
        super.init(nibName: nil, bundle: nil)
   }

    private var cancellables: [AnyCancellable] = []
    
    func bindViewModel () {
//        viewModel.getAllCards(inDeck: deckId!)
        viewModel.$data.sink { [weak self] result in
            self?.collectionView.data = result.shuffled()
            self?.collectionView.collectionView.reloadData()
        }.store(in: &cancellables)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
       
        if let id = deckId {
            viewModel.getCardsWithoutCompleted(inDeck: id)
        }
        
        guard let deckId = deckId else { return }
        vc.action.sink(receiveValue: { [weak self] result in
            self?.viewModel.addCard(model: CardModel(id: deckId, questionString: result.frontText!, answerString: result.backText!, questionImage: result.imageForQuestion?.pngData(), answerImage:  result.imageforAnswer?.pngData() ,isCompleted: false ))
            self?.viewModel.getCardsWithoutCompleted(inDeck: deckId)
            self?.collectionView.collectionView.reloadData()
          
        }).store(in: &cancellables)
        
        observeCardToDelete()
        observePageControlInputs()
        observeCurrentId()
        setupAndLayout()
        setupMenu()
        
        markCompleteBtn.addTarget(self, action: #selector(completePressed), for: .touchUpInside)
        practiceMoreBtn.addTarget(self, action: #selector(practicePressed), for: .touchUpInside)
        
    }
    
    func setupMenu() {

 
        vc.editAction.sink { [weak self] result in
            
            self?.viewModel.updateCard(model: CardModel(id: self!.currentId!, questionString: result.updatedFrontText!, answerString: result.updatedBackText!, isCompleted: false) )
            
            self?.viewModel.getAllCards(inDeck: self!.deckId!)
            
            self?.collectionView.collectionView.reloadData()
           
        }.store(in: &cancellables)
        
        let config = UIImage.SymbolConfiguration(textStyle: .title2)
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        let btnImage = UIImage(systemName: "ellipsis.circle.fill", withConfiguration: config)
        
        button.setImage(btnImage, for: .normal)
        button.showsMenuAsPrimaryAction = true
        //button.menu = UIMenu(title:"", children: [edit, delete, showComplete, share])

        let add = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        let addImage = UIImageView(image: UIImage(systemName: "plus.circle", withConfiguration: config))
        addImage.preferredSymbolConfiguration = config
        add.setImage(addImage.image, for: .normal)
        
        add.addTarget(self, action: #selector(askForNewCard), for: .touchUpInside)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: button), UIBarButtonItem(customView: add)]
        
    }
    
    func handleShowCompletedCards() {
        
        showingCompletedCards.toggle()
        guard let id = deckId else { return }
        if(showingCompletedCards) {
            viewModel.getAllCards(inDeck: id)
        } else {
            viewModel.getCardsWithoutCompleted(inDeck: id)
        }
    }
       
    
    @objc
    func practicePressed() {
        guard let index = currentId else { return }
        viewModel.setComplete(complete: false, id: index)
        nextCard()
        viewModel.getAllCards(inDeck: deckId!)
    }
    
    @objc
    func completePressed() {
        guard let index = currentId else { return }
        viewModel.setComplete(complete: true, id: index)
        nextCard()
        
        // This causes them to randomize again, figure out a way to hide cards without having to get all new data everytime
        viewModel.getCardsWithoutCompleted(inDeck: deckId!)
    }
    
    func nextCard() {
        if(pageControl.currentPage < pageControl.numberOfPages - 1) {
            collectionView.collectionView.scrollToItem(at: .init(item: pageControl.currentPage + 1, section: 0), at: .centeredHorizontally, animated: true)
        }

    }
    
    func observeCurrentIndex() {
        collectionView.currentIndex.sink { [weak self] index in
            self?.currentIndex = index
        }.store(in: &cancellables)
    }
    
    func observeCurrentId() {
        collectionView.currentId.sink { [weak self] id in
            self?.currentId = id
        }.store(in: &cancellables)
    }
    
    func observeCardToDelete() {
        collectionView.cardIndexToDelete.sink { [weak self] index in
            self?.viewModel.deleteCard(model: CardModel(id: index, questionString: "", answerString: "", isCompleted: false))
            self?.collectionView.collectionView.reloadData()
            self?.viewModel.getCardsWithoutCompleted(inDeck: self!.deckId!)
        }.store(in: &cancellables)
    }
    
    func observePageControlInputs() {
        collectionView.currentIndex.sink { [weak self] index in
            self?.pageControl.currentPage = index
            self?.currentIndex = index
        }.store(in: &cancellables)
        
        collectionView.totalItems.sink { [weak self] totalItems in
            self?.pageControl.numberOfPages = totalItems
            
            if(totalItems <= 0) {
                self?.practiceMoreBtn.isHidden = true
                self?.markCompleteBtn.isHidden = true
                self?.collectionView.collectionView.reloadData()
            } else {
                self?.practiceMoreBtn.isHidden = false
                self?.markCompleteBtn.isHidden = false
            }
        }.store(in: &cancellables)
    }
    
    @objc func askForNewCard() {
        vc.modalPresentationStyle = .pageSheet
        vc.sheetPresentationController?.detents = [.large()]
        present(vc, animated: true)
    }
}

extension FlashCardViewController {

    func setupAndLayout() {
        view.backgroundColor = .systemBackground
        view.addLayoutGuide(layoutGuide)
        view.addSubviews(collectionView, pageControl, practiceMoreBtn, markCompleteBtn)
        
        layoutGuide.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        layoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
      
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        pageControl.pageIndicatorTintColor = .tertiaryLabel
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        practiceMoreBtn.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16).isActive = true
        practiceMoreBtn.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: 70).isActive = true
        practiceMoreBtn.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor, constant: 16).isActive = true
        practiceMoreBtn.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -16 ).isActive = true
        
        markCompleteBtn.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16).isActive = true
        markCompleteBtn.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: 70).isActive = true
        markCompleteBtn.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 16).isActive = true
        markCompleteBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16 ).isActive = true
        
        
    }
}


