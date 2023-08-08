//
//  ViewController.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/4/23.
//

import UIKit
import RealmSwift
import CommonMarkAttributedString

class StartViewController: UIViewController {
    
    

    @IBOutlet var frontTextField: UITextView!
    
    @IBOutlet var contextTextField: UITextView!
    @IBOutlet var noteTextField: UITextView!
    
    @IBOutlet var cardTypeTableView: UITableView!
    
    
    var items: [TaskType] = TaskType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cardTypeTableView.dataSource = self
        cardTypeTableView.delegate = self
        cardTypeTableView.allowsMultipleSelection = true
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        var taskTypeArray = [TaskType]()
        
        if let selectedIndexPaths = cardTypeTableView.indexPathsForSelectedRows {
            
            for indexPath in selectedIndexPaths {
                let taskType = items[indexPath.row]
                taskTypeArray.append(taskType)
            }
        }
    
        let frontText = frontTextField.text
        let contextText = contextTextField.text
        let noteText = noteTextField.text
        
        Task {
            let cardManager = CardManager()
            if let frontText = frontText, let contextText = contextText, let noteText = noteText {
                await cardManager.addCard(frontText, contextText, noteText, taskTypeArray)
            }
            
        }

        // Refresh UI immediately after addButtonPressed is called
        self.refresh()
    }


    func refresh(){
        frontTextField.text = ""
        contextTextField.text = ""
        noteTextField.text = ""
    }
    
}

extension StartViewController: UITableViewDataSource, UITableViewDelegate {
  
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // Configure the cell
        cell.textLabel?.text = items[indexPath.row].rawValue
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}

