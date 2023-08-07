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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        let frontText = frontTextField.text
        let contextText = contextTextField.text
        let noteText = noteTextField.text
        
        Task {
            let cardManager = CardManager()
            if let frontText = frontText, let contextText = contextText, let noteText = noteText {
                await cardManager.addCard(frontText, contextText, noteText)
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

