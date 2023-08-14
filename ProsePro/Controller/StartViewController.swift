//
//  ViewController.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/4/23.
//

import UIKit
import RealmSwift
import CommonMarkAttributedString
import RxSwift

class StartViewController: UIViewController {
    
    

    @IBOutlet var frontTextField: UITextView!
    
    @IBOutlet var contextTextField: UITextView!
    @IBOutlet var noteTextField: UITextView!
    
    @IBOutlet var cardTypeTableView: UITableView!
    
    
    let disposeBag = DisposeBag()
    let cardManager = CardManager()
    
    //indicator label
    let pendingTasksLabel = UILabel()
    
    var items: [TaskType] = TaskType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cardTypeTableView.dataSource = self
        cardTypeTableView.delegate = self
        cardTypeTableView.allowsMultipleSelection = true
        
        
        //this cardManager is
        cardManager.pendingTasksCountObservable
            .subscribe(onNext: { [weak self] count in
                self?.updatePendingTasksLabel(count)
            })
            .disposed(by: disposeBag)

    }
    
    func updatePendingTasksLabel(_ count: Int) {
        // If the count is 0, remove the label item and return
        if count == 0 {
            navigationItem.rightBarButtonItems = navigationItem.rightBarButtonItems?.filter { !($0.customView is UILabel) }
            return
        }
        
        // Create the UILabel
        let label = UILabel()
        label.text = "Pending Tasks: \(count)"
        label.sizeToFit()
        
        // Wrap the UILabel in a UIBarButtonItem
        let labelItem = UIBarButtonItem(customView: label)
        
        // Get the existing right bar button items (if any), excluding any existing label items
        var rightBarButtonItems = navigationItem.rightBarButtonItems?.filter { !($0.customView is UILabel) } ?? []
        
        // Add the new label item to the right bar button items
        rightBarButtonItems.append(labelItem)
        
        // Set the updated right bar button items
        navigationItem.rightBarButtonItems = rightBarButtonItems
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
            //let cardManager = CardManager()
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

