//
//  SetsViewController.swift
//  flashcard
//
//  Created by Victor Gustafsson on 2022-11-17.
//

import UIKit
import Combine

// TODO: Skapa ViewModel, MVVM

class DeckTableViewController: UITableViewController, UITableViewDragDelegate {
    
    
    let db = DBDeckHelper()
    
    let vc = PageSheetViewController(isDeck: true)
    
    let viewModel = DeckViewModel()
    
    var cancellables: [AnyCancellable] = []
    
    func bindViewModel () {
        viewModel.$data.sink(receiveValue: {[weak self] result in
//            self?.data = result.reversed()
            self?.tableView.reloadData()

        }).store(in: &cancellables)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        bindViewModel()
        viewModel.getAllDecks()
        
        setupTableView()
                
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.add, style: .done, target: self, action: #selector(askForDeckName))
        
        vc.action.sink(receiveValue: { [weak self] result in
            self?.viewModel.addDeck(deckName: result.deckName ?? "")
            
          
            self?.viewModel.getAllDecks()
            self?.tableView.reloadData()
        }).store(in: &cancellables)
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bindViewModel()
        
    }
    
    @objc func askForDeckName(){
        vc.modalPresentationStyle = .pageSheet
        vc.sheetPresentationController?.detents = [.medium()]
//        vc.sheetPresentationController
        navigationController?.present(vc, animated: true)

      
    }
    
    func addDeck(deckName: String) {
       
        
    }
}

extension DeckTableViewController {
    func setupTableView() {
        tableView.register(DeckTableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = .zero
        tableView.separatorColor = .label
        tableView.rowHeight = 150
        tableView.estimatedRowHeight = 150
        tableView.sectionHeaderHeight = 0
        
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = Int(viewModel.data[indexPath.row].id)
        let vc = FlashCardViewController(deckId: index)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let index = viewModel.data[indexPath.row].id
            viewModel.deleteDeck(withId: index)
            viewModel.getAllDecks()
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let mover = viewModel.data.remove(at: sourceIndexPath.row)
        viewModel.data.insert(mover, at: destinationIndexPath.row)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DeckTableViewCell
        cell.titleLabel.text = viewModel.data[indexPath.row].deckName
        
        let deckId = viewModel.data[indexPath.row].id
        let numberOfCards = viewModel.numberOfCardsIn(deck: deckId)

        switch numberOfCards {
        case 1:
            cell.termsLabel.text = "\(numberOfCards) card"
        default:
            cell.termsLabel.text = "\(numberOfCards) cards"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = viewModel.data[indexPath.section]
        return [ dragItem ]
    }
}
