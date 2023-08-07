//
//  ViewController.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/4/23.
//

import UIKit
import RealmSwift


class StartViewController: UIViewController {
    
    let cardManager = CardManager()

    @IBOutlet var frontTextField: UITextView!
    
    @IBOutlet var contextTextField: UITextView!
    @IBOutlet var noteTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        Task {
            do {
                try await self.cardManager.addCard(frontTextField.text, contextTextField.text, noteTextField.text)
                refresh()
            } catch {
                print("Error adding new card, \(error)")
            }
        }
    }




    
    func refresh(){
        frontTextField.text = ""
        contextTextField.text = ""
        noteTextField.text = ""
    }
    
}

