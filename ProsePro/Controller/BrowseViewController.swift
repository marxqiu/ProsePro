//
//  BrowseViewController.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/4/23.
//

import UIKit
import RealmSwift


class BrowseViewController: UITableViewController {
    

    
    var cardArray : Results<Card>?
    
    var isEditingMode = false
    
    let cardManager = CardManager()

    @IBOutlet var selectionButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(TwoColumnCell.self, forCellReuseIdentifier: "TwoColumnCell")
        
        // Set the separatorInset to .zero
        tableView.separatorInset = .zero
        
        
        tableView.allowsSelectionDuringEditing = true
        tableView.allowsMultipleSelectionDuringEditing = true
        
        

        
        loadCard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCard()
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Dequeue a reusable cell from the table view's pool of cells, with identifier "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "TwoColumnCell", for: indexPath) as! TwoColumnCell
        
        // Customize the cell.
        // For example, you can set the cell's text label to a text from your data source.
        // Assuming that you have a data array:
        // cell.textLabel?.text = dataArray[indexPath.row]
        
        if let card = cardArray?[indexPath.row] {
            cell.label1.text = card.front
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            
            let dateCreatedString = dateFormatter.string(from: card.dateCreated)
            
            cell.label2.text = dateCreatedString
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        // This should be the count of your data array.
        // For example: return dataArray.count
        return cardArray?.count ?? 0
    }
    
    
    //selection
    
    @IBAction func didTapSelect(_ sender: UIBarButtonItem) {
        
        isEditingMode.toggle()
        tableView.setEditing(isEditingMode, animated: true)
        
        
        if isEditingMode {
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Select All", style: .plain, target: self, action: #selector(didTapSelectAll))
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapSelect))
            
            self.navigationController?.setToolbarHidden(false, animated: false)
            let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapDelete))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            self.toolbarItems = [flexibleSpace, deleteButton]


        } else {
            navigationItem.leftBarButtonItem = nil
            let selectImage = UIImage(systemName: "checkmark.circle")
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: selectImage, style: .plain, target: self, action: #selector(didTapSelect))
            navigationItem.title = "Browse"
            self.navigationController?.setToolbarHidden(true, animated: false)
        }
        
        
    }
    
    @objc func didTapDelete() {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            var cardsToDelete = [Card]()
            for indexPath in selectedIndexPaths {
                if let card = cardArray?[indexPath.row] {
                    cardsToDelete.append(card)
                }
            }
            
            do {
                try cardManager.deleteCards(cardsToDelete)
            } catch {
                print("Error deleting cards, \(error)")
                // Ideally, show an error message to the user or handle the error appropriately
            }
            
            tableView.reloadData()
            updateNavBar()
        }
    }
    
    @objc func didTapSelectAll() {
        for row in 0..<tableView.numberOfRows(inSection: 0) {
            tableView.selectRow(at: IndexPath(row: row, section: 0), animated: false, scrollPosition: .none)
        }
        
        updateNavBar()
    }
    

    // A helper method to update the navigation bar
    func updateNavBar() {
        let selectedRowsCount = tableView.indexPathsForSelectedRows?.count ?? 0
        let totalRowsCount = tableView.numberOfRows(inSection: 0)
        
        // Format a string to show the count of selected rows and total rows
        let navBarTitle = "\(selectedRowsCount)/\(totalRowsCount)"
        
        // Set the navigation bar title
        navigationItem.title = navBarTitle
    }

    
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            updateNavBar()
        }
    }

    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            performSegue(withIdentifier: "goToEdit", sender: self)
        } else {
            
            updateNavBar()
        }
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditViewController
        
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCard = cardArray?[indexPath.row]
        }
    }
    
    
    
    func loadCard() {
        
        cardArray = cardManager.loadCards()
        
        tableView.reloadData()
    }


}


//MARK: - SearchBarDelegate
extension BrowseViewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        cardArray = cardArray?.filter("front CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadCard()
            
            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
