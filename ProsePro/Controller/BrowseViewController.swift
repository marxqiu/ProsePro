//
//  BrowseViewController.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/4/23.
//

import UIKit
import RealmSwift


class BrowseViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var cardArray : Results<Card>?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(TwoColumnCell.self, forCellReuseIdentifier: "TwoColumnCell")
        
        // Set the separatorInset to .zero
        tableView.separatorInset = .zero
        
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
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        performSegue(withIdentifier: "goToEdit", sender: self)
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditViewController
        
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCard = cardArray?[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        // This should be the count of your data array.
        // For example: return dataArray.count
        return cardArray?.count ?? 0
    }
    
    func loadCard() {
        
        cardArray = realm.objects(Card.self)
        
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
