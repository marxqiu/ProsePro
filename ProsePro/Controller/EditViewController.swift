//
//  EditViewController.swift
//  ProsePro
//
//  Created by 裘渝琛 on 8/6/23.
//

import UIKit
import RealmSwift

class EditViewController: UIViewController {

    
    let realm = try! Realm()
    
    @IBOutlet var frontTextField: UITextView!
    @IBOutlet var contextTextField: UITextView!
    @IBOutlet var noteTextField: UITextView!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    var selectedCard : Card?
    var hasEdits = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frontTextField.delegate = self
        contextTextField.delegate = self
        noteTextField.delegate = self
        saveButton.isHidden = true

        // Do any additional setup after loading the view.
        frontTextField.text = selectedCard?.front
        contextTextField.text = selectedCard?.context
        noteTextField.text = selectedCard?.note
        
        // Replace the back button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(backButtonTapped))
        
    }
    

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        try! realm.write {
            selectedCard?.front = frontTextField.text
            selectedCard?.context = contextTextField.text
            selectedCard?.note = noteTextField.text
        }
        
        // Pop the current view controller off the navigation stack
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backButtonTapped() {
        // If any text view has been edited, show the alert
        if hasEdits {
            let alertController = UIAlertController(title: "Discard changes?", message: "There are unsaved changes. Are you sure you want to discard them?", preferredStyle: .alert)
            let discardAction = UIAlertAction(title: "Discard", style: .destructive) { (_) in
                self.navigationController?.popViewController(animated: true)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(discardAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            // If no text view has been edited, pop the view controller
            self.navigationController?.popViewController(animated: true)
        }
    }

    
    
}


extension EditViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        // Check if any text view's text is changed
        hasEdits = true
        
        saveButton.isHidden = false // If no changes, hide the save button
        
    }
}
