//
//  ViewController.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/4/23.
//

import UIKit
import RealmSwift


class StartViewController: UIViewController {
    
    // Open the local-only default realm
    let realm = try! Realm()

    @IBOutlet var frontTextField: UITextView!
    
    @IBOutlet var contextTextField: UITextView!
    @IBOutlet var noteTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        let newCard = Card(front: frontTextField.text, context: contextTextField.text, note: noteTextField.text)
        
        
    
        do {
            try realm.write {
                realm.add(newCard)
                print("add")
            }
        } catch {
            print("Error adding new card, \(error)")
        }
        
        frontTextField.text = ""
        contextTextField.text = ""
        noteTextField.text = ""

    }
    
}

